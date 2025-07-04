import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pempekapp/data/models/request/admin/pengeluaran_request_model.dart';
import 'package:pempekapp/data/models/response/pengeluaran_response_model.dart';
import 'package:pempekapp/presentation/auth/admin/pengeluaran/bloc/pengeluaran_bloc.dart';

class PengeluaranPage extends StatefulWidget {
  const PengeluaranPage({super.key});

  @override
  State<PengeluaranPage> createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  final formKey = GlobalKey<FormState>();
  final keteranganController = TextEditingController();
  final jumlahController = TextEditingController();
  DateTime? _selectedDate;
  int? _editingId;

  @override
  void initState() {
    super.initState();
    context.read<PengeluaranBloc>().add(GetPengeluaranEvent());
  }

  @override
  void dispose() {
    keteranganController.dispose();
    jumlahController.dispose();
    super.dispose();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          _editingId == null ? 'Tambah Pengeluaran' : 'Edit Pengeluaran',
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: keteranganController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Pengeluaran',
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Harus diisi' : null,
                ),
                TextFormField(
                  controller: jumlahController,
                  decoration: const InputDecoration(labelText: 'Jumlah'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Harus diisi' : null,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      _selectedDate == null
                          ? 'Pilih Tanggal'
                          : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                    ),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(onPressed: _submitForm, child: const Text('Simpan')),
        ],
      ),
    );
  }

  void _submitForm() {
    if (formKey.currentState!.validate() && _selectedDate != null) {
      final requestModel = PengeluaranRequestModel(
        keterangan: keteranganController.text,
        jumlah: int.parse(jumlahController.text),
        tanggal: _selectedDate!,
      );

      if (_editingId == null) {
        context.read<PengeluaranBloc>().add(
          CreatePengeluaranEvent(requestModel: requestModel),
        );
      } else {
        context.read<PengeluaranBloc>().add(
          UpdatePengeluaranEvent(id: _editingId!, requestModel: requestModel),
        );
      }

      _resetForm();
      Navigator.pop(context);
    }
  }

  void _resetForm() {
    keteranganController.clear();
    jumlahController.clear();
    setState(() {
      _selectedDate = null;
      _editingId = null;
    });
  }

  void _editPengeluaran(PengeluaranResponseModel pengeluaran) {
    setState(() {
      _editingId = pengeluaran.id;
      keteranganController.text = pengeluaran.keterangan ?? '';
      jumlahController.text = pengeluaran.jumlah.toString();
      _selectedDate = pengeluaran.tanggal;
    });
    _showFormDialog(context);
  }

  void _deletePengeluaran(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Pengeluaran'),
        content: const Text('Yakin ingin menghapus pengeluaran ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              context.read<PengeluaranBloc>().add(
                DeletePengeluaranEvent(id: id),
              );
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pengeluaran'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _resetForm();
              _showFormDialog(context);
            },
          ),
        ],
      ),
      body: BlocConsumer<PengeluaranBloc, PengeluaranState>(
        listener: (context, state) {
          if (state is PengeluaranFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is PengeluaranLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PengeluaranSuccess) {
            if (state.data.isEmpty) {
              return const Center(child: Text('Belum ada data pengeluaran'));
            }

            return ListView.builder(
              itemCount: state.data.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final pengeluaran = state.data[index];
                return Card(
                  child: ListTile(
                    title: Text(pengeluaran.keterangan ?? 'Tanpa Keterangan'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Rp ${NumberFormat('#,###').format(pengeluaran.jumlah)}',
                        ),
                        Text(
                          DateFormat(
                            'dd/MM/yyyy',
                          ).format(pengeluaran.tanggal ?? DateTime.now()),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editPengeluaran(pengeluaran),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () =>
                              _deletePengeluaran(pengeluaran.id ?? 0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is PengeluaranFailure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PengeluaranBloc>().add(
                      GetPengeluaranEvent(),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
