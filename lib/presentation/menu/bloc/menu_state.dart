part of 'menu_bloc.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

final class MenuInitial extends MenuState {}

final class MenuLoading extends MenuState {}

final class MenuSucces extends MenuState {
  final List<MenuResponseModel> menuList;

  const MenuSucces({required this.menuList});

  @override
  List<Object> get props => [menuList];
}

final class MenuError extends MenuState {
  final String message;

  const MenuError({required this.message});

  @override
  List<Object> get props => [message];
}

class MenuOperationSuccess extends MenuState {
  final String message;

  const MenuOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
