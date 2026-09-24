import 'package:flutter/material.dart';

import '../app_config.dart';
import 'net_image.dart';

class PageHero extends StatelessWidget {
  const PageHero({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 220,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetImage(assetUrl(AppImages.banner)),
          const DecoratedBox(
            decoration: BoxDecoration(color: Color(0x99000000)),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
