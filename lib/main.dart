import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pempekapp/data/repository/auth_repository.dart';
import 'package:pempekapp/data/repository/dashboard_repository.dart';
import 'package:pempekapp/data/repository/menu_repository.dart';
import 'package:pempekapp/data/repository/pembayaran_repository.dart';
import 'package:pempekapp/data/repository/pemesanan_repository.dart';
import 'package:pempekapp/data/services/service_http_client.dart';
import 'package:pempekapp/presentation/auth/admin/bloc/dashboard_admin_bloc.dart';
import 'package:pempekapp/presentation/auth/bloc/login/login_bloc.dart';
import 'package:pempekapp/presentation/auth/bloc/register/register_bloc.dart';
import 'package:pempekapp/presentation/auth/login_screen.dart';
import 'package:pempekapp/presentation/menu/bloc/menu_bloc.dart';
import 'package:pempekapp/presentation/pemesanan/bloc/checkout_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              LoginBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) =>
              RegisterBloc(authRepository: AuthRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => DashboardAdminBloc(
            dashboardRepository: DashboardRepository(ServiceHttpClient()),
          ),
        ),
        BlocProvider(
          create: (_) =>
              MenuBloc(menuRepository: MenuRepository(ServiceHttpClient())),
        ),
        BlocProvider(
          create: (_) => CheckoutBloc(
            pemesananRepository: PemesananRepository(ServiceHttpClient()),
            pembayaranRepository: PembayaranRepository(ServiceHttpClient()),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
