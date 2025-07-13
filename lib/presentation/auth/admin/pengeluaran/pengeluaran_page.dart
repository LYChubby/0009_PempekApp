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

  // Theme colors - Custom Brown theme
  static const Color primaryColor = Color(0xFF582D1D);
  static const Color primaryLight = Color(0xFF7A3F2A);
  static const Color primaryDark = Color(0xFF3D1F13);
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color backgroundColor = Color(0xFFF5F2F0);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color softBackground = Color(0xFFFAF7F4);
  static const Color shadowColor = Color.fromRGBO(0, 0, 0, 0.1);

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
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
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
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          constraints: BoxConstraints(
            maxWidth: 400,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Text(
                  _editingId == null
                      ? 'Tambah Pengeluaran'
                      : 'Edit Pengeluaran',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Form Content
              Flexible(
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: keteranganController,
                          label: 'Nama Pengeluaran',
                          icon: Icons.description,
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Harus diisi' : null,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: jumlahController,
                          label: 'Jumlah',
                          icon: Icons.money,
                          keyboardType: TextInputType.number,
                          validator: (value) =>
                              value?.isEmpty ?? true ? 'Harus diisi' : null,
                        ),
                        const SizedBox(height: 20),
                        _buildDateSelector(),
                      ],
                    ),
                  ),
                ),
              ),
              // Action Buttons
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: primaryColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Batal',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Simpan'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: softBackground,
      ),
    );
  }

  Widget _buildDateSelector() {
    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: primaryLight),
          borderRadius: BorderRadius.circular(8),
          color: softBackground,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: primaryColor),
            const SizedBox(width: 12),
            Text(
              _selectedDate == null
                  ? 'Pilih Tanggal'
                  : DateFormat('dd/MM/yyyy').format(_selectedDate!),
              style: TextStyle(
                fontSize: 16,
                color: _selectedDate == null
                    ? Colors.grey[600]
                    : Colors.black87,
              ),
            ),
          ],
        ),
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
    } else if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih tanggal terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: const Text(
          'Yakin ingin menghapus pengeluaran ini?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PengeluaranBloc>().add(
                DeletePengeluaranEvent(id: id),
              );
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Kelola Pengeluaran',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
              onPressed: () {
                _resetForm();
                _showFormDialog(context);
              },
            ),
          ),
        ],
      ),
      body: BlocConsumer<PengeluaranBloc, PengeluaranState>(
        listener: (context, state) {
          if (state is PengeluaranFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is PengeluaranLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            );
          } else if (state is PengeluaranSuccess) {
            if (state.data.isEmpty) {
              return _buildEmptyState();
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<PengeluaranBloc>().add(GetPengeluaranEvent());
              },
              color: primaryColor,
              child: ListView.builder(
                itemCount: state.data.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final pengeluaran = state.data[index];
                  return _buildPengeluaranCard(pengeluaran);
                },
              ),
            );
          } else if (state is PengeluaranFailure) {
            return _buildErrorState(state.error);
          }
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.receipt_long, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada data pengeluaran',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap tombol + untuk menambah pengeluaran baru',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 18,
                color: Colors.red[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  context.read<PengeluaranBloc>().add(GetPengeluaranEvent()),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPengeluaranCard(PengeluaranResponseModel pengeluaran) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: const BoxDecoration(
            border: Border(left: BorderSide(color: primaryColor, width: 4)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pengeluaran.keterangan ?? 'Tanpa Keterangan',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(
                                Icons.money,
                                size: 16,
                                color: accentColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Rp ${NumberFormat('#,###').format(pengeluaran.jumlah)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: accentColor,
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
                                color: primaryLight,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                DateFormat(
                                  'dd/MM/yyyy',
                                ).format(pengeluaran.tanggal ?? DateTime.now()),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editPengeluaran(pengeluaran),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deletePengeluaran(pengeluaran.id ?? 0),
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(
                              minWidth: 36,
                              minHeight: 36,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
