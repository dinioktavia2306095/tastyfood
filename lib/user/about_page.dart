import 'package:flutter/material.dart';

import '../app_config.dart';
import '../app_theme.dart';
import '../widgets/net_image.dart';
import '../widgets/page_hero.dart';
import '../widgets/site_footer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const PageHero(title: 'TENTANG KAMI'),
        _section(
          background: AppColors.soft,
          title: 'TASTY FOOD',
          lead:
              'Tasty Food adalah restoran kuliner yang berkomitmen untuk '
              'menyajikan hidangan berkualitas tinggi dengan keharmonisan rasa '
              'istimewa. Kami menggabungkan bahan-bahan segar pilihan dan '
              'teknik memasak modern untuk menciptakan pengalaman bersantap '
              'yang tak terlupakan.',
          body:
              'Berawal dari kecintaan kami terhadap cita rasa kuliner yang '
              'otentik dan sehat, Tasty Food terus berinovasi dalam '
              'menghadirkan beragam variasi menu harian. Kami percaya bahwa '
              'setiap hidangan bukan hanya sekadar makanan, melainkan bentuk '
              'pelayanan terbaik kami dalam menghadirkan kebahagiaan dan '
              'kenyamanan bagi setiap pelanggan.',
          images: const [AppImages.heroPlate, AppImages.chef],
        ),
        _section(
          background: Colors.white,
          title: 'VISI',
          body:
              'Menjadi jaringan restoran dan pusat kuliner terdepan yang tidak '
              'hanya menyajikan hidangan lezat dan berkualitas tinggi, tetapi '
              'juga menjadi pelopor dalam menginspirasi gaya hidup sehat '
              'masyarakat melalui pemilihan bahan-bahan segar, alami, dan '
              'bergizi seimbang di setiap sajian.',
          images: const [AppImages.soup, AppImages.ramen],
          imagesFirst: true,
        ),
        _section(
          background: Colors.white,
          title: 'MISI',
          body:
              'Kami berkomitmen untuk selalu menyajikan hidangan lezat dan '
              'higienis dengan mengutamakan penggunaan bahan baku segar '
              'terbaik yang diperoleh langsung dari produsen lokal terpercaya. '
              'Demi menjaga kepuasan setiap pelanggan, kami secara konsisten '
              'menghadirkan inovasi pada variasi menu kuliner Nusantara maupun '
              'internasional yang kaya akan nutrisi seimbang. Selain itu, kami '
              'berupaya menciptakan suasana bersantap yang hangat dan nyaman '
              'melalui standar pelayanan yang ramah, cepat, serta profesional, '
              'sekaligus menginspirasi masyarakat untuk terus menerapkan gaya '
              'hidup sehat tanpa harus mengorbankan kenikmatan rasa.',
          images: const [AppImages.veggies],
        ),
        const SiteFooter(),
      ],
    );
  }

  Widget _section({
    required Color background,
    required String title,
    required String body,
    required List<String> images,
    String? lead,
    bool imagesFirst = false,
  }) {
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppText.section.copyWith(fontSize: 19)),
        const SizedBox(height: 16),
        if (lead != null) ...[
          Text(
            lead,
            style: AppText.paragraph.copyWith(
              color: AppColors.ink,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
        ],
        Text(body, style: AppText.paragraph),
      ],
    );

    final photos = SizedBox(
      height: 190,
      child: Row(
        children: [
          for (var i = 0; i < images.length; i++) ...[
            Expanded(
              child: NetImage(assetUrl(images[i]), radius: 10),
            ),
            if (i != images.length - 1) const SizedBox(width: 12),
          ],
        ],
      ),
    );

    return Container(
      width: double.infinity,
      color: background,
      padding: const EdgeInsets.fromLTRB(24, 40, 24, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: imagesFirst
            ? [photos, const SizedBox(height: 26), text]
            : [text, const SizedBox(height: 26), photos],
      ),
    );
  }
}