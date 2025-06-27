import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/request/auth/login_request_model.dart';
import 'package:pempekapp/data/models/response/login_response_model.dart';
import 'package:pempekapp/data/repository/auth_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginRequested>((_onLoginRequested));
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await authRepository.login(event.requestModel);
    result.fold(
      (error) => emit(LoginFailure(error: error)),
      (message) => emit(LoginSuccess(responseModel: message)),
    );
  }
}
