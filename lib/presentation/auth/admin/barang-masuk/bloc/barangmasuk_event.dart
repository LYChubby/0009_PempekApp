part of 'barangmasuk_bloc.dart';

sealed class BarangmasukEvent extends Equatable {
  const BarangmasukEvent();

  @override
  List<Object> get props => [];
}

class GetBarangmasukEvent extends BarangmasukEvent {}

class GetBarangmasukDetailEvent extends BarangmasukEvent {
  final int id;

  const GetBarangmasukDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreateBarangmasukEvent extends BarangmasukEvent {
  final KelolaBarangMasukRequestModel model;

  const CreateBarangmasukEvent(this.model);

  @override
  List<Object> get props => [model];
}

class UpdateBarangmasukEvent extends BarangmasukEvent {
  final int id;
  final KelolaBarangMasukRequestModel model;

  const UpdateBarangmasukEvent(this.id, this.model);

  @override
  List<Object> get props => [id, model];
}

class DeleteBarangmasukEvent extends BarangmasukEvent {
  final int id;

  const DeleteBarangmasukEvent(this.id);

  @override
  List<Object> get props => [id];
}
