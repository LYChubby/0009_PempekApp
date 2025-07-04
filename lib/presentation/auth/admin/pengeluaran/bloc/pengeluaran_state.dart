part of 'pengeluaran_bloc.dart';

sealed class PengeluaranState extends Equatable {
  const PengeluaranState();

  @override
  List<Object> get props => [];
}

final class PengeluaranInitial extends PengeluaranState {}

final class PengeluaranLoading extends PengeluaranState {}

final class PengeluaranSuccess extends PengeluaranState {
  final List<PengeluaranResponseModel> data;

  const PengeluaranSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class PengeluaranFailure extends PengeluaranState {
  final String error;

  const PengeluaranFailure({required this.error});

  @override
  List<Object> get props => [error];
}
