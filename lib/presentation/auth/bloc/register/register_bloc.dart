import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/request/auth/register_request_model.dart';
import 'package:pempekapp/data/repository/auth_repository.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository authRepository;

  RegisterBloc({required this.authRepository}) : super(RegisterInitial()) {
    on<RegisterRequested>((_onRegisterRequested));
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    final result = await authRepository.register(event.requestModel);
    result.fold(
      (error) => emit(RegisterFailure(error: error)),
      (message) => emit(RegisterSuccess(message: message)),
    );
  }
}
