import 'package:flutter/material.dart';

import '../../data/product_catalog.dart';
import '../../routes/navigation.dart';
import '../../routes/site_route.dart';
import '../../utils/open_url.dart';
import '../../widgets/common_widgets.dart';

class FamitreeProductSection extends StatelessWidget {
  const FamitreeProductSection({super.key, required this.product});

  final ProductInfo product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _FamitreeHero(product: product),
        const _ProblemSection(),
        const _HowItWorksSection(),
        const _FeatureSection(),
        const _DeveloperStorySection(),
        _StatusSection(product: product),
      ],
    );
  }
}

class _FamitreeHero extends StatelessWidget {
  const _FamitreeHero({required this.product});

  final ProductInfo product;

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      backgroundColor: const Color(0xFF0B2E22),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isWide ? 48 : 24,
              vertical: isWide ? 72 : 48,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1160),
              child: isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: _HeroCopy(product: product)),
                        const SizedBox(width: 44),
                        const Expanded(child: _FamilyTreePreview()),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _HeroCopy(product: product),
                        const SizedBox(height: 36),
                        const _FamilyTreePreview(),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({required this.product});

  final ProductInfo product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            const _HeroBadge(label: 'Featured product'),
            _HeroBadge(label: product.statusLabel),
          ],
        ),
        const SizedBox(height: 26),
        Text(
          product.name,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          product.tagline,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: const Color(0xFF86EFAC),
            fontWeight: FontWeight.w800,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          product.description,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: const Color(0xFFD1FAE5),
            height: 1.65,
          ),
        ),
        const SizedBox(height: 22),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final platform in product.platforms)
              _PlatformChip(label: platform),
          ],
        ),
        const SizedBox(height: 28),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            FilledButton.icon(
              onPressed: () => openMailTo('cooldnjsdn@gmail.com'),
              icon: const Icon(Icons.mail_outline_rounded),
              label: const Text('개발 소식 문의'),
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF14532D),
              ),
            ),
            OutlinedButton.icon(
              onPressed: () => goToRoute(context, SiteRoute.products),
              icon: const Icon(Icons.arrow_back_rounded),
              label: const Text('Products로 돌아가기'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF6EE7B7)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HeroBadge extends StatelessWidget {
  const _HeroBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _PlatformChip extends StatelessWidget {
  const _PlatformChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF14532D),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFF22C55E)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFFDCFCE7),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _FamilyTreePreview extends StatelessWidget {
  const _FamilyTreePreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.16)),
      ),
      child: const AspectRatio(
        aspectRatio: 1.38,
        child: FittedBox(
          fit: BoxFit.contain,
          child: SizedBox(
            width: 520,
            height: 376,
            child: Stack(
              children: [
                Positioned.fill(
                  child: CustomPaint(painter: _TreeLinePainter()),
                ),
                Positioned(
                  left: 196,
                  top: 18,
                  child: _FamilyNode(
                    icon: Icons.elderly_rounded,
                    role: '조부모',
                    detail: '가족의 시작점',
                  ),
                ),
                Positioned(
                  left: 94,
                  top: 132,
                  child: _FamilyNode(
                    icon: Icons.man_rounded,
                    role: '아버지',
                    detail: '부모',
                  ),
                ),
                Positioned(
                  left: 298,
                  top: 132,
                  child: _FamilyNode(
                    icon: Icons.woman_rounded,
                    role: '고모',
                    detail: '아버지의 자매',
                  ),
                ),
                Positioned(
                  left: 94,
                  top: 246,
                  child: _FamilyNode(
                    icon: Icons.person_rounded,
                    role: '나',
                    detail: '관계의 기준',
                    highlighted: true,
                  ),
                ),
                Positioned(
                  left: 298,
                  top: 246,
                  child: _FamilyNode(
                    icon: Icons.person_outline_rounded,
                    role: '사촌',
                    detail: '고모의 자녀',
                  ),
                ),
                Positioned(left: 168, top: 330, child: _RelationResult()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FamilyNode extends StatelessWidget {
  const _FamilyNode({
    required this.icon,
    required this.role,
    required this.detail,
    this.highlighted = false,
  });

  final IconData icon;
  final String role;
  final String detail;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 128,
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFDCFCE7) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlighted
              ? const Color(0xFF22C55E)
              : const Color(0xFFD1FAE5),
          width: highlighted ? 2 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF15803D), size: 25),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  role,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF14532D),
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  detail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RelationResult extends StatelessWidget {
  const _RelationResult();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 184,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xFF16A34A),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 10)],
      ),
      child: const Text(
        '나 ↔ 사촌 · 4촌',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
      ),
    );
  }
}

class _TreeLinePainter extends CustomPainter {
  const _TreeLinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF6EE7B7)
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(260, 88)
      ..lineTo(260, 108)
      ..moveTo(158, 108)
      ..lineTo(362, 108)
      ..moveTo(158, 108)
      ..lineTo(158, 132)
      ..moveTo(362, 108)
      ..lineTo(362, 132)
      ..moveTo(158, 202)
      ..lineTo(158, 246)
      ..moveTo(362, 202)
      ..lineTo(362, 246);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ProblemSection extends StatelessWidget {
  const _ProblemSection();

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      backgroundColor: const Color(0xFFFFFBEB),
      child: ConstrainedSection(
        id: 'famitree-problem',
        title: '가깝지만 자주 헷갈리는 가족 호칭',
        subtitle: '가족 관계는 알고 있어도 상대방을 정확히 어떻게 부르고 몇 촌인지 바로 떠올리기는 어렵습니다.',
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;
            final question = const _QuestionCard();
            final answer = const _ProblemCopy();
            return isWide
                ? IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(child: question),
                        const SizedBox(width: 18),
                        Expanded(child: answer),
                      ],
                    ),
                  )
                : Column(
                    children: [question, const SizedBox(height: 18), answer],
                  );
          },
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: Color(0xFFD97706),
              size: 34,
            ),
            const SizedBox(height: 18),
            Text(
              '“아버지의 사촌 누나는\n뭐라고 부르지?”',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: const Color(0xFF78350F),
                fontWeight: FontWeight.w900,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProblemCopy extends StatelessWidget {
  const _ProblemCopy();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '관계를 입력하면 계산은 Famitree가',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            const Text(
              '복잡한 관계 이름을 검색어로 바꾸거나 가족에게 다시 물어볼 필요 없이, 눈에 보이는 카드로 관계를 연결하고 결과를 확인합니다.',
              style: TextStyle(color: Color(0xFF475569), height: 1.7),
            ),
          ],
        ),
      ),
    );
  }
}

class _HowItWorksSection extends StatelessWidget {
  const _HowItWorksSection();

  @override
  Widget build(BuildContext context) {
    return const SectionBand(
      child: ConstrainedSection(
        id: 'famitree-how-it-works',
        title: '세 단계로 만드는 가족 관계',
        subtitle: '복잡한 양식 대신 가족 카드에서 바로 관계를 확장합니다.',
        child: _InfoGrid(
          items: [
            _InfoItem(
              eyebrow: '01',
              icon: Icons.person_pin_circle_outlined,
              title: '‘나’에서 시작',
              body: '첫 화면의 ‘나’ 카드를 기준으로 가족 관계 트리를 시작합니다.',
            ),
            _InfoItem(
              eyebrow: '02',
              icon: Icons.add_link_rounded,
              title: '관계 추가',
              body: '카드를 길게 눌러 부모, 배우자, 형제자매 또는 자녀를 연결합니다.',
            ),
            _InfoItem(
              eyebrow: '03',
              icon: Icons.auto_awesome_outlined,
              title: '호칭 확인',
              body: '선택한 가족과 나 사이의 촌수와 한국식 호칭을 확인합니다.',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection();

  @override
  Widget build(BuildContext context) {
    return const SectionBand(
      backgroundColor: Color(0xFFF0FDF4),
      child: ConstrainedSection(
        id: 'famitree-features',
        title: '핵심 기능',
        subtitle: '가족 관계를 이해하고 공유하는 데 필요한 기능에 집중합니다.',
        child: _InfoGrid(
          items: [
            _InfoItem(
              icon: Icons.account_tree_outlined,
              title: '카드 기반 관계 트리',
              body: '팬과 줌이 가능한 캔버스에서 여러 세대의 가족 관계를 한눈에 살펴봅니다.',
            ),
            _InfoItem(
              icon: Icons.hub_outlined,
              title: '호칭과 촌수 계산',
              body: '나를 기준으로 직계·방계 가족의 기본 호칭과 촌수를 계산합니다.',
            ),
            _InfoItem(
              icon: Icons.image_outlined,
              title: '결과 저장과 공유',
              body: '계산된 결과를 복사하고 완성한 가족 관계 트리를 PNG 이미지로 저장합니다.',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid({required this.items});

  final List<_InfoItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 850) {
          return Column(
            children: [
              for (var index = 0; index < items.length; index++) ...[
                items[index],
                if (index != items.length - 1) const SizedBox(height: 16),
              ],
            ],
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 255,
          ),
          itemBuilder: (context, index) => items[index],
        );
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.title,
    required this.body,
    this.eyebrow,
  });

  final String? eyebrow;
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: const Color(0xFF15803D)),
                ),
                if (eyebrow != null) ...[
                  const Spacer(),
                  Text(
                    eyebrow!,
                    style: const TextStyle(
                      color: Color(0xFF86EFAC),
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 18),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                body,
                style: const TextStyle(color: Color(0xFF475569), height: 1.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeveloperStorySection extends StatelessWidget {
  const _DeveloperStorySection();

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      backgroundColor: const Color(0xFFF8FAFC),
      child: ConstrainedSection(
        id: 'famitree-built-with',
        title: 'Built as a practical Flutter product',
        subtitle: '사용자 경험과 함께 여러 플랫폼의 데이터 흐름, 관계 규칙, 오프라인 편집 경계를 설계하고 있습니다.',
        child: Card(
          color: const Color(0xFF111827),
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 760;
                final copy = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '하나의 관계 트리, 여러 실행 환경',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Flutter 기반의 공통 화면 위에 로컬 편집 경험과 서버 호칭 규칙 조회를 결합해 Android, iOS, Web을 함께 준비하고 있습니다.',
                      style: TextStyle(color: Color(0xFFCBD5E1), height: 1.7),
                    ),
                  ],
                );
                const tech = Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _TechChip(label: 'Flutter'),
                    _TechChip(label: 'Riverpod'),
                    _TechChip(label: 'Firebase'),
                    _TechChip(label: 'Cloud Functions'),
                    _TechChip(label: 'ObjectBox'),
                  ],
                );

                return isWide
                    ? Row(
                        children: [
                          Expanded(flex: 6, child: copy),
                          const SizedBox(width: 36),
                          const Expanded(flex: 4, child: tech),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [copy, const SizedBox(height: 24), tech],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TechChip extends StatelessWidget {
  const _TechChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF86EFAC),
            fontFamily: 'monospace',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _StatusSection extends StatelessWidget {
  const _StatusSection({required this.product});

  final ProductInfo product;

  @override
  Widget build(BuildContext context) {
    return SectionBand(
      child: ConstrainedSection(
        id: 'famitree-status',
        title: '현재 개발 중입니다',
        subtitle: 'Famitree는 핵심 가족 트리 편집과 호칭 계산 경험을 다듬고 있는 MVP 단계입니다.',
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(26),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 720;
                final status = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _StatusLine(
                      icon: Icons.construction_rounded,
                      title: 'Product status',
                      value: 'In development',
                    ),
                    const SizedBox(height: 18),
                    _StatusLine(
                      icon: Icons.devices_rounded,
                      title: 'Target platforms',
                      value: product.platforms.join(' · '),
                    ),
                    const SizedBox(height: 18),
                    _StatusLine(
                      icon: Icons.update_rounded,
                      title: 'Last updated',
                      value: product.lastUpdated,
                    ),
                  ],
                );
                final callToAction = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Famitree에 관심이 있으신가요?',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '출시 소식, 테스트 참여 또는 제품에 대한 의견을 이메일로 남겨주세요.',
                      style: TextStyle(color: Color(0xFF475569), height: 1.65),
                    ),
                    const SizedBox(height: 18),
                    FilledButton.icon(
                      onPressed: () => openMailTo('cooldnjsdn@gmail.com'),
                      icon: const Icon(Icons.mail_outline_rounded),
                      label: const Text('이메일로 문의하기'),
                    ),
                  ],
                );

                return isWide
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: status),
                          const SizedBox(width: 48),
                          Expanded(child: callToAction),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          status,
                          const Divider(height: 52),
                          callToAction,
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusLine extends StatelessWidget {
  const _StatusLine({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFDCFCE7),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF15803D), size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ),
      ],
    );
  }
}
