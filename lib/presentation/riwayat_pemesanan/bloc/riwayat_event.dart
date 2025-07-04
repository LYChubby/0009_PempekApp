part of 'riwayat_bloc.dart';

sealed class RiwayatEvent extends Equatable {
  const RiwayatEvent();

  @override
  List<Object> get props => [];
}

class RiwayatTransaksi extends RiwayatEvent {}

class DeleteRiwayatTransaksi extends RiwayatEvent {
  final int id;

  const DeleteRiwayatTransaksi({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateStatusRiwayatTransaksi extends RiwayatEvent {
  final int transaksiId;
  final String statusBayar;
  final String statusPembayaran;

  const UpdateStatusRiwayatTransaksi({
    required this.transaksiId,
    required this.statusBayar,
    required this.statusPembayaran,
  });

  @override
  List<Object> get props => [transaksiId, statusBayar];
}
