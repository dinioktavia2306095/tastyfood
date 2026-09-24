import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../widgets/net_image.dart';
import '../widgets/page_hero.dart';
import '../widgets/site_footer.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key, required this.galleryFuture});

  final Future<List<Map<String, dynamic>>> galleryFuture;

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _move(int delta, int length) {
    final next = (_page + delta).clamp(0, length - 1);
    _controller.animateToPage(
      next,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: widget.galleryFuture,
      builder: (context, snapshot) {
        final loading = snapshot.connectionState == ConnectionState.waiting;
        final items = snapshot.data ?? [];

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const PageHero(title: 'GALERI KAMI'),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 70),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (snapshot.hasError)
              _message(
                'Foto galeri tidak bisa dimuat. Pastikan server Laravel berjalan.',
              )
            else if (items.isEmpty)
              _message('Belum ada foto di galeri.')
            else ...[
              _carousel(items),
              _grid(items),
            ],
            const SiteFooter(),
          ],
        );
      },
    );
  }

  Widget _carousel(List<Map<String, dynamic>> items) {
    return Container(
      color: AppColors.soft,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 36),
      child: SizedBox(
        height: 230,
        child: Stack(
          children: [
            Positioned.fill(
              child: PageView.builder(
                controller: _controller,
                itemCount: items.length,
                onPageChanged: (index) => setState(() => _page = index),
                itemBuilder: (context, index) => NetImage(
                  '${items[index]['image_url']}',
                  radius: 10,
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: _arrow(Icons.chevron_left, () => _move(-1, items.length)),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: _arrow(Icons.chevron_right, () => _move(1, items.length)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _arrow(IconData icon, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        elevation: 2,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            height: 40,
            width: 40,
            child: Icon(icon, color: AppColors.ink),
          ),
        ),
      ),
    );
  }

  Widget _grid(List<Map<String, dynamic>> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 44),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
        ),
        itemBuilder: (context, index) => GestureDetector(
          onTap: () => _preview('${items[index]['image_url']}'),
          child: NetImage('${items[index]['image_url']}', radius: 8),
        ),
      ),
    );
  }

  void _preview(String url) {
    showDialog<void>(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(18),
        child: InteractiveViewer(child: NetImage(url, radius: 10)),
      ),
    );
  }

  Widget _message(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 70),
      child: Text(text, textAlign: TextAlign.center, style: AppText.paragraph),
    );
  }
}