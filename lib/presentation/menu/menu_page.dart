import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pempekapp/components/bottom_navbar.dart';
import 'package:pempekapp/data/models/response/menu_response_model.dart';
import 'package:pempekapp/presentation/auth/bloc/login/login_bloc.dart';
import 'package:pempekapp/presentation/menu/bloc/menu_bloc.dart';
import 'package:pempekapp/presentation/menu/widgets/menu_card.dart';
import 'package:pempekapp/presentation/pemesanan/bloc/checkout_bloc.dart';
import 'package:pempekapp/presentation/pemesanan/checkout_page.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  final List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MenuBloc>().add(MenuRequested());
    });
  }

  void _addToCart(MenuResponseModel menu) {
    setState(() {
      final index = cart.indexWhere((item) => item['menu'].id == menu.id);
      if (index != -1) {
        cart[index]['quantity'] += 1;
      } else {
        cart.add({'menu': menu, 'quantity': 1});
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${menu.nama} ditambahkan ke keranjang")),
    );
  }

  void _showCartDialog() {
    double total = 0;
    for (var item in cart) {
      total += (item['menu'].harga ?? 0) * item['quantity'];
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keranjang'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...cart.map((item) {
                final menu = item['menu'] as MenuResponseModel;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(menu.nama ?? '-')),
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        setState(() {
                          item['quantity']--;
                          if (item['quantity'] <= 0) {
                            cart.remove(item);
                          }
                        });
                        Navigator.pop(context);
                        _showCartDialog();
                      },
                    ),
                    Text('${item['quantity']}'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() => item['quantity']++);
                        Navigator.pop(context);
                        _showCartDialog();
                      },
                    ),
                  ],
                );
              }).toList(),
              const Divider(),
              Text('Total: Rp $total'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          ElevatedButton(
            onPressed: () {
              final loginState = context.read<LoginBloc>().state;
              final userId = loginState is LoginSuccess
                  ? loginState.responseModel.user?.id
                  : null;

              if (userId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Silakan login terlebih dahulu"),
                  ),
                );
                return;
              }

              Navigator.pop(context); // Tutup dialog
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(
                    value: context.read<CheckoutBloc>(),
                    child: CheckoutPage(cart: cart, userId: userId),
                  ),
                ),
              );
            },
            child: const Text("Checkout"),
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
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _addToCart(menu);
                    },
                    child: const Text('Tambah ke Keranjang'),
                  ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Pempek"),
        backgroundColor: const Color(0xFF582D1D),
        foregroundColor: Colors.white,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: _showCartDialog,
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cart
                          .fold<int>(
                            0,
                            (sum, item) => sum + item['quantity'] as int,
                          )
                          .toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
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
                  onTap: () => _showDetailDialog(context, menus[index]),
                  onAddToCart: () => _addToCart(menus[index]),
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
}
