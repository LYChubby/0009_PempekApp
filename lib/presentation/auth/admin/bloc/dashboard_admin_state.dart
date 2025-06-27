part of 'dashboard_admin_bloc.dart';

sealed class DashboardAdminState extends Equatable {
  const DashboardAdminState();

  @override
  List<Object> get props => [];
}

final class DashboardAdminInitial extends DashboardAdminState {}

final class DashboardAdminLoading extends DashboardAdminState {}

final class DashboardAdminSuccess extends DashboardAdminState {
  final DashboardResponseModel data;

  const DashboardAdminSuccess({required this.data});

  @override
  List<Object> get props => [data];
}

final class DashboardAdminFailure extends DashboardAdminState {
  final String error;

  const DashboardAdminFailure({required this.error});

  @override
  List<Object> get props => [error];
}
