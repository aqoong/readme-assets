class PackageInfo {
  const PackageInfo({
    required this.slug,
    required this.name,
    required this.platform,
    required this.summary,
    required this.description,
    required this.problem,
    required this.features,
    required this.installCode,
    required this.usageCode,
    required this.githubUrl,
    required this.tags,
    required this.lastUpdated,
    this.pubDevUrl,
    this.documentationUrl,
    this.version,
    this.relatedPackageSlugs = const [],
    this.relatedArticleSlugs = const [],
    this.parameters = const [],
  });

  final String slug;
  final String name;
  final String platform;
  final String summary;
  final String description;
  final String problem;
  final List<String> features;
  final String installCode;
  final String usageCode;
  final String? pubDevUrl;
  final String githubUrl;
  final String? documentationUrl;
  final List<String> tags;
  final String lastUpdated;
  final String? version;
  final List<String> relatedPackageSlugs;
  final List<String> relatedArticleSlugs;
  final List<ParameterInfo> parameters;

  String get category => platform;
  String get tagline => summary;
  String get linkLabel => pubDevUrl == null ? 'View on GitHub' : 'View package';
  String get url => pubDevUrl ?? githubUrl;
  List<String> get highlights => tags.take(3).toList();
}

class DetailSection {
  const DetailSection({
    required this.title,
    this.body,
    this.code,
    this.items = const [],
    this.parameters = const [],
  });

  final String title;
  final String? body;
  final String? code;
  final List<String> items;
  final List<ParameterInfo> parameters;
}

class PackageDetail {
  const PackageDetail({required this.packageName, required this.sections});

  final String packageName;
  final List<DetailSection> sections;
}

class ParameterInfo {
  const ParameterInfo({
    required this.name,
    required this.type,
    required this.description,
    this.required = false,
  });

  final String name;
  final String type;
  final String description;
  final bool required;
}

const packages = <PackageInfo>[
  PackageInfo(
    slug: 'flutter-soft-keyboard',
    name: 'flutter_soft_keyboard',
    platform: 'Flutter',
    summary: 'Custom virtual keyboard widget',
    description:
        'A customizable virtual keyboard widget built from a two-dimensional key layout. It is useful for PIN pads, POS input, numeric forms, and screens where the system keyboard is not the best interaction model.',
    problem:
        'System keyboards are hard to constrain for kiosk, PIN, payment, and in-app keypad flows. This package keeps layout, key labels, and input events inside the Flutter widget tree.',
    features: [
      'Define keyboard rows with List<List<VirtualKey>>',
      'Listen to the last key and accumulated text through a controller',
      'Control keyboard width, height, row spacing, and column spacing',
      'Use custom keys for numeric, PIN, command, or alphanumeric layouts',
      'Dispose the controller explicitly with the surrounding form state',
    ],
    installCode: '''
dependencies:
  flutter_soft_keyboard: ^latest''',
    usageCode: '''
final keyboardController = KeyboardInputController();

keyboardController.setKeyListener((lastKey, enteredText) {
  debugPrint('Last key: \$lastKey');
  debugPrint('Full text: \$enteredText');
});

final keyLayout = [
  [VirtualKey(text: '1'), VirtualKey(text: '2'), VirtualKey(text: '3')],
  [VirtualKey(text: '4'), VirtualKey(text: '5'), VirtualKey(text: '6')],
  [VirtualKey(text: '7'), VirtualKey(text: '8'), VirtualKey(text: '9')],
];

SoftKeyboardWidget(
  width: 360,
  height: 280,
  columnSpacing: 4,
  rowSpacing: 4,
  keyLayout: keyLayout,
  keyboardInputController: keyboardController,
)''',
    pubDevUrl: 'https://pub.dev/packages/flutter_soft_keyboard',
    githubUrl: 'https://github.com/aqoong/flutter_soft_keyboard',
    tags: ['Virtual keyboard', 'PIN pad', 'Custom input'],
    lastUpdated: '2026-06-17',
    relatedPackageSlugs: ['ripple-container'],
    relatedArticleSlugs: ['flutter-custom-keyboard'],
    parameters: [
      ParameterInfo(
        name: 'keyLayout',
        type: 'List<List<VirtualKey>>',
        description:
            'Two-dimensional key structure rendered by row and column.',
        required: true,
      ),
      ParameterInfo(
        name: 'keyboardInputController',
        type: 'KeyboardInputController',
        description: 'Controller used to observe input and dispose resources.',
        required: true,
      ),
      ParameterInfo(
        name: 'width / height',
        type: 'double',
        description: 'Explicit keyboard dimensions for predictable keypad UI.',
      ),
    ],
  ),
  PackageInfo(
    slug: 'ripple-container',
    name: 'ripple_container',
    platform: 'Flutter',
    summary: 'Material ripple behavior for custom containers',
    description:
        'A styleable container that exposes Material ink feedback while keeping common BoxDecoration-like controls close to the tap target.',
    problem:
        'GestureDetector handles taps but gives no visual feedback. InkWell gives feedback but needs the right Material ancestry and clipping. ripple_container packages that pattern for reusable custom cards and buttons.',
    features: [
      'Material ripple and splash feedback for custom surfaces',
      'Configurable background color, border, border radius, margin, and shadow',
      'onTap and onLongPress callbacks',
      'Custom splash color for branded interactions',
    ],
    installCode: '''
dependencies:
  ripple_container: ^latest''',
    usageCode: '''
RippleContainer(
  width: 200,
  height: 100,
  backgroundColor: Colors.blueAccent,
  borderRadius: BorderRadius.circular(16),
  splashColor: Colors.amber,
  onTap: () => debugPrint('tapped'),
  child: const Center(child: Text('Tap me')),
)''',
    pubDevUrl: 'https://pub.dev/packages/ripple_container',
    githubUrl: 'https://github.com/aqoong/ripple_container',
    tags: ['Interaction', 'Material feedback', 'Custom UI'],
    lastUpdated: '2026-06-17',
    relatedPackageSlugs: ['flutter-soft-keyboard'],
    relatedArticleSlugs: ['flutter-ripple-effect'],
  ),
  PackageInfo(
    slug: 'size-tailored-text',
    name: 'size_tailored_text',
    platform: 'Flutter',
    summary: 'Responsive text sizing for Flutter widgets',
    description:
        'Automatically scales text to fit the size of its parent widget so variable labels, cards, dashboards, and badges stay readable.',
    problem:
        'Long text inside fixed UI often overflows or gets clipped. A controlled auto-size strategy helps preserve layout while keeping a minimum readable font size.',
    features: [
      'Auto-scales font size to fit parent constraints',
      'Accepts standard TextStyle',
      'Works for dashboards, cards, labels, and responsive components',
      'Keeps layout code smaller than repeated LayoutBuilder calculations',
    ],
    installCode: '''
dependencies:
  size_tailored_text: ^latest''',
    usageCode: '''
SizedBox(
  width: 200,
  height: 60,
  child: SizeTailoredTextWidget(
    'A long product or dashboard label',
    maxLines: 1,
    minFontSize: 11,
    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  ),
)''',
    pubDevUrl: 'https://pub.dev/packages/size_tailored_text',
    githubUrl: 'https://github.com/aqoong/size_tailored_text',
    tags: ['Flutter UI', 'Responsive text', 'Layout utility'],
    lastUpdated: '2026-06-17',
    relatedArticleSlugs: ['flutter-auto-resize-text'],
  ),
  PackageInfo(
    slug: 'project-color-palette',
    name: 'project_color_palette',
    platform: 'Flutter',
    summary: 'CSV-based color tokens for Flutter',
    description:
        'A bridge between designers and Flutter developers. It converts project color definitions from CSV into typed Flutter color values.',
    problem:
        'Teams often copy hex values manually from design files. A simple palette file lowers the chance of drift between design tokens and app code.',
    features: [
      'Read project color definitions from CSV',
      'Keep a shared color vocabulary in source control',
      'Use generated or loaded colors in Flutter themes and widgets',
    ],
    installCode: '''
dependencies:
  project_color_palette: ^latest''',
    usageCode: '''
# colors.csv
primary,#1A73E8
secondary,#F5F5F5

final palette = await ProjectColorPalette.fromCsv('assets/colors.csv');
Container(color: palette['primary']);''',
    pubDevUrl: 'https://pub.dev/packages/project_color_palette',
    githubUrl: 'https://github.com/aqoong/project_color_palette',
    tags: ['Design tokens', 'CSV palette', 'Theme workflow'],
    lastUpdated: '2026-06-17',
  ),
  PackageInfo(
    slug: 'aqlinter',
    name: 'aqlinter',
    platform: 'Flutter',
    summary: 'Lint rules for cleaner Flutter and Dart code',
    description:
        'A curated lint baseline for Flutter projects that want consistent static analysis and team conventions.',
    problem:
        'Every project should not rediscover analysis_options.yaml from scratch. A shared lint package makes consistency repeatable.',
    features: [
      'One-line include from analysis_options.yaml',
      'Opinionated but overridable Dart and Flutter rules',
      'Useful for personal packages and team projects',
    ],
    installCode: '''
dev_dependencies:
  aqlinter: ^latest''',
    usageCode: '''
include: package:aqlinter/analysis_options.yaml

linter:
  rules:
    prefer_single_quotes: true''',
    pubDevUrl: 'https://pub.dev/packages/aqlinter',
    githubUrl: 'https://github.com/aqoong/aqlinter',
    tags: ['Dart lint', 'Code quality', 'Team conventions'],
    lastUpdated: '2026-06-17',
  ),
  PackageInfo(
    slug: 'expandable-text-view',
    name: 'ExpandableTextView',
    platform: 'Android',
    summary: 'Expandable long text component',
    description:
        'A native Android TextView pattern for showing long content in a collapsed state with a clear expand and collapse interaction.',
    problem:
        'Feeds, product descriptions, and comments need compact previews without losing access to the full text.',
    features: [
      'Collapsed and expanded text states',
      'Useful in list rows and detail screens',
      'Clear more/less interaction for long content',
    ],
    installCode: '''
// See the GitHub repository for the Android integration instructions.''',
    usageCode: '''
// XML and Kotlin usage depend on the repository version.
// Confirm the latest API in GitHub before copying into production.''',
    githubUrl: 'https://github.com/aqoong/ExpandableTextView',
    tags: ['Native Android', 'TextView', 'Collapse UI'],
    lastUpdated: '2026-06-17',
    relatedArticleSlugs: ['android-expandable-text-view'],
  ),
  PackageInfo(
    slug: 'hashtag-edit-text-view',
    name: 'HashTagEditTextView',
    platform: 'Android',
    summary: 'Hashtag-aware edit text',
    description:
        'An Android EditText-oriented library for hashtag entry flows where typed tokens need visual treatment and callback support.',
    problem:
        'Social and content apps often need hashtag-aware text input without rebuilding token parsing on every screen.',
    features: [
      'Hashtag token highlighting',
      'EditText-based input behavior',
      'Useful for social posting and content metadata forms',
    ],
    installCode: '''
// See the GitHub repository for the Android integration instructions.''',
    usageCode: '''
// Confirm constructor and XML attributes in GitHub before production use.''',
    githubUrl: 'https://github.com/aqoong/HashTagEditTextView',
    tags: ['Native Android', 'EditText', 'Hashtags'],
    lastUpdated: '2026-06-17',
  ),
  PackageInfo(
    slug: 'dynamic-indicator',
    name: 'DynamicIndicator',
    platform: 'Android',
    summary: 'Flexible page and step indicator',
    description:
        'A native Android indicator component for paging or step-based interfaces where the number of items can change.',
    problem:
        'Carousels and onboarding flows need indicators that communicate position without hand-coded drawing logic on each screen.',
    features: [
      'Dynamic item counts',
      'Current position display',
      'Useful for onboarding, pagers, and galleries',
    ],
    installCode: '''
// See the GitHub repository for the Android integration instructions.''',
    usageCode: '''
// Confirm the current API in GitHub before copying into production.''',
    githubUrl: 'https://github.com/aqoong/DynamicIndicator',
    tags: ['Native Android', 'Indicator', 'Paging UI'],
    lastUpdated: '2026-06-17',
  ),
];

List<PackageInfo> packagesByCategory(String category) {
  return packages.where((info) => info.category == category).toList();
}

PackageInfo? packageBySlug(String slug) {
  for (final package in packages) {
    if (package.slug == slug) {
      return package;
    }
  }
  return null;
}

PackageInfo? packageByName(String name) {
  for (final package in packages) {
    if (package.name == name) {
      return package;
    }
  }
  return null;
}

List<PackageInfo> relatedPackagesFor(PackageInfo package) {
  return package.relatedPackageSlugs
      .map(packageBySlug)
      .whereType<PackageInfo>()
      .toList();
}

List<PackageDetail> get packageDetails {
  return [
    for (final package in packages.where((item) => item.platform == 'Flutter'))
      PackageDetail(
        packageName: package.name,
        sections: [
          DetailSection(title: 'Solves', body: package.problem),
          DetailSection(title: 'Installation', code: package.installCode),
          DetailSection(title: 'Basic usage', code: package.usageCode),
          DetailSection(title: 'Key features', items: package.features),
          if (package.parameters.isNotEmpty)
            DetailSection(
              title: 'Constructor parameters',
              parameters: package.parameters,
            ),
        ],
      ),
  ];
}
