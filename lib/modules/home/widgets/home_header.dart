import 'package:flutter/material.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          // Teks kiri
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Let's Find your",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                Text(
                  "Favorite Home",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Spacer untuk dorong ikon ke kanan
          const SizedBox(width: 5),

          // Ikon notification di kanan
          const Icon(
            MingCuteIcons.mgc_notification_line,
            size: 24,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
