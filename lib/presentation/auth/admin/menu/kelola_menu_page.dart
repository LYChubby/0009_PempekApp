import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pempekapp/data/models/request/admin/menu_request_model.dart';
import 'package:pempekapp/data/models/response/menu_response_model.dart';
import 'package:pempekapp/presentation/menu/bloc/menu_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AdminKelolaMenuPage extends StatefulWidget {
  const AdminKelolaMenuPage({super.key});

  @override
  State<AdminKelolaMenuPage> createState() => _AdminKelolaMenuPageState();
}

class _AdminKelolaMenuPageState extends State<AdminKelolaMenuPage> {
  @override
  void initState() {
    super.initState();
    context.read<MenuBloc>().add(MenuRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola Menu"),
        backgroundColor: const Color.fromARGB(255, 88, 45, 29),
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<MenuBloc, MenuState>(
        listener: (context, state) {
          if (state is MenuOperationSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            context.read<MenuBloc>().add(MenuRequested());
          } else if (state is MenuError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuSucces) {
            final menus = state.menuList;
            return ListView.builder(
              itemCount: menus.length,
              itemBuilder: (context, index) {
                final menu = menus[index];
                final imageUrl = menu.gambar != null && menu.gambar!.isNotEmpty
                    ? 'http://10.0.2.2:8000/storage/menu/${menu.gambar}'
                    : 'https://via.placeholder.com/150';

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: ListTile(
                    onTap: () {
                      _showDetailDialog(context, menu);
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        imageUrl,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
                          color: Colors.grey[300],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                    title: Text(menu.nama ?? '-'),
                    subtitle: Text('Rp ${menu.harga}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () {
                            _showFormDialog(context, isEdit: true, menu: menu);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, menu);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Tidak ada data menu."));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFormDialog(context),
        backgroundColor: const Color.fromARGB(255, 88, 45, 29),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFormDialog(
    BuildContext context, {
    bool isEdit = false,
    MenuResponseModel? menu,
  }) {
    final namaController = TextEditingController(text: menu?.nama);
    final hargaController = TextEditingController(
      text: menu?.harga?.toString(),
    );
    final deskripsiController = TextEditingController(text: menu?.deskripsi);
    XFile? pickedImage;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Menu' : 'Tambah Menu'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama Menu'),
              ),
              TextField(
                controller: hargaController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: deskripsiController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final picker = ImagePicker();
                  pickedImage = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                },
                icon: const Icon(Icons.image),
                label: const Text('Pilih Gambar'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final data = MenuRequestModel(
                nama: namaController.text,
                harga: int.tryParse(hargaController.text),
                deskripsi: deskripsiController.text,
                gambar: pickedImage,
              );

              if (isEdit && menu != null) {
                context.read<MenuBloc>().add(
                  MenuUpdated(id: menu.id!, requestModel: data),
                );
              } else {
                context.read<MenuBloc>().add(MenuCreated(requestModel: data));
              }

              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Simpan' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    MenuResponseModel menu,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text('Apakah Anda yakin ingin menghapus menu ${menu.nama}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<MenuBloc>().add(MenuDeleted(id: menu.id!));
              Navigator.pop(context);
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showDetailDialog(BuildContext context, MenuResponseModel menu) {
    final imageUrl = menu.gambar != null && menu.gambar!.isNotEmpty
        ? 'http://10.0.2.2:8000/storage/menu/${menu.gambar}'
        : 'https://via.placeholder.com/150';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(menu.nama ?? 'Detail Menu'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(
                  child: Image.network(
                    imageUrl,
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 200,
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Harga: Rp ${menu.harga}'),
                if (menu.deskripsi != null && menu.deskripsi!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Deskripsi: ${menu.deskripsi}'),
                  ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }
}
