import 'package:flutter/material.dart';
import 'package:pempekapp/data/models/response/menu_response_model.dart';

class MenuCard extends StatelessWidget {
  final MenuResponseModel menu;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const MenuCard({
    super.key,
    required this.menu,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final String baseImageUrl = 'http://10.0.2.2:8000/storage/menu/';
    final String imageUrl = menu.gambar != null && menu.gambar!.isNotEmpty
        ? '$baseImageUrl${menu.gambar}'
        : 'https://via.placeholder.com/150';

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 150,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            menu.nama ?? '-',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${menu.harga}',
                            style: const TextStyle(
                              color: Color(0xFF582D1D),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onAddToCart,
                      icon: const Icon(Icons.add_shopping_cart),
                      color: const Color(0xFF582D1D),
                      tooltip: 'Tambah ke keranjang',
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
