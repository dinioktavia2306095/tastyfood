import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'net_image.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({
    super.key,
    required this.title,
    required this.excerpt,
    required this.imageUrl,
    this.onTap,
  });

  final String title;
  final String excerpt;
  final String imageUrl;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            NetImage(imageUrl, height: 160),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.cardTitle.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    excerpt,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppText.paragraph.copyWith(
                      fontSize: 11,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Baca selengkapnya', style: AppText.link),
                      Icon(Icons.more_horiz, size: 17, color: AppColors.muted),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
