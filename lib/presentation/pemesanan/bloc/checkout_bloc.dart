import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/request/customer/pembayaran_request_model.dart';
import 'package:pempekapp/data/models/request/customer/pemesanan_request_model.dart';
import 'package:pempekapp/data/repository/pembayaran_repository.dart';
import 'package:pempekapp/data/repository/pemesanan_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final PemesananRepository pemesananRepository;
  final PembayaranRepository pembayaranRepository;

  CheckoutBloc({
    required this.pemesananRepository,
    required this.pembayaranRepository,
  }) : super(CheckoutInitial()) {
    on<CheckoutSubmitted>((event, emit) async {
      emit(CheckoutLoading());

      final pemesananResult = await pemesananRepository.create(
        event.pemesananRequest as PemesananRequestModel,
      );
      return pemesananResult.fold(
        (failure) => emit(CheckoutFailure(error: failure)),
        (pemesananId) async {
          final updatedPembayaran = event.pembayaranRequest.copyWith(
            pemesananId: int.parse(pemesananId),
          );
          final pembayaranResult = await pembayaranRepository.create(
            pemesananId: updatedPembayaran.pemesananId!,
            buktiBayar: updatedPembayaran.buktiBayar!,
          );

          pembayaranResult.fold(
            (failure) => emit(CheckoutFailure(error: failure)),
            (_) => emit(CheckoutSuccess(message: 'Checkout successful!')),
          );
        },
      );
    });
  }
}
