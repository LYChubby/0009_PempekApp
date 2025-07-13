import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pempekapp/components/bottom_navbar.dart';
import 'package:pempekapp/presentation/auth/admin/barang-masuk/barang_masuk_page.dart';
import 'package:pempekapp/presentation/auth/admin/barang-masuk/bloc/barangmasuk_bloc.dart';
import 'package:pempekapp/presentation/auth/admin/bloc/dashboard_admin_bloc.dart';
import 'package:pempekapp/presentation/auth/admin/menu/kelola_menu_page.dart';
import 'package:pempekapp/presentation/auth/admin/pengeluaran/bloc/pengeluaran_bloc.dart';
import 'package:pempekapp/presentation/auth/admin/pengeluaran/pengeluaran_page.dart';
import 'package:pempekapp/presentation/auth/login_screen.dart';
import 'package:pempekapp/presentation/menu/bloc/menu_bloc.dart';
import 'package:pempekapp/presentation/riwayat_pemesanan/bloc/riwayat_bloc.dart';
import 'package:pempekapp/presentation/riwayat_pemesanan/riwayat_pesanan_page.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  // Theme Colors
  static const Color primaryColor = Color(0xFF582D1D);
  static const Color primaryLight = Color(0xFF7A3F2A);
  static const Color primaryDark = Color(0xFF3D1F13);
  static const Color accentColor = Color(0xFFFF6B35);
  static const Color backgroundColor = Color(0xFFF5F2F0);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color softBackground = Color(0xFFFAF7F4);

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    Future.microtask(() {
      context.read<DashboardAdminBloc>().add(DashboardAdmin());
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.logout, color: Colors.red, size: 24),
            ),
            const SizedBox(width: 12),
            const Text(
              'Logout Admin',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: const Text(
          'Yakin ingin keluar dari dashboard admin?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Ya, Keluar'),
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
          'Dashboard Admin',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, primaryDark],
            ),
          ),
        ),
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
                child: const Icon(Icons.logout_outlined, size: 20),
              ),
              onPressed: _showLogoutDialog,
            ),
          ),
        ],
      ),
      body: BlocBuilder<DashboardAdminBloc, DashboardAdminState>(
        builder: (context, state) {
          if (state is DashboardAdminLoading) {
            return _buildLoadingState();
          } else if (state is DashboardAdminSuccess) {
            return _buildSuccessState(state);
          } else if (state is DashboardAdminFailure) {
            return _buildErrorState(state.error);
          } else {
            return _buildEmptyState();
          }
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: const MyBottomNavBar(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: softBackground,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                strokeWidth: 3,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Memuat dashboard...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState(DashboardAdminSuccess state) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DashboardAdminBloc>().add(DashboardAdmin());
          },
          color: primaryColor,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.only(bottom: 24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [primaryColor, primaryLight],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.dashboard,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Selamat Datang',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Kelola bisnis pempek Anda dengan mudah',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Statistics Section
                    Row(
                      children: [
                        Icon(Icons.analytics, color: primaryColor, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Statistik Bisnis',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildStatisticsGrid(state),

                    const SizedBox(height: 32),

                    // Quick Navigation Section
                    Row(
                      children: [
                        Icon(Icons.apps, color: primaryColor, size: 24),
                        const SizedBox(width: 8),
                        const Text(
                          'Navigasi Cepat',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _buildNavigationGrid(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsGrid(DashboardAdminSuccess state) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 4 : 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: isTablet ? 1.2 : 1.1,
      children: [
        _EnhancedStatCard(
          label: 'Pesanan Masuk',
          value: state.data.totalPenjualan.toString(),
          icon: Icons.receipt_long,
          color: const Color(0xFF4CAF50),
          gradient: [const Color(0xFF4CAF50), const Color(0xFF45A049)],
        ),
        _EnhancedStatCard(
          label: 'Pemasukan',
          value: 'Rp ${state.data.totalPemasukan}',
          icon: Icons.trending_up,
          color: const Color(0xFF2196F3),
          gradient: [const Color(0xFF2196F3), const Color(0xFF1976D2)],
        ),
        _EnhancedStatCard(
          label: 'Pengeluaran',
          value: 'Rp ${state.data.totalPengeluaran}',
          icon: Icons.trending_down,
          color: const Color(0xFFFF9800),
          gradient: [const Color(0xFFFF9800), const Color(0xFFF57C00)],
        ),
        _EnhancedStatCard(
          label: 'Balance',
          value: 'Rp ${state.data.balance}',
          icon: Icons.account_balance_wallet,
          color: primaryColor,
          gradient: [primaryColor, primaryDark],
        ),
      ],
    );
  }

  Widget _buildNavigationGrid() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 3 : 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: isTablet ? 1.3 : 1.1,
      children: [
        _EnhancedDashboardCard(
          icon: Icons.restaurant_menu,
          label: 'Kelola Menu',
          color: const Color(0xFFFF6B35),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<MenuBloc>(),
                  child: AdminKelolaMenuPage(),
                ),
              ),
            );
          },
        ),
        _EnhancedDashboardCard(
          icon: Icons.shopping_cart,
          label: 'Kelola Pesanan',
          color: const Color(0xFF4CAF50),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<RiwayatBloc>(),
                  child: RiwayatPesananPage(),
                ),
              ),
            );
          },
        ),
        _EnhancedDashboardCard(
          icon: Icons.attach_money,
          label: 'Pengeluaran',
          color: const Color(0xFFFF9800),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<PengeluaranBloc>(),
                  child: PengeluaranPage(),
                ),
              ),
            ).then((_) {
              context.read<DashboardAdminBloc>().add(DashboardAdmin());
            });
          },
        ),
        _EnhancedDashboardCard(
          icon: Icons.inventory,
          label: 'Barang Masuk',
          color: const Color(0xFF9C27B0),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider.value(
                  value: context.read<BarangmasukBloc>(),
                  child: BarangMasukPage(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Terjadi Kesalahan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                context.read<DashboardAdminBloc>().add(DashboardAdmin());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.dashboard_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Tidak ada data dashboard',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _EnhancedStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final List<Color> gradient;

  const _EnhancedStatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, size: 32, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EnhancedDashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _EnhancedDashboardCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 36, color: color),
                ),
                const SizedBox(height: 16),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
