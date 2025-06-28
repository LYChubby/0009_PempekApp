import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/request/admin/menu_request_model.dart';
import 'package:pempekapp/data/models/response/menu_response_model.dart';
import 'package:pempekapp/data/repository/menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc({required this.menuRepository}) : super(MenuInitial()) {
    on<MenuRequested>(_onMenuRequested);
    on<MenuCreated>(_onMenuCreated);
    on<MenuUpdated>(_onMenuUpdated);
    on<MenuDeleted>(_onMenuDeleted);
  }

  Future<void> _onMenuRequested(
    MenuRequested event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    final result = await menuRepository.fetchAllMenu();
    result.fold(
      (error) => emit(MenuError(message: error)),
      (data) => emit(MenuSucces(menuList: data)),
    );
  }

  Future<void> _onMenuCreated(
    MenuCreated event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    final result = await menuRepository.createMenu(event.requestModel);
    result.fold(
      (error) => emit(MenuError(message: error)),
      (message) => add(MenuRequested()),
    );
  }

  Future<void> _onMenuUpdated(
    MenuUpdated event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    final result = await menuRepository.updateMenu(
      event.id,
      event.requestModel,
    );
    result.fold(
      (error) => emit(MenuError(message: error)),
      (message) => add(MenuRequested()),
    );
  }

  Future<void> _onMenuDeleted(
    MenuDeleted event,
    Emitter<MenuState> emit,
  ) async {
    emit(MenuLoading());
    final result = await menuRepository.deleteMenu(event.id);
    result.fold(
      (error) => emit(MenuError(message: error)),
      (message) => add(MenuRequested()),
    );
  }
}
