part of 'pengeluaran_bloc.dart';

sealed class PengeluaranEvent extends Equatable {
  const PengeluaranEvent();

  @override
  List<Object> get props => [];
}

class GetPengeluaranEvent extends PengeluaranEvent {}

class CreatePengeluaranEvent extends PengeluaranEvent {
  final PengeluaranRequestModel requestModel;

  const CreatePengeluaranEvent({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}

class UpdatePengeluaranEvent extends PengeluaranEvent {
  final int id;
  final PengeluaranRequestModel requestModel;

  const UpdatePengeluaranEvent({required this.id, required this.requestModel});

  @override
  List<Object> get props => [id, requestModel];
}

class DeletePengeluaranEvent extends PengeluaranEvent {
  final int id;

  const DeletePengeluaranEvent({required this.id});

  @override
  List<Object> get props => [id];
}
