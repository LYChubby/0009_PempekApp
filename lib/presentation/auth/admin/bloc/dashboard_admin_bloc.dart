import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/response/dashboard_response_model.dart';
import 'package:pempekapp/data/repository/dashboard_repository.dart';

part 'dashboard_admin_event.dart';
part 'dashboard_admin_state.dart';

class DashboardAdminBloc
    extends Bloc<DashboardAdminEvent, DashboardAdminState> {
  final DashboardRepository dashboardRepository;

  DashboardAdminBloc({required this.dashboardRepository})
    : super(DashboardAdminInitial()) {
    on<DashboardAdmin>((_onDashboardAdmin));
  }

  Future<void> _onDashboardAdmin(
    DashboardAdmin event,
    Emitter<DashboardAdminState> emit,
  ) async {
    emit(DashboardAdminLoading());
    final result = await dashboardRepository.getRekap('dashboard-admin');
    result.fold(
      (error) => emit(DashboardAdminFailure(error: error)),
      (message) => emit(DashboardAdminSuccess(data: message)),
    );
  }
}
