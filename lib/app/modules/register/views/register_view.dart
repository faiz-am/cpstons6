import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../auth/controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final nameC = TextEditingController();
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
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 430),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: 130,
                          width: double.infinity,
                          color: const Color(0xffdbeafe),
                          child: const Center(
                            child: Icon(
                              Icons.health_and_safety_outlined,
                              size: 48,
                              color: Color(0xff2563eb),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        "Join Us",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff0f172a),
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        "Buat akun untuk mulai mencatat gaya hidup sehatmu.",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xff64748b),
                        ),
                      ),

                      const SizedBox(height: 22),

                      TextField(
                        controller: nameC,
                        decoration: InputDecoration(
                          hintText: "Nama Lengkap",
                          prefixIcon: const Icon(Icons.person_outline),
                          filled: true,
                          fillColor: const Color(0xfff8fafc),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

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

                      const SizedBox(height: 12),

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
                            auth.register(
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
                          child: const Text("Create Account"),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Sudah punya akun? Login"),
                        ),
                      ),
                    ],
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