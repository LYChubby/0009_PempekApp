import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:pempekapp/data/models/request/auth/login_request_model.dart';
import 'package:pempekapp/presentation/auth/admin/dashboard_page.dart';
import 'package:pempekapp/presentation/auth/bloc/login/login_bloc.dart';
import 'package:pempekapp/presentation/auth/register_screen.dart';
import 'package:pempekapp/presentation/menu/menu_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _obscureText = true;

  // Color scheme
  static const Color primaryColor = Color.fromRGBO(88, 45, 29, 1);
  static const Color primaryLight = Color.fromRGBO(139, 69, 19, 1);
  static const Color accentColor = Color.fromRGBO(255, 165, 0, 1);
  static const Color backgroundColor = Color.fromRGBO(250, 248, 246, 1);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color.fromRGBO(33, 37, 41, 1);
  static const Color textSecondary = Color.fromRGBO(108, 117, 125, 1);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            final role = state.responseModel.user?.role?.toLowerCase();
            if (role == 'admin') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => AdminDashboardPage()),
                (route) => false,
              );
            } else if (role == 'customer') {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => MenuPage()),
                (route) => false,
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Role tidak dikenali")),
              );
            }
          } else if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Section
                      Container(
                        height: screenHeight * 0.25,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [primaryColor, primaryLight],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                        child: Center(
                          child: Image.network(
                            'https://static.vecteezy.com/system/resources/thumbnails/051/102/095/small_2x/pempek-an-amazing-indonesian-food-illustration-png.png',
                            height: screenHeight * 0.15,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight * 0.03),

                      // Content Section
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Selamat Datang Kembali",
                              style: TextStyle(
                                fontSize: screenWidth * 0.06,
                                fontWeight: FontWeight.bold,
                                color: textPrimary,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              "Silakan masuk untuk melanjutkan",
                              style: TextStyle(
                                fontSize: screenWidth * 0.035,
                                color: textSecondary,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.04),

                            // Email Field
                            Text(
                              'Email',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: emailController,
                              decoration: InputDecoration(
                                hintText: 'Masukkan email',
                                hintStyle: TextStyle(
                                  color: textSecondary.withOpacity(0.6),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: cardColor,
                                prefixIcon: Icon(
                                  Icons.email,
                                  color: primaryColor,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Email wajib diisi'
                                  : null,
                            ),
                            SizedBox(height: screenHeight * 0.025),

                            // Password Field
                            Text(
                              'Password',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: textPrimary,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.01),
                            TextFormField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              decoration: InputDecoration(
                                hintText: 'Masukkan password',
                                hintStyle: TextStyle(
                                  color: textSecondary.withOpacity(0.6),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: cardColor,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: primaryColor,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: primaryColor,
                                  ),
                                  onPressed: () {
                                    setState(
                                      () => _obscureText = !_obscureText,
                                    );
                                  },
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) =>
                                  (value == null || value.isEmpty)
                                  ? 'Password wajib diisi'
                                  : null,
                            ),
                            SizedBox(height: screenHeight * 0.03),

                            // Login Button
                            SizedBox(
                              height: screenHeight * 0.06,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 3,
                                  shadowColor: primaryColor.withOpacity(0.3),
                                ),
                                onPressed: state is LoginLoading
                                    ? null
                                    : () {
                                        if (_formKey.currentState!.validate()) {
                                          final loginRequest =
                                              LoginRequestModel(
                                                email: emailController.text,
                                                password:
                                                    passwordController.text,
                                              );
                                          context.read<LoginBloc>().add(
                                            LoginRequested(
                                              requestModel: loginRequest,
                                            ),
                                          );
                                        }
                                      },
                                child: state is LoginLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(
                                        "Masuk",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.04,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.02),

                            // Register Link
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Belum punya akun? ',
                                  style: TextStyle(
                                    color: textSecondary,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Daftar Disini',
                                      style: TextStyle(
                                        color: primaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: screenWidth * 0.035,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const RegisterPage(),
                                            ),
                                          );
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
