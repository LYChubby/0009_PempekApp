import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/response/menu_response_model.dart';
import 'package:pempekapp/data/repository/menu_repository.dart';

part 'menu_event.dart';
part 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuRepository menuRepository;

  MenuBloc({required this.menuRepository}) : super(MenuInitial()) {
    on<MenuRequested>((event, emit) async {
      emit(MenuLoading());
      final result = await menuRepository.fetchAllMenu();
      result.fold(
        (error) => emit(MenuError(message: error)),
        (menuList) => emit(MenuSucces(menuList: menuList)),
      );
    });
  }
}
