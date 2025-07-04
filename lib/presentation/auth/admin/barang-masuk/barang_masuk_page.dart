import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pempekapp/data/models/request/admin/kelola_barang_masuk_request_model.dart';
import 'package:pempekapp/data/models/response/kelola_barang_masuk_response_model.dart';
import 'package:pempekapp/presentation/auth/admin/barang-masuk/bloc/barangmasuk_bloc.dart';

class BarangMasukPage extends StatefulWidget {
  const BarangMasukPage({super.key});

  @override
  State<BarangMasukPage> createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  KelolaBarangMasukResponseModel? selectedItem;
  bool isEditMode = false;

  @override
  void initState() {
    super.initState();
    context.read<BarangmasukBloc>().add(GetBarangmasukEvent());
  }

  void _showFormDialog() {
    final formKey = GlobalKey<FormState>();
    final namaController = TextEditingController();
    final jumlahController = TextEditingController();
    final tanggalController = TextEditingController();

    if (isEditMode && selectedItem != null) {
      namaController.text = selectedItem!.namaBarang ?? '';
      jumlahController.text = selectedItem!.jumlah ?? '';
      tanggalController.text = selectedItem!.tanggalMasuk ?? '';
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEditMode ? 'Edit Barang Masuk' : 'Tambah Barang Masuk'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: namaController,
                    decoration: const InputDecoration(labelText: 'Nama Barang'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama barang harus diisi';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: jumlahController,
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah harus diisi';
                      }

                      return null;
                    },
                  ),
                  TextFormField(
                    controller: tanggalController,
                    decoration: const InputDecoration(
                      labelText: 'Tanggal Masuk',
                    ),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (date != null) {
                        tanggalController.text =
                            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                      }
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tanggal harus diisi';
                      }
                      return null;
                    },
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
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  final model = KelolaBarangMasukRequestModel(
                    namaBarang: namaController.text,
                    jumlah: (jumlahController.text),
                    tanggalMasuk: tanggalController.text,
                  );

                  if (isEditMode && selectedItem != null) {
                    context.read<BarangmasukBloc>().add(
                      UpdateBarangmasukEvent(selectedItem!.id!, model),
                    );
                  } else {
                    context.read<BarangmasukBloc>().add(
                      CreateBarangmasukEvent(model),
                    );
                  }

                  Navigator.pop(context);
                  setState(() {
                    isEditMode = false;
                    selectedItem = null;
                  });
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Kelola Barang Masuk')),
      body: BlocConsumer<BarangmasukBloc, BarangmasukState>(
        listener: (context, state) {
          if (state is BarangmasukError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is BarangmasukLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BarangmasukError) {
            return Center(child: Text(state.error));
          }

          if (state is BarangmasukSuccess) {
            final barangMasukList = state.barangMasukList;

            return ListView.builder(
              itemCount: barangMasukList.length,
              itemBuilder: (context, index) {
                final item = barangMasukList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(item.namaBarang ?? 'Tidak ada nama'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Jumlah: ${item.jumlah}'),
                        Text('Tanggal: ${item.tanggalMasuk}'),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() {
                              isEditMode = true;
                              selectedItem = item;
                            });
                            _showFormDialog();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Hapus Barang Masuk'),
                                content: const Text(
                                  'Apakah Anda yakin ingin menghapus barang masuk ini?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Batal'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      context.read<BarangmasukBloc>().add(
                                        DeleteBarangmasukEvent(item.id!),
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Hapus'),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('Tidak ada data'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isEditMode = false;
            selectedItem = null;
          });
          _showFormDialog();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
