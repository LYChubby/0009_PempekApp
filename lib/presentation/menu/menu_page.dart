import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pempekapp/components/bottom_navbar.dart';
import 'package:pempekapp/data/models/response/menu_response_model.dart';
import 'package:pempekapp/presentation/menu/bloc/menu_bloc.dart';
import 'package:pempekapp/presentation/menu/widgets/menu_card.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MenuBloc>().add(MenuRequested());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Pempek"),
        backgroundColor: const Color(0xFF582D1D),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MenuSucces) {
            final menus = state.menuList;

            if (menus.isEmpty) {
              return const Center(child: Text("Belum ada menu tersedia"));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menus.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                return MenuCard(
                  menu: menus[index],
                  onTap: () {
                    _showDetailDialog(context, menus[index]);
                  },
                );
              },
            );
          } else if (state is MenuError) {
            return Center(child: Text(state.message));
          }

          return const Center(child: Text("Tidak ada data"));
        },
      ),
      bottomNavigationBar: const MyBottomNavBar(),
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
