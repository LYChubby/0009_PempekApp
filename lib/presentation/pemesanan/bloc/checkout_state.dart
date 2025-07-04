part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object?> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class CheckoutSuccess extends CheckoutState {
  final String message;
  const CheckoutSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class CheckoutFailure extends CheckoutState {
  final String error;
  const CheckoutFailure({required this.error});

  @override
  List<Object?> get props => [error];
}
