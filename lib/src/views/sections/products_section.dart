import 'package:flutter/material.dart';
import 'package:size_tailored_text/size_tailored_text.dart';

import '../../data/product_catalog.dart';
import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../widgets/common_widgets.dart';

class ProductsSection extends StatelessWidget {
  const ProductsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final featured = products.firstWhere(
      (product) => product.featured,
      orElse: () => products.first,
    );
    final remaining = products
        .where((product) => product.slug != featured.slug)
        .toList();

    return SectionBand(
      backgroundColor: const Color(0xFFF8FAFC),
      child: ConstrainedSection(
        id: 'products',
        title: 'Products',
        subtitle: '사용자에게 실질적인 가치를 제공하기 위해 만들고 있는 앱과 서비스를 소개합니다.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured product',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 14),
            _FeaturedProductCard(product: featured),
            if (remaining.isNotEmpty) ...[
              const SizedBox(height: 34),
              Text(
                'More products',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 14),
              _ProductGrid(products: remaining),
            ],
          ],
        ),
      ),
    );
  }
}

class _FeaturedProductCard extends StatelessWidget {
  const _FeaturedProductCard({required this.product});

  final ProductInfo product;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 760;
          final visual = const _ProductVisual();
          final copy = _ProductCopy(product: product, featured: true);

          return isWide
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(flex: 4, child: _ProductVisual()),
                      Expanded(flex: 6, child: copy),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [visual, copy],
                );
        },
      ),
    );
  }
}

class _ProductVisual extends StatelessWidget {
  const _ProductVisual();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 250),
      color: const Color(0xFF0B2E22),
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: const Icon(
            Icons.account_tree_rounded,
            size: 74,
            color: Color(0xFF86EFAC),
          ),
        ),
      ),
    );
  }
}

class _ProductCopy extends StatelessWidget {
  const _ProductCopy({required this.product, this.featured = false});

  final ProductInfo product;
  final bool featured;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(featured ? 30 : 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _StatusBadge(label: product.statusLabel),
          const SizedBox(height: 16),
          SizedBox(
            height: 38,
            child: SizeTailoredTextWidget(
              product.name,
              maxLines: 1,
              minFontSize: 18,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.tagline,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF15803D),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: const TextStyle(color: Color(0xFF475569), height: 1.6),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final platform in product.platforms) Tag(label: platform),
            ],
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () =>
                goToRoute(context, SiteRoute.productDetail(product.slug)),
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text('${product.name} 알아보기'),
          ),
        ],
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  const _ProductGrid({required this.products});

  final List<ProductInfo> products;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900 ? 3 : 1;
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 360,
          ),
          itemBuilder: (context, index) {
            return Card(child: _ProductCopy(product: products[index]));
          },
        );
      },
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF166534),
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
