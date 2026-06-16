import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../auth/controllers/auth_controller.dart';
import '../../../routes/app_pages.dart';

<<<<<<< HEAD
/// Widget logo Google berwarna resmi menggunakan CustomPainter
class GoogleLogoIcon extends StatelessWidget {
  final double size;
  const GoogleLogoIcon({super.key, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _GoogleLogoPainter(),
      ),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = w / 2;

    // Warna Google
    const Color blue   = Color(0xFF4285F4);
    const Color red    = Color(0xFFEA4335);
    const Color yellow = Color(0xFFFBBC05);
    const Color green  = Color(0xFF34A853);

    final Paint paint = Paint()..style = PaintingStyle.fill;

    // ---- Lingkaran penuh abu-abu sebagai base clip ----
    final path = Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.clipPath(path);

    // ---- Merah (kiri atas) ----
    paint.color = red;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -2.36, // ~225 derajat
      2.09,  // ~120 derajat
      true,
      paint,
    );

    // ---- Hijau (kanan bawah) ----
    paint.color = green;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -0.52, // ~-30 derajat
      1.05,  // ~60 derajat
      true,
      paint,
    );

    // ---- Kuning (bawah) ----
    paint.color = yellow;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      0.52,  // ~30 derajat
      1.05,  // ~60 derajat
      true,
      paint,
    );

    // ---- Biru (kanan atas) ----
    paint.color = blue;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -1.57, // ~-90 derajat
      1.05,  // ~60 derajat
      true,
      paint,
    );

    // ---- Lingkaran putih tengah (donut hole) ----
    paint.color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r * 0.62, paint);

    // ---- Batang horizontal biru (huruf G) ----
    paint.color = blue;
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - r * 0.14, r * 0.98, r * 0.28),
      paint,
    );

    // ---- Tutup lubang putih tengah bawah batang ----
    paint.color = Colors.white;
    canvas.drawCircle(Offset(cx, cy), r * 0.45, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

=======
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
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
                    icon: const GoogleLogoIcon(size: 22),
                    label: const Text(
                      "Masuk dengan Google",
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              }),

              const SizedBox(height: 8),

=======
>>>>>>> ba9cdaa90c21893f7a113c4320b66a26f53446af
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