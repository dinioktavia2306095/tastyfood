import 'package:flutter/foundation.dart';

String get apiBaseUrl {
  if (kIsWeb) {
    return 'http://127.0.0.1:8000/api';
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8000/api';
  }

  return 'http://127.0.0.1:8000/api';
}

String get assetBaseUrl {
  if (kIsWeb) {
    return 'http://127.0.0.1:8000';
  }

  if (defaultTargetPlatform == TargetPlatform.android) {
    return 'http://10.0.2.2:8000';
  }

  return 'http://127.0.0.1:8000';
}

String assetUrl(String path) {
  if (path.trim().isEmpty) {
    return '';
  }
  return path.startsWith('http')
      ? path
      : '$assetBaseUrl/api/site-image/${path.replaceFirst(RegExp(r'^/+'), '')}';
}

class AppImages {
  AppImages._();

  static const banner = 'images/Group 70.png';
  static const heroPlate = 'images/img-4.png';
  static const chef =
      'images/sebastian-coman-photography-eBmyH7oO5wY-unsplash.jpg';
  static const soup = 'images/fathul-abrar-T-qI_MI2EMA-unsplash.jpg';
  static const ramen = 'images/jonathan-borba-Gkc_xM3VY34-unsplash.jpg';
  static const veggies = 'images/sanket-shah-SVA7TyHxojY-unsplash.jpg';

  static const List<String> highlights = [
  'images/img-1.png',
  'images/img-2.png',
  'images/img-3.png',
  'images/img-4.png',
  ];

  static const List<String> homeNewsImages = [
    'images/fathul-abrar-T-qI_MI2EMA-unsplash.jpg',
    'images/sanket-shah-SVA7TyHxojY-unsplash.jpg',
    'images/sebastian-coman-photography-eBmyH7oO5wY-unsplash.jpg',
    'images/jimmy-dean-Jvw3pxgeiZw-unsplash.jpg',
    'images/luisa-brimble-HvXEbkcXjSk-unsplash.jpg',
  ];

  static const List<String> homeGalleryImages = [
    'images/brooke-lark-oaz0raysASk-unsplash.jpg',
    'images/ella-olsson-mmnKI8kMxpc-unsplash.jpg',
    'images/eiliv-aceron-ZuIDLSz3XLg-unsplash.jpg',
    'images/jonathan-borba-Gkc_xM3VY34-unsplash.jpg',
    'images/mariana-medvedeva-iNwCO9ycBlc-unsplash.jpg',
    'images/monika-grabkowska-P1aohbiT-EY-unsplash.jpg',
  ];
}
