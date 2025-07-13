import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pempekapp/data/models/request/admin/kelola_barang_masuk_request_model.dart';
import 'package:pempekapp/data/models/response/kelola_barang_masuk_response_model.dart';
import 'package:pempekapp/presentation/auth/admin/barang-masuk/bloc/barangmasuk_bloc.dart';

// Color Constants
class AppColors {
  static const Color primaryColor = Color(0xFF582D1D);
  static const Color primaryLight = Color(0xFF7A3F2A);
  static const Color primaryDark = Color(0xFF3D1F13);
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color backgroundColor = Color(0xFFF5F2F0);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color softBackground = Color(0xFFFAF7F4);
}

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
          backgroundColor: AppColors.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                Icon(
                  isEditMode ? Icons.edit : Icons.add_box,
                  size: 32,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 8),
                Text(
                  isEditMode ? 'Edit Barang Masuk' : 'Tambah Barang Masuk',
                  style: const TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: namaController,
                    label: 'Nama Barang',
                    icon: Icons.inventory,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama barang harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: jumlahController,
                    label: 'Jumlah',
                    icon: Icons.numbers,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Jumlah harus diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    controller: tanggalController,
                    label: 'Tanggal Masuk',
                    icon: Icons.calendar_today,
                    readOnly: true,
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: AppColors.primaryColor,
                                onPrimary: Colors.white,
                                surface: AppColors.cardColor,
                                onSurface: AppColors.primaryColor,
                              ),
                            ),
                            child: child!,
                          );
                        },
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
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[600],
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
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
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      validator: validator,
      style: const TextStyle(color: AppColors.primaryColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: AppColors.primaryColor.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: AppColors.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.3),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: AppColors.primaryColor.withOpacity(0.3),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: AppColors.softBackground,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Kelola Barang Masuk',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: BlocConsumer<BarangmasukBloc, BarangmasukState>(
        listener: (context, state) {
          if (state is BarangmasukError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BarangmasukLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  AppColors.primaryColor,
                ),
              ),
            );
          }

          if (state is BarangmasukError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.withOpacity(0.6),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi Kesalahan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.error,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.withOpacity(0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          if (state is BarangmasukSuccess) {
            final barangMasukList = state.barangMasukList;

            if (barangMasukList.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 80,
                      color: AppColors.primaryColor.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada barang masuk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap tombol + untuk menambah barang masuk',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.primaryColor.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BarangmasukBloc>().add(GetBarangmasukEvent());
              },
              color: AppColors.primaryColor,
              backgroundColor: AppColors.cardColor,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: barangMasukList.length,
                itemBuilder: (context, index) {
                  final item = barangMasukList[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryColor.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      // leading: Container(
                      //   width: 50,
                      //   height: 50,
                      //   decoration: BoxDecoration(
                      //     color: AppColors.softBackground,
                      //     borderRadius: BorderRadius.circular(12),
                      //   ),
                      //   child: const Icon(
                      //     Icons.inventory,
                      //     color: AppColors.primaryColor,
                      //     size: 24,
                      //   ),
                      // ),
                      title: Text(
                        item.namaBarang ?? 'Tidak ada nama',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.numbers,
                                  size: 16,
                                  color: AppColors.accentColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Jumlah: ${item.jumlah}',
                                  style: TextStyle(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.7,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: AppColors.accentColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  'Tanggal: ${item.tanggalMasuk?.split(' ')[0]}',
                                  style: TextStyle(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.7,
                                    ),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: AppColors.accentColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              color: AppColors.accentColor,
                              onPressed: () {
                                setState(() {
                                  isEditMode = true;
                                  selectedItem = item;
                                });
                                _showFormDialog();
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.delete, size: 20),
                              color: Colors.red,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    backgroundColor: AppColors.cardColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    title: const Column(
                                      children: [
                                        Icon(
                                          Icons.warning,
                                          size: 32,
                                          color: Colors.red,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          'Hapus Barang Masuk',
                                          style: TextStyle(
                                            color: AppColors.primaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: const Text(
                                      'Apakah Anda yakin ingin menghapus barang masuk ini?',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 16,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.grey[600],
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                        ),
                                        child: const Text('Batal'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          context.read<BarangmasukBloc>().add(
                                            DeleteBarangmasukEvent(item.id!),
                                          );
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text('Hapus'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.info_outline,
                  size: 64,
                  color: AppColors.primaryColor.withOpacity(0.5),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          );
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
        backgroundColor: AppColors.accentColor,
        foregroundColor: Colors.white,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add, size: 28),
      ),
    );
  }
}
