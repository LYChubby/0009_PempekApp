part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterRequested extends RegisterEvent {
  final RegisterRequestModel requestModel;

  const RegisterRequested({required this.requestModel});

  @override
  List<Object> get props => [requestModel];
}
