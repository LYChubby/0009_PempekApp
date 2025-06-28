import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pempekapp/components/bottom_navbar.dart';
import 'package:pempekapp/presentation/auth/admin/bloc/dashboard_admin_bloc.dart';
import 'package:pempekapp/presentation/auth/admin/menu/kelola_menu_page.dart';
import 'package:pempekapp/presentation/menu/bloc/menu_bloc.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Trigger pemanggilan data dashboard
    Future.microtask(() {
      context.read<DashboardAdminBloc>().add(DashboardAdmin());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Admin'),
        backgroundColor: const Color(0xFF582D1D),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<DashboardAdminBloc, DashboardAdminState>(
        builder: (context, state) {
          if (state is DashboardAdminLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DashboardAdminSuccess) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _StatCard(
                        label: 'Pesanan Masuk',
                        value: state.data.totalPenjualan.toString(),
                        icon: Icons.receipt,
                      ),
                      _StatCard(
                        label: 'Pemasukan',
                        value: 'Rp ${state.data.totalPemasukan}',
                        icon: Icons.attach_money,
                      ),
                      _StatCard(
                        label: 'Pengeluaran',
                        value: 'Rp ${state.data.totalPengeluaran}',
                        icon: Icons.money_off,
                      ),
                      _StatCard(
                        label: 'Balance',
                        value: 'Rp ${state.data.balance}',
                        icon: Icons.account_balance_wallet,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Navigasi Cepat',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 400,
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _DashboardCard(
                          icon: Icons.fastfood,
                          label: 'Kelola Menu',
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
                        _DashboardCard(
                          icon: Icons.receipt_long,
                          label: 'Kelola Pesanan',
                          onTap: () {
                            // TODO: Arahkan ke halaman user
                          },
                        ),
                        _DashboardCard(
                          icon: Icons.money_off,
                          label: 'Kelola Pengeluaran',
                          onTap: () {
                            // TODO: Arahkan ke laporan
                          },
                        ),
                        _DashboardCard(
                          icon: Icons.logout,
                          label: 'Logout',
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is DashboardAdminFailure) {
            return Center(child: Text(state.error));
          } else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.42,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: const Color(0xFFFAF4F0),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Color(0xFF582D1D)),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF582D1D),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        color: const Color(0xFFFAF4F0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: const Color(0xFF582D1D)),
              const SizedBox(height: 12),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF582D1D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
