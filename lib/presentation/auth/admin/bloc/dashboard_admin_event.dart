part of 'dashboard_admin_bloc.dart';

sealed class DashboardAdminEvent extends Equatable {
  const DashboardAdminEvent();

  @override
  List<Object> get props => [];
}

class DashboardAdmin extends DashboardAdminEvent {}
