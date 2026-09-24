import 'package:flutter/material.dart';

import '../app_theme.dart';

class NavItem {
  const NavItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.align = TextAlign.center});

  final String title;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: align,
      style: AppText.section.copyWith(fontSize: 19),
    );
  }
}

PreferredSizeWidget siteAppBar({
  required String brand,
  required String userLabel,
}) {
  return AppBar(
    backgroundColor: Colors.white,
    surfaceTintColor: Colors.white,
    elevation: 0,
    centerTitle: false,
    title: Text(
      brand,
      style: const TextStyle(
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 12),
        child: Center(
          child: Text(
            userLabel,
            style: const TextStyle(
              color: AppColors.body,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ],
  );
}

class SiteDrawer extends StatelessWidget {
  const SiteDrawer({
    super.key,
    required this.brand,
    required this.items,
    required this.selectedIndex,
    required this.onSelect,
    required this.onLogout,
  });

  final String brand;
  final List<NavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 28, 18, 18),
              decoration: const BoxDecoration(color: AppColors.ink),
              child: Text(
                brand,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final active = index == selectedIndex;
                  return ListTile(
                    leading: Icon(item.icon, color: active ? AppColors.ink : AppColors.body),
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: active ? FontWeight.w800 : FontWeight.w500,
                        color: active ? AppColors.ink : AppColors.body,
                      ),
                    ),
                    selected: active,
                    selectedTileColor: AppColors.soft,
                    onTap: () {
                      Navigator.of(context).pop();
                      onSelect(index);
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Keluar'),
              onTap: () {
                Navigator.of(context).pop();
                onLogout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
