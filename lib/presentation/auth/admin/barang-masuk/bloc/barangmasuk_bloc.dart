import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pempekapp/data/models/request/admin/kelola_barang_masuk_request_model.dart';
import 'package:pempekapp/data/models/response/kelola_barang_masuk_response_model.dart';
import 'package:pempekapp/data/repository/kelola_barang_masuk_repository.dart';

part 'barangmasuk_event.dart';
part 'barangmasuk_state.dart';

class BarangmasukBloc extends Bloc<BarangmasukEvent, BarangmasukState> {
  final KelolaBarangRepository kelolaBarangMasukRepository;

  BarangmasukBloc({required this.kelolaBarangMasukRepository})
    : super(BarangmasukInitial()) {
    on<GetBarangmasukEvent>((event, emit) async {
      emit(BarangmasukLoading());
      final result = await kelolaBarangMasukRepository.getAll();
      result.fold(
        (error) => emit(BarangmasukError(error)),
        (data) => emit(BarangmasukSuccess(data)),
      );
    });

    on<GetBarangmasukDetailEvent>((event, emit) async {
      emit(BarangmasukLoading());
      final result = await kelolaBarangMasukRepository.getById(event.id);
      result.fold(
        (error) => emit(BarangmasukError(error)),
        (data) => emit(BarangmasukSuccess([data])),
      );
    });

    on<CreateBarangmasukEvent>((event, emit) async {
      emit(BarangmasukLoading());
      final result = await kelolaBarangMasukRepository.create(event.model);
      result.fold((error) => emit(BarangmasukError(error)), (message) {
        add(GetBarangmasukEvent());
        emit(BarangmasukSuccess([])); // Clear data after creation
      });
    });

    on<UpdateBarangmasukEvent>((event, emit) async {
      emit(BarangmasukLoading());
      final result = await kelolaBarangMasukRepository.update(
        event.id,
        event.model,
      );
      result.fold((error) => emit(BarangmasukError(error)), (message) {
        add(GetBarangmasukEvent());
        emit(BarangmasukSuccess([])); // Clear data after update
      });
    });

    on<DeleteBarangmasukEvent>((event, emit) async {
      emit(BarangmasukLoading());
      final result = await kelolaBarangMasukRepository.delete(event.id);
      result.fold((error) => emit(BarangmasukError(error)), (message) {
        add(GetBarangmasukEvent());
        emit(BarangmasukSuccess([])); // Clear data after deletion
      });
    });
  }
}
