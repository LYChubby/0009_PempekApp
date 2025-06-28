part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class CheckoutSubmitted extends CheckoutEvent {
  final List<PemesananRequestModel> pemesananRequest;
  final PembayaranRequestModel pembayaranRequest;

  const CheckoutSubmitted({
    required this.pemesananRequest,
    required this.pembayaranRequest,
  });

  @override
  List<Object> get props => [pemesananRequest, pembayaranRequest];
}
