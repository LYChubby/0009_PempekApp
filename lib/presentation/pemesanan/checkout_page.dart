import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pempekapp/data/models/request/customer/pembayaran_request_model.dart';
import 'package:pempekapp/data/models/request/customer/pemesanan_request_model.dart';
import 'package:pempekapp/data/models/request/transaksi/transaksi_request_model.dart';
import 'package:pempekapp/data/models/response/menu_response_model.dart';
import 'package:pempekapp/presentation/pemesanan/bloc/checkout_bloc.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> cart;
  final int userId;

  const CheckoutPage({super.key, required this.cart, required this.userId});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String? pengiriman;
  String? pembayaran;
  File? buktiBayar;

  final List<String> metodePengiriman = ['GOJEK', 'GRAB', 'JNE', 'J&T'];
  final List<String> metodePembayaran = [
    'Transfer Bank',
    'GOPAY',
    'OVO',
    'DANA',
  ];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickBuktiBayar() async {
    final source = await _showImageSourceDialog(context);
    if (source == null) return;

    final XFile? picked = await _picker.pickImage(source: source);
    if (picked != null) {
      setState(() => buktiBayar = File(picked.path));
    }
  }

  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Pilih Sumber Gambar"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Kamera"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Galeri"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  void _submitCheckout() {
    if (pengiriman == null || pembayaran == null || buktiBayar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lengkapi semua data dan upload bukti bayar."),
        ),
      );
      return;
    }

    final pemesananList = widget.cart.map((item) {
      final menu = item['menu'] as MenuResponseModel;
      final jumlah = item['quantity'] as int;
      final harga = menu.harga ?? 0;
      return PemesananRequestModel(
        menuId: menu.id,
        jumlah: jumlah,
        hargaSatuan: harga,
        totalHarga: harga * jumlah,
      );
    }).toList();

    final transaksiModel = TransaksiRequestModel(
      userId: widget.userId,
      pengiriman: pengiriman!,
      metodePembayaran: pembayaran!,
      detail: pemesananList,
    );

    context.read<CheckoutBloc>().add(
      CheckoutSubmitted(
        transaksiRequest: transaksiModel,
        pembayaranRequest: PembayaranRequestModel(buktiBayar: buktiBayar!.path),
      ),
    );
  }

  int get totalHarga {
    return widget.cart.fold<int>(0, (total, item) {
      final harga = (item['menu'] as MenuResponseModel).harga ?? 0;
      final qty = item['quantity'] as int;
      return total + (harga * qty);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Checkout"),
        backgroundColor: const Color(0xFF582D1D),
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is CheckoutLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );
          } else {
            Navigator.pop(context); // Tutup loading dialog

            if (state is CheckoutSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Pemesanan berhasil")),
              );
              Navigator.pop(context);
            } else if (state is CheckoutFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Ringkasan Pesanan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ...widget.cart.map((item) {
                final menu = item['menu'] as MenuResponseModel;
                final qty = item['quantity'] as int;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text("${menu.nama} x$qty - Rp ${menu.harga! * qty}"),
                );
              }),
              const Divider(height: 32),
              Text(
                "Total: Rp $totalHarga",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: pengiriman,
                items: metodePengiriman
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => pengiriman = val),
                decoration: const InputDecoration(
                  labelText: "Metode Pengiriman",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: pembayaran,
                items: metodePembayaran
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => pembayaran = val),
                decoration: const InputDecoration(
                  labelText: "Metode Pembayaran",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: _pickBuktiBayar,
                icon: const Icon(Icons.upload_file),
                label: Text(
                  buktiBayar == null
                      ? "Upload Bukti Bayar"
                      : "Ganti Bukti Bayar",
                ),
              ),
              if (buktiBayar != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Image.file(buktiBayar!, height: 150, fit: BoxFit.cover),
                      TextButton(
                        onPressed: () => setState(() => buktiBayar = null),
                        child: const Text(
                          "Hapus Bukti Bayar",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF582D1D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _submitCheckout,
                child: const Text("Checkout Sekarang"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
