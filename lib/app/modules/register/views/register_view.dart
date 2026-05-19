import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';

class RegisterView extends StatelessWidget {

  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {

    final auth = Get.find<AuthController>();

    final usernameC = TextEditingController();
    final passwordC = TextEditingController();

    return Scaffold(

      backgroundColor: const Color(0xfff5f9ff),

      appBar: AppBar(title: const Text("Register")),

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

              const Text(
                "Create Account",
                style: TextStyle(
                  fontSize: 22,
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
                        : () async {

                            if (usernameC.text.isEmpty ||
                                passwordC.text.isEmpty) {

                              Get.snackbar(
                                "Error",
                                "Tidak boleh kosong",
                              );

                              return;
                            }

                            final success = await auth.register(
                              usernameC.text,
                              passwordC.text,
                            );

                            if (success) {
                              Get.offAllNamed('/login');
                            }
                          },

                    child: auth.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Register"),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}