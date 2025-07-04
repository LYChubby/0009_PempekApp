part of 'checkout_bloc.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object?> get props => [];
}

class CheckoutSubmitted extends CheckoutEvent {
  final TransaksiRequestModel transaksiRequest;
  final PembayaranRequestModel pembayaranRequest;

  const CheckoutSubmitted({
    required this.transaksiRequest,
    required this.pembayaranRequest,
  });

  @override
  List<Object?> get props => [transaksiRequest, pembayaranRequest];
}
