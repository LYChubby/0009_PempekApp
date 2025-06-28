part of 'checkout_bloc.dart';

sealed class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

final class CheckoutInitial extends CheckoutState {}

final class CheckoutLoading extends CheckoutState {}

final class CheckoutSuccess extends CheckoutState {
  final String message;

  const CheckoutSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class CheckoutFailure extends CheckoutState {
  final String error;

  const CheckoutFailure({required this.error});

  @override
  List<Object> get props => [error];
}
