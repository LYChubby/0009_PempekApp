import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pempekapp/data/models/request/auth/register_request_model.dart';
import 'package:pempekapp/presentation/auth/bloc/register/register_bloc.dart';
import 'package:pempekapp/presentation/auth/login_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final emailController = TextEditingController();
  final noHpController = TextEditingController();
  final alamatController = TextEditingController();
  final passwordController = TextEditingController();
  final confpassController = TextEditingController();
  bool _obscureText = true;
  bool _obscureTextConfirm = true;

  // Color scheme matching the login page
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
      body: BlocListener<RegisterBloc, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
            );
          } else {
            Navigator.pop(context); // Close loading dialog
            if (state is RegisterSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Registrasi berhasil"),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else if (state is RegisterFailure) {
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
          }
        },
        child: SingleChildScrollView(
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
                            "Buat Akun Baru",
                            style: TextStyle(
                              fontSize: screenWidth * 0.06,
                              fontWeight: FontWeight.bold,
                              color: textPrimary,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),
                          Text(
                            "Isi data diri Anda untuk mendaftar",
                            style: TextStyle(
                              fontSize: screenWidth * 0.035,
                              color: textSecondary,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Full Name Field
                          _buildLabel("Nama Lengkap"),
                          SizedBox(height: screenHeight * 0.01),
                          _buildTextField(
                            controller: namaController,
                            hintText: 'Masukkan nama lengkap',
                            icon: Icons.person,
                          ),
                          SizedBox(height: screenHeight * 0.025),

                          // Email Field
                          _buildLabel("Email"),
                          SizedBox(height: screenHeight * 0.01),
                          _buildTextField(
                            controller: emailController,
                            hintText: 'Masukkan email',
                            icon: Icons.email,
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: screenHeight * 0.025),

                          // Phone Number Field
                          _buildLabel("Nomor HP"),
                          SizedBox(height: screenHeight * 0.01),
                          _buildTextField(
                            controller: noHpController,
                            hintText: 'Masukkan nomor HP',
                            icon: Icons.phone,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: screenHeight * 0.025),

                          // Address Field
                          _buildLabel("Alamat"),
                          SizedBox(height: screenHeight * 0.01),
                          _buildTextField(
                            controller: alamatController,
                            hintText: 'Masukkan alamat lengkap',
                            icon: Icons.home,
                          ),
                          SizedBox(height: screenHeight * 0.025),

                          // Password Field
                          _buildLabel("Password"),
                          SizedBox(height: screenHeight * 0.01),
                          _buildPasswordField(
                            controller: passwordController,
                            hintText: 'Masukkan password',
                            obscureText: _obscureText,
                            onToggle: () {
                              setState(() => _obscureText = !_obscureText);
                            },
                          ),
                          SizedBox(height: screenHeight * 0.025),

                          // Confirm Password Field
                          _buildLabel("Konfirmasi Password"),
                          SizedBox(height: screenHeight * 0.01),
                          _buildPasswordField(
                            controller: confpassController,
                            hintText: 'Masukkan ulang password',
                            obscureText: _obscureTextConfirm,
                            onToggle: () {
                              setState(
                                () =>
                                    _obscureTextConfirm = !_obscureTextConfirm,
                              );
                            },
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Register Button
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
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  if (passwordController.text !=
                                      confpassController.text) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Password tidak sama"),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    final request = RegisterRequestModel(
                                      name: namaController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      noHp: noHpController.text,
                                      alamat: alamatController.text,
                                      role: 'customer',
                                    );
                                    context.read<RegisterBloc>().add(
                                      RegisterRequested(requestModel: request),
                                    );
                                  }
                                }
                              },
                              child: BlocBuilder<RegisterBloc, RegisterState>(
                                builder: (context, state) {
                                  return state is RegisterLoading
                                      ? const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Text(
                                          "Daftar",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.04,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        );
                                },
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02),

                          // Login Link
                          Center(
                            child: RichText(
                              text: TextSpan(
                                text: 'Sudah punya akun? ',
                                style: TextStyle(
                                  color: textSecondary,
                                  fontSize: screenWidth * 0.035,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Masuk Disini',
                                    style: TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: screenWidth * 0.035,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w500, color: textPrimary),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: textSecondary.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: cardColor,
        prefixIcon: Icon(icon, color: primaryColor),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Wajib diisi' : null,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: textSecondary.withOpacity(0.6)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: cardColor,
        prefixIcon: Icon(Icons.lock, color: primaryColor),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility_off : Icons.visibility,
            color: primaryColor,
          ),
          onPressed: onToggle,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Wajib diisi' : null,
    );
  }
}
