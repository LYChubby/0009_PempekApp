part of 'barangmasuk_bloc.dart';

sealed class BarangmasukState extends Equatable {
  const BarangmasukState();

  @override
  List<Object> get props => [];
}

final class BarangmasukInitial extends BarangmasukState {}

final class BarangmasukLoading extends BarangmasukState {}

final class BarangmasukSuccess extends BarangmasukState {
  final List<KelolaBarangMasukResponseModel> barangMasukList;

  const BarangmasukSuccess(this.barangMasukList);

  @override
  List<Object> get props => [barangMasukList];
}

final class BarangmasukError extends BarangmasukState {
  final String error;

  const BarangmasukError(this.error);

  @override
  List<Object> get props => [error];
}
