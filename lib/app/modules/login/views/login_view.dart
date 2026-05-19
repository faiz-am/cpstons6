import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

class LoginView extends StatelessWidget {

  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = Get.find<AuthController>();

    final usernameC = TextEditingController();
    final passwordC = TextEditingController();

    return Scaffold(

      backgroundColor: const Color(0xfff5f9ff),

      body: Center(

        child: Container(

          constraints: const BoxConstraints(maxWidth: 420),

          padding: const EdgeInsets.all(24),

          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),

          child: Column(

            mainAxisSize: MainAxisSize.min,

            children: [

              const Icon(Icons.favorite, size: 60, color: Colors.blue),

              const SizedBox(height: 10),

              const Text(
                "Sehat App",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: usernameC,
                decoration: const InputDecoration(
                  labelText: "Username",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: passwordC,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              Obx(() {

                return SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: ElevatedButton(

                    onPressed: auth.isLoading.value
                        ? null
                        : () {

                            auth.login(
                              usernameC.text,
                              passwordC.text,
                            );
                          },

                    child: auth.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Login"),
                  ),
                );
              }),

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
    );
  }
}