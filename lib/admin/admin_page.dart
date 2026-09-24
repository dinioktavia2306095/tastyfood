import 'package:flutter/material.dart';

import '../api_service.dart';
import '../app_theme.dart';
import '../main.dart';
import '../widgets/net_image.dart';
import '../widgets/site_chrome.dart';

const _adminNav = [
  NavItem('Beranda Dashboard', Icons.dashboard_outlined),
  NavItem('Kelola Berita', Icons.article_outlined),
  NavItem('Kelola Galeri', Icons.photo_library_outlined),
  NavItem('Kotak Masuk Pesan', Icons.mail_outline),
];

class AdminPage extends StatefulWidget {
  const AdminPage({super.key, this.userName, this.token});

  final String? userName;
  final String? token;

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<Map<String, dynamic>> _dashboardFuture;
  late Future<List<Map<String, dynamic>>> _newsFuture;
  late Future<List<Map<String, dynamic>>> _galleryFuture;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = ApiService.dashboard(widget.token);
    _newsFuture = ApiService.fetchItems('news');
    _galleryFuture = ApiService.fetchItems('gallery');
  }

  void _reload() {
    setState(() {
      _dashboardFuture = ApiService.dashboard(widget.token);
      _newsFuture = ApiService.fetchItems('news');
      _galleryFuture = ApiService.fetchItems('gallery');
    });
  }

  @override
  Widget build(BuildContext context) {
    final bodies = [
      _dashboard(),
      _newsList(),
      _galleryList(),
      _messages(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff3f4f6),
      appBar: siteAppBar(
        brand: _adminNav[_index].label,
        userLabel: widget.userName ?? 'Web User',
      ),
      drawer: SiteDrawer(
        brand: 'ADMIN PANEL',
        items: _adminNav,
        selectedIndex: _index,
        onSelect: (index) => setState(() => _index = index),
        onLogout: () => Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async => _reload(),
        child: bodies[_index],
      ),
    );
  }

  Widget _dashboard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _dashboardFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _error('Dashboard admin gagal dimuat dari Laravel.');
        }
        final data = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(18),
          children: [
            _statCard(
              '📰',
              'Total Berita',
              '${data['total_berita'] ?? 0} Berita',
              const Color(0xfffdf0c8),
            ),
            _statCard(
              '🖼️',
              'Total Galeri',
              '${data['total_galeri'] ?? 0} Foto',
              const Color(0xffdbeafe),
            ),
            _statCard(
              '✉️',
              'Pesan Belum Dibaca',
              '${data['pesan_belum_dibaca'] ?? 0} Pesan Baru',
              const Color(0xfffde2e4),
            ),
          ],
        );
      },
    );
  }

  Widget _statCard(String emoji, String label, String value, Color tint) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            height: 54,
            width: 54,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(emoji, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 18),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(color: Color(0xff8b95a5), fontSize: 13),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff1f2a44),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _panel({required String title, required Widget child}) {
    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xff1f2a44),
                ),
              ),
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.line),
              const SizedBox(height: 14),
              child,
            ],
          ),
        ),
      ],
    );
  }

  Widget _newsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data ?? [];
        return _panel(
          title: 'Daftar Berita',
          child: items.isEmpty
              ? const Text('Belum ada berita.')
              : Column(
                  children: items
                      .map(
                        (item) => ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: SizedBox(
                            width: 64,
                            height: 48,
                            child: NetImage('${item['image_url']}', radius: 6),
                          ),
                          title: Text(
                            '${item['title']}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(
                            '${item['excerpt'] ?? ''}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                ),
        );
      },
    );
  }

  Widget _galleryList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _galleryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final items = snapshot.data ?? [];
        return _panel(
          title: 'Daftar Foto Galeri',
          child: items.isEmpty
              ? const Text('Belum ada foto.')
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: items.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  itemBuilder: (context, index) =>
                      NetImage('${items[index]['image_url']}', radius: 6),
                ),
        );
      },
    );
  }

  Widget _messages() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ApiService.fetchItems('admin/messages'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _error(
            'Endpoint GET /api/admin/messages belum tersedia di Laravel.',
          );
        }
        final items = snapshot.data ?? [];
        return _panel(
          title: 'Daftar Pesan Kontak Kami',
          child: items.isEmpty
              ? const Text('Belum ada pesan masuk.')
              : Column(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Text('${i + 1}'),
                        title: Text(
                          '${items[i]['name'] ?? '-'}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text('${items[i]['email'] ?? '-'}'),
                      ),
                  ],
                ),
        );
      },
    );
  }

  Widget _error(String message) {
    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        const SizedBox(height: 60),
        Text(message, textAlign: TextAlign.center, style: AppText.paragraph),
      ],
    );
  }
}