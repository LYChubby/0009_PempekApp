import 'package:flutter/material.dart';
import 'package:pempekapp/data/models/response/menu_response_model.dart';
import 'package:pempekapp/data/services/service_http_client.dart';

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
    final serviceHttpClient = ServiceHttpClient();
    final imageUrl = menu.gambar != null && menu.gambar!.isNotEmpty
        ? '${serviceHttpClient.storageUrl}${menu.gambar}'
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
            // Bagian gambar
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Container(
                height: 150,
                width: double.infinity,
                color: Colors.grey[200], // Background color fallback
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    print('Error loading image: $error');
                    print('Stack trace: $stackTrace');
                    print('Attempted URL: $imageUrl');
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 40,
                            color: Colors.grey[500],
                          ),
                          Text(
                            'Gagal memuat gambar',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            // Bagian informasi menu
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          menu.nama ?? 'Nama Menu',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${menu.harga ?? '0'}',
                          style: const TextStyle(
                            fontSize: 12,
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
                    iconSize: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
