import 'package:flutter/material.dart';

import '../app_config.dart';
import '../app_theme.dart';
import '../widgets/net_image.dart';
import '../widgets/news_card.dart';
import '../widgets/page_hero.dart';
import '../widgets/site_chrome.dart';
import '../widgets/site_footer.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key, required this.newsFuture});

  final Future<List<Map<String, dynamic>>> newsFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: newsFuture,
      builder: (context, snapshot) {
        final loading = snapshot.connectionState == ConnectionState.waiting;
        final items = snapshot.data ?? [];

        return ListView(
          padding: EdgeInsets.zero,
          children: [
            const PageHero(title: 'BERITA KAMI'),
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 70),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (snapshot.hasError)
              const _Message(
                'Data berita tidak bisa dimuat. Pastikan server Laravel berjalan.',
              )
            else if (items.isEmpty)
              const _Message('Belum ada berita yang diterbitkan.')
            else ...[
              _featured(context),
              _others(items),
            ],
            const SiteFooter(),
          ],
        );
      },
    );
  }

  Widget _featured(BuildContext context) {
    final item = <String, dynamic>{
      'title': 'Apa Saja Makanan Khas Nusantara?',
      'image_url': assetUrl('images/eiliv-aceron-ZuIDLSz3XLg-unsplash.jpg'),
      'excerpt':
          'Kuliner Nusantara dikenal dengan kekayaan cita rasa dan '
          'keanekaragaman rempah alaminya yang otentik. Setiap daerah di '
          'Indonesia memiliki hidangan khas yang menyimpan sejarah, budaya, '
          'dan keunikan rasa tersendiri, mulai dari gurihnya Rendang Padang '
          'yang diakui dunia, menyegarkannya Soto dengan kuah rempahnya yang '
          'khas, hingga kelezatan Sate yang dibakar sempurna dengan bumbu '
          'kacang yang gurih.',
      'content':
          'Indonesia memiliki kekayaan kuliner yang mencerminkan sejarah, '
          'budaya, dan hasil bumi dari setiap daerah.\n\nRendang dari '
          'Sumatera Barat dimasak perlahan bersama santan dan rempah hingga '
          'bumbunya meresap sempurna. Soto memiliki banyak variasi daerah, '
          'dengan kuah bening, kuning, atau santan serta isian dan pelengkap '
          'yang beragam. Gudeg khas Yogyakarta dibuat dari nangka muda yang '
          'dimasak bersama santan dan gula merah, lalu disajikan dengan '
          'berbagai pelengkap. Pempek khas Palembang berbahan ikan dan tepung '
          'sagu, kemudian disajikan dengan kuah cuko yang asam, manis, pedas, '
          'dan gurih.',
    };

    return Container(
      color: AppColors.soft,
      padding: const EdgeInsets.fromLTRB(20, 44, 20, 52),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 700;
          final image = NetImage(
            '${item['image_url']}',
            height: wide ? 360 : 240,
            width: double.infinity,
            radius: 16,
          );
          final text = Padding(
            padding: EdgeInsets.only(top: wide ? 0 : 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${item['title']}'.toUpperCase(),
                  style: AppText.section.copyWith(
                    fontSize: wide ? 24 : 20,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  '${item['excerpt'] ?? ''}',
                  style: AppText.paragraph.copyWith(fontSize: 12),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton(
                    onPressed: () => _openDetail(context, item),
                    child: const Text('BACA SELENGKAPNYA'),
                  ),
                ),
              ],
            ),
          );

          return ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1140),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: image),
                      const SizedBox(width: 44),
                      Expanded(child: text),
                    ],
                  )
                : Column(children: [image, text]),
          );
        },
      ),
    );
  }

  Widget _others(List<Map<String, dynamic>> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle('BERITA LAINNYA', align: TextAlign.left),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1000
                  ? 4
                  : constraints.maxWidth >= 600
                  ? 2
                  : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  mainAxisExtent: columns == 1 ? 390 : 360,
                ),
                itemBuilder: (context, index) => NewsCard(
                  title: '${items[index]['title']}',
                  excerpt: '${items[index]['excerpt'] ?? ''}',
                  imageUrl: '${items[index]['image_url']}',
                  onTap: () => _openDetail(context, items[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Map<String, dynamic> item) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => NewsDetailPage(item: item)));
  }
}

class NewsDetailPage extends StatelessWidget {
  const NewsDetailPage({super.key, required this.item});

  final Map<String, dynamic> item;

  @override
  Widget build(BuildContext context) {
    final content = '${item['content'] ?? item['excerpt'] ?? ''}';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'BERITA',
          style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          NetImage('${item['image_url']}', height: 240),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${item['title']}'.toUpperCase(),
                  style: AppText.section.copyWith(fontSize: 19, height: 1.35),
                ),
                const SizedBox(height: 18),
                Text(content, style: AppText.paragraph),
              ],
            ),
          ),
          const SiteFooter(),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 70),
      child: Text(text, textAlign: TextAlign.center, style: AppText.paragraph),
    );
  }
}
