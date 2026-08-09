enum ProductStatus { inDevelopment, beta, released }

class ProductInfo {
  const ProductInfo({
    required this.slug,
    required this.name,
    required this.tagline,
    required this.description,
    required this.status,
    required this.platforms,
    required this.highlights,
    required this.lastUpdated,
    this.serviceUrl,
    this.featured = false,
  });

  final String slug;
  final String name;
  final String tagline;
  final String description;
  final ProductStatus status;
  final List<String> platforms;
  final List<String> highlights;
  final String lastUpdated;
  final String? serviceUrl;
  final bool featured;

  String get statusLabel => switch (status) {
    ProductStatus.inDevelopment => 'In development',
    ProductStatus.beta => 'Beta',
    ProductStatus.released => 'Released',
  };
}

const products = <ProductInfo>[
  ProductInfo(
    slug: 'famitree',
    name: 'Famitree',
    tagline: '가족을 연결하면, 호칭이 보입니다.',
    description: '카드로 가족 관계를 확장하고 나를 기준으로 촌수와 한국식 호칭을 확인하는 가족 관계 트리입니다.',
    status: ProductStatus.inDevelopment,
    platforms: ['Web'],
    highlights: ['가족 관계 트리', '한국식 호칭', '촌수 계산'],
    lastUpdated: '2026-08-10',
    serviceUrl: 'https://famitree.aqoong.pe.kr/',
    featured: true,
  ),
];

ProductInfo? productBySlug(String slug) {
  for (final product in products) {
    if (product.slug == slug) {
      return product;
    }
  }
  return null;
}
