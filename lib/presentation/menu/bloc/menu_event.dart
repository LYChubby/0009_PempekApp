part of 'menu_bloc.dart';

sealed class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class MenuRequested extends MenuEvent {}

class MenuCreated extends MenuEvent {
  final MenuRequestModel requestModel;

  const MenuCreated({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}

class MenuUpdated extends MenuEvent {
  final int id;
  final MenuRequestModel requestModel;

  const MenuUpdated({required this.id, required this.requestModel});

  @override
  List<Object> get props => [id, requestModel];
}

class MenuDeleted extends MenuEvent {
  final int id;

  const MenuDeleted({required this.id});

  @override
  List<Object> get props => [id];
}
