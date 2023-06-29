import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// 파일 최상단에는 main() 함수가 있습니다. MyApp에서 정의된 앱을 실행하라고 Flutter에 지시할 뿐입니다.
void main() {
  runApp(MyApp());
}

// MyApp 클래스는 StatelessWidget을 확장하여 전체 앱 상태를 생성하고 앱의 이름을 지정하며 시각적 테마를 정의합니다.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// MyAppState 클래스는 앱이 작동하는데 필요한 데이터를 정의합니다. 
// 상태가 만들어지면 ChangeNotifierProvider를 사용하여 전체 앱에 제공됩니다. 이렇게 하면 앱의 위젯이 상태를 알 수 있습니다.
class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
  // getNext() 메서드는 임의의 새 WordPair를 current에 재할당합니다.
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {          // 위젯이 항상 최신 상태로 유지되도록 위젯 상황이 변경될 때마다 자동으로 호출되는 build() 메서드를 정의합니다.
    var appState = context.watch<MyAppState>(); // watch 메서드를 사용하여 앱의 현재 상태에 관한 변경사항을 추적합니다. 
    var pair = appState.current;

    return Scaffold(
      body: Center(
        child: Column(                             // Column은 Flutter에서 가장 기본적인 레이아웃 위젯 중 하나로, 하위 요소를 위에서 아래로 열에 배치합니다.
          mainAxisAlignment: MainAxisAlignment.center,  // 기본(세로) 축을 따라 Column 내 하위 요소가 중앙에 배치됩니다.
          children: [
            Text('멋진 브랜드네임 생성기'),
            BigCard(pair: pair),    // Text 위젯은 해당 클래스의 유일한 멤버인 current(즉, WordPair)에 액세스합니다.  
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                appState.getNext();
              },
              child: Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // 앱의 현재 테마를 확인하여 theme에 할당.
    final style = theme.textTheme.displayMedium!.copyWith( // thme.textTheme을 사용하여 앱의 글꼴 테마에 액세스. 
      color: theme.colorScheme.onPrimary, // onPrimary 속성은 앱의 기본 색상으로 사용하기 적합한 색상을 정의함.
    );

    return Card(
      color: theme.colorScheme.primary, // 카드의 색상을 앱의 현재 테마와 동일하도록 정의함.
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: "${pair.first} ${pair.second}", // Text의 semanticsLabel 속성을 사용하여 텍스트 위젯의 시각적 콘텐츠를 스크린 리더에 더 적합한 시맨틱 콘텐츠로 재정의
        ),
      ),
    );
  }
}