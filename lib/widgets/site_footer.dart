import 'package:flutter/material.dart';

import '../app_theme.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.ink,
      padding: const EdgeInsets.fromLTRB(24, 34, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tasty Food',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Nikmati sajian hidangan sehat dan lezat yang diolah dari bahan-'
            'bahan segar pilihan setiap hari. Kami menghadirkan kombinasi '
            'cita rasa sempurna untuk menemani momen bersantap Anda.',
            style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.7),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [_SocialIcon('f'), SizedBox(width: 10), _SocialIcon('t')],
          ),
          const SizedBox(height: 30),
          const _FooterGroup(
            title: 'Useful links',
            items: ['Blog', 'Hewan', 'Galeri', 'Testimonial'],
          ),
          const SizedBox(height: 26),
          const _FooterGroup(
            title: 'Privacy',
            items: ['Karir', 'Tentang Kami', 'Kontak Kami', 'Servis'],
          ),
          const SizedBox(height: 26),
          const Text(
            'Contact Info',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          const _ContactLine(Icons.email_outlined, 'tastyfood@gmail.com'),
          const _ContactLine(Icons.phone_outlined, '+62 812 3456 7890'),
          const _ContactLine(
            Icons.location_on_outlined,
            'Kota Bandung, Jawa Barat',
          ),
          const SizedBox(height: 26),
          const Text(
            'Copyright ©2023 All rights reserved',
            style: TextStyle(color: Colors.white54, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 24,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xff3b5998),
        shape: BoxShape.circle,
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _FooterGroup extends StatelessWidget {
  const _FooterGroup({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 12),
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 9),
            child: Text(
              item,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
      ],
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 15),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
        ],
      ),
    );
  }
}
