import 'package:flutter/material.dart';

import '../api_service.dart';
import '../app_config.dart';
import '../app_theme.dart';
import '../main.dart';
import '../widgets/net_image.dart';
import '../widgets/news_card.dart';
import '../widgets/site_chrome.dart';
import '../widgets/site_footer.dart';
import 'about_page.dart';
import 'contact_page.dart';
import 'gallery_page.dart';
import 'news_page.dart';

const _navItems = [
  NavItem('HOME', Icons.home_outlined),
  NavItem('TENTANG', Icons.info_outline),
  NavItem('BERITA', Icons.article_outlined),
  NavItem('GALERI', Icons.photo_library_outlined),
  NavItem('KONTAK', Icons.mail_outline),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.userName});

  final String? userName;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Map<String, dynamic>>> _newsFuture;
  late Future<List<Map<String, dynamic>>> _galleryFuture;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _newsFuture = ApiService.fetchItems('news');
    _galleryFuture = ApiService.fetchItems('gallery');
  }

  void _go(int index) {
    setState(() {
      _index = index;
      if (index == 0 || index == 2) {
        _newsFuture = ApiService.fetchItems('news');
      }
      if (index == 0 || index == 3) {
        _galleryFuture = ApiService.fetchItems('gallery');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeLandingPage(
        newsFuture: _newsFuture,
        galleryFuture: _galleryFuture,
        onNavigate: _go,
      ),
      const AboutPage(),
      NewsPage(newsFuture: _newsFuture),
      GalleryPage(galleryFuture: _galleryFuture),
      const ContactPage(),
    ];

    return Scaffold(
      appBar: siteAppBar(
        brand: 'TASTY FOOD',
        userLabel: widget.userName ?? 'Web User',
      ),
      drawer: SiteDrawer(
        brand: 'TASTY FOOD',
        items: _navItems,
        selectedIndex: _index,
        onSelect: _go,
        onLogout: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        ),
      ),
      body: pages[_index],
    );
  }
}

class HomeLandingPage extends StatefulWidget {
  const HomeLandingPage({
    super.key,
    required this.newsFuture,
    required this.galleryFuture,
    this.onNavigate,
  });

  final Future<List<Map<String, dynamic>>> newsFuture;
  final Future<List<Map<String, dynamic>>> galleryFuture;
  final ValueChanged<int>? onNavigate;

  @override
  State<HomeLandingPage> createState() => _HomeLandingPageState();
}

class _HomeLandingPageState extends State<HomeLandingPage> {
  final _highlightController = ScrollController();

  @override
  void dispose() {
    _highlightController.dispose();
    super.dispose();
  }

  void _scrollHighlights(double offset) {
    final target = (_highlightController.offset + offset).clamp(
      0.0,
      _highlightController.position.maxScrollExtent,
    );
    _highlightController.animateTo(
      target,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        _hero(context),
        _aboutIntro(),
        _highlightStrip(),
        _newsSection(context),
        _gallerySection(context),
        const SiteFooter(),
      ],
    );
  }

  Widget _hero(BuildContext context) {
    return Container(
      color: AppColors.soft,
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 44, height: 2, color: AppColors.ink),
          const SizedBox(height: 22),
          const Text(
            'HEALTHY',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w300,
              letterSpacing: 1.4,
              color: AppColors.ink,
            ),
          ),
          const Text('TASTY FOOD', style: AppText.display),
          const SizedBox(height: 18),
          const Text(
            'Nikmati sajian hidangan sehat dan lezat yang diolah dari bahan-'
            'bahan segar pilihan setiap hari. Kami menghadirkan kombinasi '
            'cita rasa sempurna untuk menemani momen bersantap Anda.',
            style: AppText.paragraph,
          ),
          const SizedBox(height: 24),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton(
              onPressed: () => widget.onNavigate?.call(1),
              child: const Text('TENTANG KAMI'),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: ClipOval(
              child: NetImage(
                assetUrl(AppImages.heroPlate),
                height: 290,
                width: 290,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutIntro() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 44, 24, 40),
      child: Column(
        children: [
          const SectionTitle('TENTANG KAMI'),
          const SizedBox(height: 16),
          const Text(
            'Tasty Food adalah tempat terbaik untuk menikmati kuliner bermutu '
            'tinggi dengan konsep hidangan sehat, higienis, dan kaya rasa.',
            textAlign: TextAlign.center,
            style: AppText.paragraph,
          ),
          const SizedBox(height: 22),
          Container(width: 64, height: 2, color: AppColors.ink),
        ],
      ),
    );
  }

  /// Pita gelap berisi kartu menu unggulan yang bisa digeser.
  Widget _highlightStrip() {
    const titles = [
      'BAHAN SEGAR',
      'NUTRISI SEIMBANG',
      'KOKI PROFESIONAL',
      'VARIASI MENU',
    ];
    const descriptions = [
      'Dibuat langsung menggunakan bahan baku lokal dan organik yang dijaga kesegarannya.',
      'Setiap porsi dirancang khusus untuk memenuhi kebutuhan gizi harian Anda secara seimbang.',
      'Diolah oleh tim koki berpengalaman untuk memastikan cita rasa yang konsisten dan lezat.',
      'Menyediakan beragam pilihan menu favorit mulai dari hidangan pembuka hingga penutup.',
    ];
    final images = AppImages.highlights.map(assetUrl).toList();

    return SizedBox(
      height: 340,
      child: Stack(
        fit: StackFit.expand,
        children: [
          NetImage(assetUrl(AppImages.banner)),
          const DecoratedBox(
            decoration: BoxDecoration(color: Color(0x73000000)),
          ),
          Scrollbar(
            controller: _highlightController,
            thumbVisibility: true,
            child: ListView.separated(
              controller: _highlightController,
              primary: false,
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(24, 30, 24, 30),
              itemCount: images.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) => SizedBox(
                width: 210,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ClipOval(
                          child: NetImage(
                            images[index],
                            height: 100,
                            width: 100,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          titles[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.cardTitle,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          descriptions[index],
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: AppText.paragraph.copyWith(
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 8,
            top: 145,
            child: _highlightArrow(
              Icons.chevron_left,
              () => _scrollHighlights(-224),
            ),
          ),
          Positioned(
            right: 8,
            top: 145,
            child: _highlightArrow(
              Icons.chevron_right,
              () => _scrollHighlights(224),
            ),
          ),
        ],
      ),
    );
  }

  Widget _highlightArrow(IconData icon, VoidCallback onPressed) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(icon, color: AppColors.ink),
        ),
      ),
    );
  }

  Widget _newsSection(BuildContext context) {
    return Container(
      color: AppColors.soft,
      padding: const EdgeInsets.fromLTRB(20, 44, 20, 44),
      child: Column(
        children: [
          const SectionTitle('BERITA KAMI'),
          const SizedBox(height: 26),
          Column(
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    NetImage(
                      assetUrl(AppImages.homeNewsImages.first),
                      height: 210,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'RAHASIA CITA RASA LEZAT & SEHAT TASTY FOOD',
                            style: AppText.cardTitle.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Kunci dari hidangan istimewa kami terletak pada pemilihan bahan-bahan alami tanpa pengawet serta teknik memasak yang tepat untuk menjaga keaslian rasa dan nutrisi.',
                            style: AppText.paragraph,
                          ),
                          const SizedBox(height: 18),
                          InkWell(
                            onTap: () => widget.onNavigate?.call(2),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Baca selengkapnya',
                                    style: AppText.link,
                                  ),
                                  Icon(
                                    Icons.more_horiz,
                                    size: 18,
                                    color: AppColors.muted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: AppImages.homeNewsImages.length - 1,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  mainAxisExtent: 320,
                ),
                itemBuilder: (context, index) => NewsCard(
                  title: [
                    'Tips Memilih Makanan Sehat Sehari-hari',
                    'Dedikasi Koki Dalam Setiap Sajian',
                    'Olahan Sayur Lezat yang Disukai Keluarga',
                    'Promo Spesial Paket Healthy Catering',
                  ][index],
                  excerpt: [
                    'Pelajari cara mudah menjaga pola makan sehat di tengah kesibukan harian Anda.',
                    'Intip cerita di balik dapur dalam menyiapkan hidangan terbaik untuk pelanggan.',
                    'Resep dan teknik mengolah sayuran agar tetap renyah, segar, dan menggugah selera.',
                    'Nikmati tawaran menarik untuk langganan menu sehat mingguan bersama Tasty Food.',
                  ][index],
                  imageUrl: assetUrl(AppImages.homeNewsImages[index + 1]),
                  onTap: () => widget.onNavigate?.call(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gallerySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 44, 20, 44),
      child: Column(
        children: [
          const SectionTitle('GALERI KAMI'),
          const SizedBox(height: 26),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: AppImages.homeGalleryImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
            ),
            itemBuilder: (context, index) => NetImage(
              assetUrl(AppImages.homeGalleryImages[index]),
              radius: 8,
            ),
          ),
          const SizedBox(height: 30),
          FilledButton(
            onPressed: () => widget.onNavigate?.call(3),
            child: const Text('LIHAT LEBIH BANYAK'),
          ),
        ],
      ),
    );
  }
}
