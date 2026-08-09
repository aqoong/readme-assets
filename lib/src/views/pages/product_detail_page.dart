import 'package:flutter/material.dart';

import '../../data/product_catalog.dart';
import '../../routes/site_route.dart';
import '../../widgets/common_widgets.dart';
import '../../widgets/page_scaffold.dart';
import '../sections/famitree_product_section.dart';
import '../sections/footer_section.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.slug});

  final String slug;

  @override
  Widget build(BuildContext context) {
    final product = productBySlug(slug);
    if (product == null) {
      return const PageScaffold(
        currentRoute: SiteRoute.notFound,
        children: [_MissingProductSection(), FooterSection()],
      );
    }

    return PageScaffold(
      currentRoute: SiteRoute.productDetail(product.slug),
      children: [
        switch (product.slug) {
          'famitree' => FamitreeProductSection(product: product),
          _ => _GenericProductSection(product: product),
        },
        const FooterSection(),
      ],
    );
  }
}

class _GenericProductSection extends StatelessWidget {
  const _GenericProductSection({required this.product});

  final ProductInfo product;

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      child: ConstrainedSection(
        id: 'product-${product.slug}',
        title: product.name,
        subtitle: product.description,
        child: const SizedBox.shrink(),
      ),
    );
  }
}

class _MissingProductSection extends StatelessWidget {
  const _MissingProductSection();

  @override
  Widget build(BuildContext context) {
    return const SectionBand(
      child: ConstrainedSection(
        id: 'missing-product',
        title: 'Product not found',
        subtitle: 'The requested product is not in the current catalog.',
        child: SizedBox.shrink(),
      ),
    );
  }
}
