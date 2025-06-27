part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends LoginEvent {
  final LoginRequestModel requestModel;

  const LoginRequested({required this.requestModel});

  @override
  List<Object?> get props => [requestModel];
}
