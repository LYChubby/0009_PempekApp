import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/response/riwayat_transaksi_response_model.dart';
import 'package:pempekapp/data/models/response/transaksi_response_model.dart';
import 'package:pempekapp/data/repository/riwayat_pesanan_repository.dart';

part 'riwayat_event.dart';
part 'riwayat_state.dart';

class RiwayatBloc extends Bloc<RiwayatEvent, RiwayatState> {
  final RiwayatPesananRepository riwayatPemesananRepository;

  RiwayatBloc({required this.riwayatPemesananRepository})
    : super(RiwayatInitial()) {
    on<RiwayatTransaksi>((event, emit) async {
      emit(RiwayatLoading());

      final result = await riwayatPemesananRepository.getRiwayatPesanan();
      result.fold(
        (error) => emit(RiwayatFailure(error: error)),
        (data) => emit(RiwayatSuccess(data: data)),
      );
    });

    on<UpdateStatusRiwayatTransaksi>((event, emit) async {
      final result = await riwayatPemesananRepository.updateStatusBayar(
        event.transaksiId,
        event.statusBayar,
        event.statusPembayaran,
        event.statusPesanan,
      );
      result.fold(
        (error) => emit(RiwayatFailure(error: error)),
        (_) => add(RiwayatTransaksi()),
      );
    });

    on<DeleteRiwayatTransaksi>((event, emit) async {
      final result = await riwayatPemesananRepository.deleteTransaksi(event.id);
      result.fold(
        (error) => emit(RiwayatFailure(error: error)),
        (_) => add(RiwayatTransaksi()),
      );
    });
  }
}
