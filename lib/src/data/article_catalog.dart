class ArticleInfo {
  const ArticleInfo({
    required this.slug,
    required this.title,
    required this.summary,
    required this.problem,
    required this.principles,
    required this.codeTitle,
    required this.code,
    required this.packageUsage,
    required this.cautions,
    required this.faq,
    required this.relatedPackageSlugs,
    required this.lastUpdated,
  });

  final String slug;
  final String title;
  final String summary;
  final String problem;
  final List<String> principles;
  final String codeTitle;
  final String code;
  final String packageUsage;
  final List<String> cautions;
  final List<FaqItem> faq;
  final List<String> relatedPackageSlugs;
  final String lastUpdated;
}

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

const articles = <ArticleInfo>[
  ArticleInfo(
    slug: 'flutter-custom-keyboard',
    title: 'Flutter 커스텀 키보드 구현',
    summary: '시스템 키보드 대신 앱 내부 키패드가 필요한 상황과 포커스, 접근성, 입력 상태 관리를 정리합니다.',
    problem:
        'PIN, 숫자 패드, POS 입력, 키오스크 화면은 시스템 키보드가 화면을 가리거나 불필요한 키를 노출할 수 있습니다. 이 경우 키보드를 위젯으로 직접 배치하면 레이아웃과 입력 흐름을 앱이 더 명확하게 통제할 수 있습니다.',
    principles: [
      '키보드를 화면 하단 고정 UI로 둘지, 특정 입력 컴포넌트 가까이에 둘지 먼저 결정합니다.',
      '입력 상태는 TextEditingController나 별도 controller 한 곳에서 관리해야 삭제, 초기화, 제출 처리가 단순해집니다.',
      '키 버튼은 충분한 터치 영역과 명확한 label을 가져야 하며, 포커스 이동이 예측 가능해야 합니다.',
      '시스템 키보드를 완전히 막는 화면이라도 스크린 리더가 읽을 수 있는 텍스트와 버튼 의미를 제공해야 합니다.',
      '숫자 입력, PIN 입력, POS 입력처럼 허용 문자가 제한된 흐름에서 커스텀 키보드의 장점이 큽니다.',
    ],
    codeTitle: 'Flutter 위젯 트리 안에서 숫자 키패드 배치',
    code: '''
class PinKeyboardExample extends StatefulWidget {
  const PinKeyboardExample({super.key});

  @override
  State<PinKeyboardExample> createState() => _PinKeyboardExampleState();
}

class _PinKeyboardExampleState extends State<PinKeyboardExample> {
  final keyboardController = KeyboardInputController();
  String pin = '';

  @override
  void initState() {
    super.initState();
    keyboardController.setKeyListener((lastKey, enteredText) {
      setState(() => pin = enteredText);
    });
  }

  @override
  void dispose() {
    keyboardController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final layout = [
      [VirtualKey(text: '1'), VirtualKey(text: '2'), VirtualKey(text: '3')],
      [VirtualKey(text: '4'), VirtualKey(text: '5'), VirtualKey(text: '6')],
      [VirtualKey(text: '7'), VirtualKey(text: '8'), VirtualKey(text: '9')],
      [VirtualKey(text: '0')],
    ];

    return Column(
      children: [
        Text('PIN: \$pin'),
        SoftKeyboardWidget(
          width: 360,
          height: 280,
          keyLayout: layout,
          keyboardInputController: keyboardController,
        ),
      ],
    );
  }
}''',
    packageUsage:
        'flutter_soft_keyboard는 키 배열과 KeyboardInputController를 중심으로 구성됩니다. 이 사이트에서는 pub.dev에 공개된 범위의 기본 사용법만 소개하며, 세부 옵션은 패키지 문서를 함께 확인하는 것이 좋습니다.',
    cautions: [
      '보안 입력을 처리한다면 화면 캡처, 로그, analytics 이벤트에 민감한 값이 남지 않게 합니다.',
      '키보드가 TextField의 기본 포커스 동작을 대체하는 경우 접근성 테스트가 필요합니다.',
      '큰 화면과 모바일 화면에서 키 크기와 행 간격이 모두 읽기 좋은지 확인해야 합니다.',
    ],
    faq: [
      FaqItem(
        question: '시스템 키보드보다 항상 좋은가요?',
        answer:
            '아닙니다. 일반 텍스트 입력은 시스템 키보드가 접근성과 자동완성 면에서 더 좋습니다. 제한된 키 입력이 핵심일 때만 커스텀 키보드가 적합합니다.',
      ),
      FaqItem(
        question: '웹에서도 사용할 수 있나요?',
        answer:
            '패키지 카탈로그 기준으로 Flutter Web 지원을 목표로 합니다. 실제 배포 전에는 브라우저별 포커스와 터치 동작을 확인해야 합니다.',
      ),
    ],
    relatedPackageSlugs: ['flutter-soft-keyboard'],
    lastUpdated: '2026-06-17',
  ),
  ArticleInfo(
    slug: 'flutter-ripple-effect',
    title: 'Flutter Ripple 효과 구현',
    summary:
        'GestureDetector와 InkWell의 차이, ripple이 보이지 않는 이유, 커스텀 컨테이너에 Material feedback을 넣는 방법을 설명합니다.',
    problem:
        'Flutter에서 GestureDetector는 탭을 감지하지만 시각적 피드백을 제공하지 않습니다. InkWell은 ripple을 제공하지만 Material 위젯, clipping, 배경색 계층이 맞지 않으면 효과가 보이지 않습니다.',
    principles: [
      'GestureDetector는 낮은 수준의 제스처 감지용이고, InkWell은 Material ink reaction을 제공하는 위젯입니다.',
      'InkWell의 ripple은 Material 위에 그려지므로 ancestor 또는 직접 감싼 Material이 필요합니다.',
      'Container의 색상이 InkWell 위에 있으면 ink가 가려질 수 있습니다.',
      'borderRadius를 쓰는 경우 Material과 InkWell의 clipping 반경을 함께 맞춰야 합니다.',
    ],
    codeTitle: 'Material과 InkWell을 직접 조합한 ripple 컨테이너',
    code: '''
Material(
  color: Colors.blue,
  borderRadius: BorderRadius.circular(12),
  clipBehavior: Clip.antiAlias,
  child: InkWell(
    onTap: () {},
    splashColor: Colors.white24,
    child: const SizedBox(
      width: 180,
      height: 56,
      child: Center(child: Text('Tap')),
    ),
  ),
)''',
    packageUsage:
        'ripple_container는 이 반복 패턴을 컨테이너형 API로 감싸는 패키지입니다. 배경색, 테두리, 그림자, splashColor, onTap 같은 속성을 한 곳에서 다룰 때 유용합니다.',
    cautions: [
      'ripple이 안 보이면 Material이 있는지, 색상이 ink를 덮고 있지 않은지 먼저 확인합니다.',
      '터치 영역이 너무 작으면 시각적 피드백이 있어도 사용성이 떨어집니다.',
      '브랜드 색상 ripple은 대비가 너무 낮지 않게 조정해야 합니다.',
    ],
    faq: [
      FaqItem(
        question: 'GestureDetector에 ripple만 추가할 수 있나요?',
        answer:
            'GestureDetector 자체에는 ripple이 없습니다. Material ink 효과가 필요하면 InkWell, InkResponse, 또는 이를 감싼 컴포넌트를 사용해야 합니다.',
      ),
      FaqItem(
        question: 'Container 안에서 InkWell이 안 보이는 이유는 무엇인가요?',
        answer:
            'Container의 decoration이 InkWell의 ink painting을 가릴 때가 많습니다. Material의 color와 clip 설정을 확인하세요.',
      ),
    ],
    relatedPackageSlugs: ['ripple-container'],
    lastUpdated: '2026-06-17',
  ),
  ArticleInfo(
    slug: 'flutter-auto-resize-text',
    title: 'Flutter 텍스트 자동 크기 조절',
    summary: '제한된 영역에서 긴 텍스트를 표시할 때 overflow, ellipsis, 자동 축소 전략을 비교합니다.',
    problem:
        '카드 제목, 배지, 버튼, 대시보드 값처럼 공간은 고정되어 있는데 텍스트 길이가 달라지는 UI에서는 overflow가 쉽게 발생합니다.',
    principles: [
      'ellipsis는 빠르고 안정적이지만 전체 의미가 잘릴 수 있습니다.',
      '줄바꿈은 본문에는 좋지만 버튼이나 칩에서는 높이 변화를 만들 수 있습니다.',
      '자동 축소는 레이아웃을 유지하지만 최소 글꼴 크기 아래로 내려가면 접근성이 나빠집니다.',
      '반응형 UI에서는 부모 크기와 maxLines를 먼저 고정해야 예측 가능한 축소가 가능합니다.',
    ],
    codeTitle: '고정 영역 안에서 텍스트 크기 조절',
    code: '''
SizedBox(
  width: 220,
  height: 48,
  child: SizeTailoredTextWidget(
    'Very long dashboard label',
    maxLines: 1,
    minFontSize: 11,
    overflow: TextOverflow.clip,
    style: const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
    ),
  ),
)''',
    packageUsage:
        'size_tailored_text는 부모 영역을 기준으로 글꼴 크기를 조정하는 Flutter 패키지입니다. 이 사이트의 헤더와 태그 UI에도 긴 텍스트가 넘치지 않도록 같은 계열의 위젯을 사용하고 있습니다.',
    cautions: [
      '본문 문단 전체를 자동 축소 대상으로 만들면 읽기 경험이 나빠질 수 있습니다.',
      'minFontSize를 너무 낮게 두면 모바일에서 접근성 문제가 생깁니다.',
      '부모 위젯의 width와 height가 모호하면 자동 축소 결과도 예측하기 어렵습니다.',
    ],
    faq: [
      FaqItem(
        question: 'ellipsis와 자동 축소 중 무엇이 좋나요?',
        answer:
            '목록 카드처럼 빠른 스캔이 중요하면 ellipsis가 좋고, 짧은 라벨의 전체 의미가 중요하면 자동 축소가 유리합니다.',
      ),
      FaqItem(
        question: '모든 텍스트에 적용해도 되나요?',
        answer: '아닙니다. 긴 본문은 일반 Text와 줄바꿈을 사용하고, 제한된 UI 요소에만 적용하는 편이 좋습니다.',
      ),
    ],
    relatedPackageSlugs: ['size-tailored-text'],
    lastUpdated: '2026-06-17',
  ),
  ArticleInfo(
    slug: 'android-expandable-text-view',
    title: 'Android 접기/펼치기 TextView',
    summary:
        '긴 텍스트를 접어서 보여주는 Android UI에서 줄 수 측정, 상태 관리, RecyclerView 주의점을 정리합니다.',
    problem:
        '리뷰, 설명, 댓글, 약관 일부 미리보기처럼 긴 텍스트를 모두 펼치면 화면 밀도가 낮아집니다. 접기/펼치기 패턴은 사용자가 필요한 내용만 확장하게 돕습니다.',
    principles: [
      'TextView의 lineCount는 레이아웃 이후에 안정적으로 읽어야 합니다.',
      'collapsedMaxLines와 expanded 상태를 분리해 저장해야 재활용되는 셀에서 상태가 섞이지 않습니다.',
      'RecyclerView에서는 아이템 id 또는 position에 대한 expanded 상태를 ViewHolder 밖에서 관리하는 편이 안전합니다.',
      '더 보기 버튼은 텍스트가 실제로 제한 줄 수를 넘을 때만 표시해야 합니다.',
    ],
    codeTitle: 'RecyclerView에서 확장 상태를 분리하는 Kotlin 예시',
    code: '''
class ArticleAdapter : RecyclerView.Adapter<ArticleViewHolder>() {
  private val expandedIds = mutableSetOf<Long>()

  override fun onBindViewHolder(holder: ArticleViewHolder, position: Int) {
    val item = getItem(position)
    val expanded = expandedIds.contains(item.id)

    holder.body.maxLines = if (expanded) Int.MAX_VALUE else 3
    holder.moreButton.setOnClickListener {
      if (expanded) expandedIds.remove(item.id) else expandedIds.add(item.id)
      notifyItemChanged(position)
    }
  }
}''',
    packageUsage:
        'ExpandableTextView는 이 패턴을 Android 커스텀 뷰로 다루는 AQoong GitHub 라이브러리입니다. 현재 사이트에서는 확인 가능한 저장소 링크와 일반 구현 원리를 제공하며, 실제 XML 속성과 API는 GitHub의 최신 코드를 확인해야 합니다.',
    cautions: [
      'ViewHolder 내부 boolean만 사용하면 스크롤 재활용 시 펼침 상태가 다른 행에 나타날 수 있습니다.',
      '텍스트 측정은 레이아웃 타이밍에 민감하므로 post 또는 doOnLayout 계열 처리가 필요할 수 있습니다.',
      '접기/펼치기 버튼의 contentDescription을 상태에 맞게 제공하는 것이 좋습니다.',
    ],
    faq: [
      FaqItem(
        question: '줄 수 측정은 언제 해야 하나요?',
        answer:
            'TextView가 레이아웃된 뒤 lineCount를 확인해야 합니다. 바인딩 직후에는 아직 측정 전일 수 있습니다.',
      ),
      FaqItem(
        question: 'RecyclerView에서 가장 흔한 버그는 무엇인가요?',
        answer:
            '확장 상태를 ViewHolder에만 두는 것입니다. 데이터 id 기준 상태를 어댑터나 ViewModel에 보관하는 편이 안전합니다.',
      ),
    ],
    relatedPackageSlugs: ['expandable-text-view'],
    lastUpdated: '2026-06-17',
  ),
];

ArticleInfo? articleBySlug(String slug) {
  for (final article in articles) {
    if (article.slug == slug) {
      return article;
    }
  }
  return null;
}
