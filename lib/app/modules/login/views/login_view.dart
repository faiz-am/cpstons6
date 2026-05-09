import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final emailC = TextEditingController();
    final passC = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xfff5f9ff),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final horizontal = w > 700 ? w * 0.18 : w * 0.07;

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontal,
                vertical: 26,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight - 52,
                ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 430),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                            color: const Color(0xff2563eb),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: const Icon(
                            Icons.favorite_outline,
                            color: Colors.white,
                            size: 30,
                          ),
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          "HealthyLife",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff0f172a),
                          ),
                        ),

                        const SizedBox(height: 8),

                        const Text(
                          "Masuk untuk mulai memantau gaya hidup sehatmu.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            color: Color(0xff64748b),
                          ),
                        ),

                        const SizedBox(height: 28),

                        TextField(
                          controller: emailC,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email",
                            prefixIcon: const Icon(Icons.email_outlined),
                            filled: true,
                            fillColor: const Color(0xfff8fafc),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller: passC,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: const Icon(Icons.lock_outline),
                            filled: true,
                            fillColor: const Color(0xfff8fafc),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              auth.login(
                                emailC.text.trim(),
                                passC.text.trim(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2563eb),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text("Login"),
                          ),
                        ),

                        const SizedBox(height: 16),

                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.REGISTER);
                          },
                          child: const Text("Belum punya akun? Register"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}