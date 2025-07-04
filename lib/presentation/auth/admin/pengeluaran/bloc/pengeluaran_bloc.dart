import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/request/admin/pengeluaran_request_model.dart';
import 'package:pempekapp/data/models/response/pengeluaran_response_model.dart';
import 'package:pempekapp/data/repository/pengeluaran_repository.dart';

part 'pengeluaran_event.dart';
part 'pengeluaran_state.dart';

class PengeluaranBloc extends Bloc<PengeluaranEvent, PengeluaranState> {
  final PengeluaranRepository pengeluaranRepository;

  PengeluaranBloc({required this.pengeluaranRepository})
    : super(PengeluaranInitial()) {
    on<GetPengeluaranEvent>((event, emit) async {
      emit(PengeluaranLoading());
      final result = await pengeluaranRepository.getAll();
      result.fold(
        (error) => emit(PengeluaranFailure(error: error)),
        (data) => emit(PengeluaranSuccess(data: data)),
      );
    });

    on<CreatePengeluaranEvent>((event, emit) async {
      emit(PengeluaranLoading());
      final result = await pengeluaranRepository.create(event.requestModel);
      result.fold((error) => emit(PengeluaranFailure(error: error)), (message) {
        add(GetPengeluaranEvent());
        emit(PengeluaranSuccess(data: [])); // Clear data after creation
      });
    });

    on<UpdatePengeluaranEvent>((event, emit) async {
      emit(PengeluaranLoading());
      final result = await pengeluaranRepository.update(
        event.id,
        event.requestModel,
      );
      result.fold((error) => emit(PengeluaranFailure(error: error)), (message) {
        add(GetPengeluaranEvent());
        emit(PengeluaranSuccess(data: [])); // Clear data after update
      });
    });

    on<DeletePengeluaranEvent>((event, emit) async {
      emit(PengeluaranLoading());
      final result = await pengeluaranRepository.delete(event.id);
      result.fold((error) => emit(PengeluaranFailure(error: error)), (message) {
        add(GetPengeluaranEvent());
        emit(PengeluaranSuccess(data: [])); // Clear data after deletion
      });
    });
  }
}
