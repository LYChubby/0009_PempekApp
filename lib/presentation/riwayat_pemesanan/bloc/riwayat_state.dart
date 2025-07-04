part of 'riwayat_bloc.dart';

sealed class RiwayatState extends Equatable {
  const RiwayatState();

  @override
  List<Object> get props => [];
}

final class RiwayatInitial extends RiwayatState {}

final class RiwayatLoading extends RiwayatState {}

final class RiwayatSuccess extends RiwayatState {
  final List<RiwayatTransaksiResponseModel> data;

  const RiwayatSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class RiwayatFailure extends RiwayatState {
  final String error;

  const RiwayatFailure({required this.error});

  @override
  List<Object> get props => [error];
}
