import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pempekapp/presentation/auth/admin/bloc/dashboard_admin_bloc.dart';
import 'package:pempekapp/presentation/auth/admin/dashboard_page.dart';
import 'package:pempekapp/presentation/auth/bloc/login/login_bloc.dart';
import 'package:pempekapp/presentation/menu/bloc/menu_bloc.dart';
import 'package:pempekapp/presentation/menu/menu_page.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        final isAdmin =
            state is LoginSuccess &&
            (state as LoginSuccess).responseModel.user?.role == 'admin';

        return Container(
          padding: EdgeInsets.only(
            left: 20.0 * 2,
            right: 20.0 * 2,
            bottom: 20.0,
          ),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, -10),
                blurRadius: 35,
                color: Color(0xFF582D1D).withOpacity(0.4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: context.read<MenuBloc>(),
                        child: MenuPage(),
                      ),
                    ),
                  );
                },
                icon: Icon(Icons.fastfood, color: Color(0xFF582D1D)),
              ),
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MapPage()),
                  // );
                },
                icon: Icon(Icons.history, color: Color(0xFF582D1D)),
              ),
              IconButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => MapPage()),
                  // );
                },
                icon: Icon(Icons.map, color: Color(0xFF582D1D)),
              ),
              if (isAdmin)
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: context.read<DashboardAdminBloc>(),
                          child: AdminDashboardPage(),
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.dashboard, color: Color(0xFF582D1D)),
                ),
            ],
          ),
        );
      },
    );
  }
}
