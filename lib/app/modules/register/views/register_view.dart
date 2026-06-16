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
<<<<<<< HEAD
                  labelText: "Email",
=======
                  labelText: "Username",
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
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

<<<<<<< HEAD
                            // Navigasi ke OTP page sudah ditangani di dalam auth_controller.register()
                            await auth.register(
                              usernameC.text,
                              passwordC.text,
                            );
=======
                            final success = await auth.register(
                              usernameC.text,
                              passwordC.text,
                            );

                            if (success) {
                              Get.offAllNamed('/login');
                            }
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
                          },

                    child: auth.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Register"),
                  ),
                );
              }),
<<<<<<< HEAD

              const SizedBox(height: 16),

              Row(
                children: const [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "atau",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  Expanded(child: Divider()),
                ],
              ),

              const SizedBox(height: 16),

              Obx(() {
                return SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: auth.isLoading.value
                        ? null
                        : () {
                            auth.signInWithGoogle();
                          },
                    icon: const Icon(
                      Icons.login, // General login/google icon
                      color: Colors.redAccent,
                    ),
                    label: const Text(
                      "Daftar dengan Google",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),
=======
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
            ],
          ),
        ),
      ),
    );
  }
}