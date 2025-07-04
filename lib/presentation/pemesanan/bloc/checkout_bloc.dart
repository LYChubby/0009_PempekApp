import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/request/customer/pembayaran_request_model.dart';
import 'package:pempekapp/data/models/request/customer/pemesanan_request_model.dart';
import 'package:pempekapp/data/models/request/transaksi/transaksi_request_model.dart';
import 'package:pempekapp/data/repository/pembayaran_repository.dart';
import 'package:pempekapp/data/repository/transaksi_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final TransaksiRepository transaksiRepository;
  final PembayaranRepository pembayaranRepository;

  CheckoutBloc({
    required this.transaksiRepository,
    required this.pembayaranRepository,
  }) : super(CheckoutInitial()) {
    on<CheckoutSubmitted>((event, emit) async {
      emit(CheckoutLoading());

      final transaksiResult = await transaksiRepository.create(
        event.transaksiRequest,
      );

      await transaksiResult.fold(
        (failure) async {
          emit(CheckoutFailure(error: failure));
        },
        (transaksiId) async {
          final pembayaranResult = await pembayaranRepository.create(
            transaksiId: transaksiId,
            buktiBayar: event.pembayaranRequest.buktiBayar!,
          );

          pembayaranResult.fold(
            (failure) => emit(CheckoutFailure(error: failure)),
            (_) => emit(CheckoutSuccess(message: 'Checkout berhasil!')),
          );
        },
      );
    });
  }
}
