import 'package:flutter/material.dart';

import '../app_config.dart';

class NetImage extends StatelessWidget {
  const NetImage(
    this.url, {
    super.key,
    this.height,
    this.width,
    this.radius = 0,
    this.fit = BoxFit.cover,
  });

  final String url;
  final double? height;
  final double? width;
  final double radius;
  final BoxFit fit;

  Widget _placeholder() {
    return Container(
      height: height ?? 180,
      width: width ?? double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xfff4f4f4),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: Color(0xffaaaaaa),
          size: 28,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resolvedUrl = url.trim();
    if (resolvedUrl.isEmpty) {
      return _placeholder();
    }

    final parsedUrl = Uri.tryParse(resolvedUrl);
    final isLocalhost = parsedUrl != null &&
        (parsedUrl.host == '127.0.0.1' ||
            parsedUrl.host == 'localhost' ||
            parsedUrl.host == '0.0.0.0');
    final imageUrl = !resolvedUrl.startsWith('http')
        ? '$assetBaseUrl/${resolvedUrl.replaceFirst(RegExp(r'^/+'), '')}'
        : isLocalhost
            ? Uri.parse(assetBaseUrl).replace(
                path: parsedUrl.path,
                query: parsedUrl.query,
              ).toString()
            : resolvedUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        imageUrl,
        height: height,
        width: width,
        fit: fit,
        headers: const {'Accept': 'image/*'},
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: height ?? 180,
            width: width ?? double.infinity,
            color: const Color(0xfff4f4f4),
            child: const Center(
              child: SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _placeholder(),
      ),
    );
  }
}
