import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api_service.dart';
import '../app_config.dart';
import '../app_theme.dart';
import '../widgets/net_image.dart';
import '../widgets/page_hero.dart';
import '../widgets/site_footer.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _formKey = GlobalKey<FormState>();
  final _subject = TextEditingController();
  static final _mapsUri = Uri.parse(
    'https://maps.app.goo.gl/ymDMhjMqbFBZcuSx5',
  );
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _message = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _subject.dispose();
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _sending = true);

    try {
      await ApiService.sendMessage(
        subject: _subject.text.trim(),
        name: _name.text.trim(),
        email: _email.text.trim(),
        message: _message.text.trim(),
      );
      if (!mounted) return;
      _formKey.currentState!.reset();
      _subject.clear();
      _name.clear();
      _email.clear();
      _message.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pesan terkirim. Kami akan membalas segera.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Pesan belum terkirim. Periksa koneksi ke server Laravel.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  Future<void> _openMaps() async {
    final opened = await launchUrl(
      _mapsUri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Maps tidak dapat dibuka.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const PageHero(title: 'KONTAK KAMI'),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'KONTAK KAMI',
                  style: AppText.section.copyWith(fontSize: 19),
                ),
                const SizedBox(height: 24),
                _field(_subject, 'Subject'),
                _field(_name, 'Name'),
                _field(_email, 'Email', email: true),
                _field(_message, 'Message', lines: 6),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: _sending ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.ink,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _sending
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('KIRIM'),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 46),
          child: Column(
            children: [
              _infoBlock(Icons.mail_outline, 'EMAIL', 'tastyfood@gmail.com'),
              _infoBlock(Icons.phone_outlined, 'PHONE', '+62 812 3456 7890'),
              _infoBlock(
                Icons.location_on_outlined,
                'LOCATION',
                'Kota Bandung, Jawa Barat',
              ),
            ],
          ),
        ),
        Container(
          color: AppColors.soft,
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _openMaps,
                  child: SizedBox(
                    height: 260,
                    width: double.infinity,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        NetImage(assetUrl('images/map.png'), fit: BoxFit.cover),
                        const Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: EdgeInsets.all(14),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(6),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                child: Text(
                                  'Buka lokasi di Google Maps',
                                  style: TextStyle(
                                    color: AppColors.ink,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _openMaps,
                icon: const Icon(Icons.map_outlined, size: 18),
                label: const Text('BUKA DI GOOGLE MAPS'),
              ),
            ],
          ),
        ),
        const SiteFooter(),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String hint, {
    int lines = 1,
    bool email = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: lines,
        keyboardType: email
            ? TextInputType.emailAddress
            : TextInputType.multiline,
        decoration: InputDecoration(hintText: hint),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$hint wajib diisi';
          }
          if (email && !value.contains('@')) return 'Masukkan email yang valid';
          return null;
        },
      ),
    );
  }

  Widget _infoBlock(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          Container(
            height: 62,
            width: 62,
            decoration: const BoxDecoration(
              color: AppColors.ink,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 16),
          Text(label, style: AppText.cardTitle),
          const SizedBox(height: 8),
          Text(value, style: AppText.paragraph),
        ],
      ),
    );
  }
}
