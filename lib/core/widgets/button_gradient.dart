import 'package:flutter/material.dart';

import '../constants/colors.dart';

class ButtonGradientPrimary extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? iconLeft;
  final IconData? iconRight;

  const ButtonGradientPrimary({
    super.key,
    required this.text,
    required this.onPressed,
    this.iconLeft,
    this.iconRight,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.highlighterBlueDark, // biru terang atas
              AppColors.primaryColor, // biru gelap bawah
            ],
          ),
        ),
        child: Stack(
          children: [
            // highlight putih lembut hanya atas (inner effect)
            Positioned(
              top: 2,
              left: 7,
              right: 7,
              height: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withAlpha(
                        (0.3 * 255).toInt(),
                      ), // putih halus atas
                      Colors.transparent, // memudar ke bawah
                    ],
                  ),
                ),
              ),
            ),
            // tombol teks
            TextButton(
              onPressed: onPressed,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconLeft != null) ...[
                    Icon(iconLeft, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  if (iconRight != null) ...[
                    const SizedBox(width: 8),
                    Icon(iconRight, color: Colors.white, size: 20),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientButtonDanger extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButtonDanger({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.errorStateLightRed, // biru terang atas
              AppColors.dangerColor, // biru gelap bawah
            ],
          ),
        ),
        child: Stack(
          children: [
            // highlight putih lembut hanya atas (inner effect)
            Positioned(
              top: 2,
              left: 7,
              right: 7,
              height: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withAlpha(
                        (0.3 * 255).toInt(),
                      ), // putih halus atas
                      Colors.transparent, // memudar ke bawah
                    ],
                  ),
                ),
              ),
            ),
            // tombol teks
            Center(
              child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientButtonSuccess extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButtonSuccess({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 18, 168, 179), // biru terang atas
              Color.fromARGB(255, 3, 145, 150), // biru gelap bawah
            ],
          ),
        ),
        child: Stack(
          children: [
            // highlight putih lembut hanya atas (inner effect)
            Positioned(
              top: 2,
              left: 7,
              right: 7,
              height: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withAlpha(
                        (0.2 * 255).toInt(),
                      ), // putih halus atas
                      const Color.fromARGB(
                        0,
                        255,
                        255,
                        255,
                      ), // memudar ke bawah
                    ],
                  ),
                ),
              ),
            ),
            // tombol teks
            Center(
              child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GradientButtonWarning extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButtonWarning({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 255, 189, 7), // biru terang atas
              Color.fromARGB(255, 219, 151, 3), // biru gelap bawah
            ],
          ),
        ),
        child: Stack(
          children: [
            // highlight putih lembut hanya atas (inner effect)
            Positioned(
              top: 2,
              left: 7,
              right: 7,
              height: 3,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withAlpha(
                        (0.2 * 255).toInt(),
                      ), // putih halus atas
                      const Color.fromARGB(
                        0,
                        255,
                        255,
                        255,
                      ), // memudar ke bawah
                    ],
                  ),
                ),
              ),
            ),
            // tombol teks
            Center(
              child: TextButton(
                onPressed: onPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
