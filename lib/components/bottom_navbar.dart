import 'package:flutter/material.dart';
import 'package:pempekapp/presentation/auth/admin/dashboard_page.dart';

class MyBottomNavBar extends StatelessWidget {
  const MyBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20.0 * 2, right: 20.0 * 2, bottom: 20.0),
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
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => MenuPage()),
              // );
            },
            icon: Icon(Icons.menu, color: Color(0xFF582D1D)),
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
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminDashboardPage()),
              );
            },
            icon: Icon(Icons.dashboard, color: Color(0xFF582D1D)),
          ),
        ],
      ),
    );
  }
}
