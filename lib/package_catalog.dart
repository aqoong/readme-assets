class PackageInfo {
  const PackageInfo({
    required this.name,
    required this.category,
    required this.tagline,
    required this.description,
    required this.highlights,
    required this.linkLabel,
    required this.url,
  });

  final String name;
  final String category;
  final String tagline;
  final String description;
  final List<String> highlights;
  final String linkLabel;
  final String url;
}

class PackageDetail {
  const PackageDetail({required this.packageName, required this.sections});

  final String packageName;
  final List<DetailSection> sections;
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
    name: 'flutter_soft_keyboard',
    category: 'Flutter',
    tagline: 'Custom virtual keyboard widget',
    description:
        'A fully customizable virtual keyboard widget built using a 2D array layout. Ideal for PIN pads, custom alphanumeric inputs, and apps requiring a non-system keyboard.',
    highlights: ['Virtual keyboard', 'PIN pad', 'Custom input'],
    linkLabel: 'View package',
    url: 'https://pub.dev/packages/flutter_soft_keyboard',
  ),
  PackageInfo(
    name: 'size_tailored_text',
    category: 'Flutter',
    tagline: 'Responsive text sizing for Flutter widgets',
    description:
        'Automatically scales text to fit the size of its parent widget. Removes responsive typography guesswork for dashboards, cards, and variable-length text.',
    highlights: ['Flutter UI', 'Responsive text', 'Layout utility'],
    linkLabel: 'View package',
    url: 'https://pub.dev/packages/size_tailored_text',
  ),
  PackageInfo(
    name: 'ripple_container',
    category: 'Flutter',
    tagline: 'Material ripple behavior for custom containers',
    description:
        'A versatile Box widget that wraps any child with a customizable ripple effect. Useful as a styleable touchable container alternative to bare GestureDetector.',
    highlights: ['Interaction', 'Material feedback', 'Custom UI'],
    linkLabel: 'View package',
    url: 'https://pub.dev/packages/ripple_container',
  ),
  PackageInfo(
    name: 'project_color_palette',
    category: 'Flutter',
    tagline: 'CSV-based color tokens for Flutter',
    description:
        'A bridge between designers and Flutter developers. Converts project color definitions from CSV into typed Flutter Color objects to keep design tokens in sync.',
    highlights: ['Design tokens', 'CSV palette', 'Theme workflow'],
    linkLabel: 'View package',
    url: 'https://pub.dev/packages/project_color_palette',
  ),
  PackageInfo(
    name: 'aqlinter',
    category: 'Flutter',
    tagline: 'Lint rules for cleaner Flutter and Dart code',
    description:
        'A curated set of lint rules for Flutter projects. Drop it into analysis_options.yaml for a consistent, opinionated code quality baseline.',
    highlights: ['Dart lint', 'Code quality', 'Team conventions'],
    linkLabel: 'View package',
    url: 'https://pub.dev/packages/aqlinter',
  ),
  PackageInfo(
    name: 'SlidePhotoViewer',
    category: 'Android',
    tagline: 'Gesture photo viewer for Android',
    description:
        'A custom view for displaying and sliding through a set of photos with smooth gesture support.',
    highlights: ['Native Android', 'Photo viewer', 'Gestures'],
    linkLabel: 'View on GitHub',
    url: 'https://github.com/aqoong/SlidePhotoViewer',
  ),
  PackageInfo(
    name: 'ExpandableTextView',
    category: 'Android',
    tagline: 'Expandable long text component',
    description:
        'A text view that can expand and collapse long content, great for article previews and descriptions.',
    highlights: ['Native Android', 'Text view', 'Collapse UI'],
    linkLabel: 'View on GitHub',
    url: 'https://github.com/aqoong/ExpandableTextView',
  ),
  PackageInfo(
    name: 'HashTagEditTextView',
    category: 'Android',
    tagline: 'Hashtag-aware edit text',
    description:
        'An edit text that auto-highlights hashtag tokens as the user types, with callback support.',
    highlights: ['Native Android', 'EditText', 'Hashtags'],
    linkLabel: 'View on GitHub',
    url: 'https://github.com/aqoong/HashTagEditTextView',
  ),
  PackageInfo(
    name: 'DynamicIndicator',
    category: 'Android',
    tagline: 'Flexible page and step indicator',
    description:
        'A flexible page or step indicator that dynamically adjusts to the number of items and current position.',
    highlights: ['Native Android', 'Indicator', 'Paging UI'],
    linkLabel: 'View on GitHub',
    url: 'https://github.com/aqoong/DynamicIndicator',
  ),
  PackageInfo(
    name: 'ObjectFlowView',
    category: 'Android',
    tagline: 'Flow layout for object collections',
    description:
        'A view that displays a collection of objects in a flowing, word-wrap style layout.',
    highlights: ['Native Android', 'Flow layout', 'Collection UI'],
    linkLabel: 'View on GitHub',
    url: 'https://github.com/aqoong/ObjectFlowView',
  ),
  PackageInfo(
    name: 'TextCheckBoxView',
    category: 'Android',
    tagline: 'Checkbox and styled text compound view',
    description:
        'A compound view combining a checkbox with a styled text label for forms and settings screens.',
    highlights: ['Native Android', 'Compound view', 'Forms'],
    linkLabel: 'View on GitHub',
    url: 'https://github.com/aqoong/TextCheckBoxView',
  ),
];

List<PackageInfo> packagesByCategory(String category) {
  return packages.where((info) => info.category == category).toList();
}

const packageDetails = <PackageDetail>[
  PackageDetail(
    packageName: 'flutter_soft_keyboard',
    sections: [
      DetailSection(
        title: 'Platform support',
        items: ['Android', 'iOS', 'Linux', 'macOS', 'Web', 'Windows'],
      ),
      DetailSection(
        title: 'Installation',
        code: '''
dependencies:
  flutter_soft_keyboard: ^latest''',
      ),
      DetailSection(
        title: 'Basic usage',
        code: '''
// 1. Create a controller
final keyboardController = KeyboardInputController();

// 2. Listen to key events
keyboardController.setKeyListener((lastKey, enteredText) {
  print('Last key: \$lastKey');
  print('Full text: \$enteredText');
});

// 3. Define a 2D key layout
final keyLayout = [
  [VirtualKey(text: '1'), VirtualKey(text: '2'), VirtualKey(text: '3')],
  [VirtualKey(text: '4'), VirtualKey(text: '5'), VirtualKey(text: '6')],
  [VirtualKey(text: '7'), VirtualKey(text: '8'), VirtualKey(text: '9')],
];

// 4. Use the widget
SoftKeyboardWidget(
  width: 400,
  height: 300,
  columnSpacing: 4,
  rowSpacing: 4,
  keyLayout: keyLayout,
  keyboardInputController: keyboardController,
)''',
      ),
      DetailSection(
        title: 'Key features',
        items: [
          'Define any keyboard layout using a simple 2D array',
          'Real-time key listener with last key and full entered text',
          'Customizable column and row spacing',
          'Explicit width and height control for precise sizing',
          'Integrates with ripple_container for tap feedback',
        ],
      ),
      DetailSection(
        title: 'Constructor parameters',
        parameters: [
          ParameterInfo(
            name: 'keyLayout',
            type: 'List<List<VirtualKey>>',
            description: '2D array defining the keyboard structure',
            required: true,
          ),
          ParameterInfo(
            name: 'keyboardInputController',
            type: 'KeyboardInputController',
            description: 'Controller for listening to input events',
            required: true,
          ),
          ParameterInfo(
            name: 'width',
            type: 'double',
            description: 'Total width of the keyboard widget',
          ),
          ParameterInfo(
            name: 'height',
            type: 'double',
            description: 'Total height of the keyboard widget',
          ),
          ParameterInfo(
            name: 'columnSpacing',
            type: 'double',
            description: 'Horizontal spacing between keys, default 4',
          ),
          ParameterInfo(
            name: 'rowSpacing',
            type: 'double',
            description: 'Vertical spacing between rows, default 4',
          ),
        ],
      ),
      DetailSection(
        title: 'Lifecycle',
        code: '''
@override
void dispose() {
  keyboardController.dispose(); // Always dispose!
  super.dispose();
}''',
      ),
    ],
  ),
  PackageDetail(
    packageName: 'ripple_container',
    sections: [
      DetailSection(
        title: 'Installation',
        code: '''
dependencies:
  ripple_container: ^latest''',
      ),
      DetailSection(
        title: 'Basic usage',
        code: '''
RippleContainer(
  width: 200,
  height: 100,
  backgroundColor: Colors.blueAccent,
  margin: const EdgeInsets.all(10),
  borderRadius: BorderRadius.circular(30),
  splashColor: Colors.amber,
  border: const Border.fromBorderSide(
    BorderSide(color: Colors.grey),
  ),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.5),
      offset: const Offset(0, 2),
      blurRadius: 10,
    ),
  ],
  onTap: () => print('tapped'),
  onLongPress: () => print('long pressed'),
  child: const Text('Tap me'),
)''',
      ),
      DetailSection(
        title: 'Key features',
        items: [
          'Native Material ripple and splash effect on any container',
          'Full control over background color, border, and border radius',
          'Box shadow support for elevation effects',
          'onTap and onLongPress callbacks',
          'Custom splash color for branded interactions',
        ],
      ),
      DetailSection(
        title: 'Constructor parameters',
        parameters: [
          ParameterInfo(
            name: 'child',
            type: 'Widget',
            description: 'The widget placed inside the container',
            required: true,
          ),
          ParameterInfo(
            name: 'width',
            type: 'double?',
            description: 'Container width; defaults to parent constraints',
          ),
          ParameterInfo(
            name: 'height',
            type: 'double?',
            description: 'Container height; defaults to child height',
          ),
          ParameterInfo(
            name: 'backgroundColor',
            type: 'Color?',
            description: 'Background fill color of the container',
          ),
          ParameterInfo(
            name: 'borderRadius',
            type: 'BorderRadius?',
            description: 'Rounded corners applied to container and ripple',
          ),
          ParameterInfo(
            name: 'splashColor',
            type: 'Color?',
            description: 'Color of the ripple splash effect',
          ),
          ParameterInfo(
            name: 'border',
            type: 'Border?',
            description: 'Border drawn around the container',
          ),
          ParameterInfo(
            name: 'boxShadow',
            type: 'List<BoxShadow>?',
            description: 'Shadow layers for elevation',
          ),
          ParameterInfo(
            name: 'margin',
            type: 'EdgeInsets?',
            description: 'Outer margin around the container',
          ),
          ParameterInfo(
            name: 'onTap',
            type: 'VoidCallback?',
            description: 'Called when the container is tapped',
          ),
          ParameterInfo(
            name: 'onLongPress',
            type: 'VoidCallback?',
            description: 'Called on long press',
          ),
        ],
      ),
    ],
  ),
  PackageDetail(
    packageName: 'size_tailored_text',
    sections: [
      DetailSection(
        title: 'Installation',
        code: '''
dependencies:
  size_tailored_text: ^latest''',
      ),
      DetailSection(
        title: 'Basic usage',
        code: '''
SizedBox(
  width: 200,
  height: 60,
  child: SizeTailoredText(
    text: 'Hello World',
    style: const TextStyle(
      fontSize: 100,
      fontWeight: FontWeight.bold,
    ),
  ),
)''',
      ),
      DetailSection(
        title: 'Use case: responsive card title',
        code: '''
LayoutBuilder(
  builder: (context, constraints) {
    return SizeTailoredText(
      text: userName,
      style: const TextStyle(fontSize: 24),
    );
  },
)''',
      ),
      DetailSection(
        title: 'Key features',
        items: [
          'Auto-scales font size to fit parent dimensions',
          'Accepts standard TextStyle for full styling control',
          'Ideal for dashboards, cards, and variable-length text',
          'Cross-platform: Android, iOS, Web, Desktop',
        ],
      ),
    ],
  ),
  PackageDetail(
    packageName: 'project_color_palette',
    sections: [
      DetailSection(
        title: 'Installation',
        code: '''
dependencies:
  project_color_palette: ^latest''',
      ),
      DetailSection(
        title: 'CSV format',
        code: '''
# colors.csv
primary,#1A73E8
secondary,#F5F5F5
accent,#FF6D00
error,#B00020
surface,#FFFFFF''',
      ),
      DetailSection(
        title: 'Usage',
        code: '''
final palette = await ProjectColorPalette.fromCsv('assets/colors.csv');

Container(
  color: palette['primary'],
  child: Text('Brand color'),
)''',
      ),
      DetailSection(
        title: 'Key features',
        items: [
          'Designer-developer collaboration via simple CSV files',
          'Single source of truth for project color tokens',
          'Eliminates manual hex value copy-paste errors',
          'Integrates with existing Flutter theming system',
        ],
      ),
    ],
  ),
  PackageDetail(
    packageName: 'aqlinter',
    sections: [
      DetailSection(
        title: 'Installation',
        code: '''
dev_dependencies:
  aqlinter: ^latest''',
      ),
      DetailSection(
        title: 'Setup',
        code: '''
# analysis_options.yaml
include: package:aqlinter/analysis_options.yaml

linter:
  rules:
    prefer_single_quotes: true''',
      ),
      DetailSection(
        title: 'Key features',
        items: [
          'Opinionated, battle-tested rules for Flutter and Dart codebases',
          'One-line include with zero configuration required',
          'Fully overridable on a per-rule basis',
          'Keeps the entire team on the same code style',
        ],
      ),
    ],
  ),
];
