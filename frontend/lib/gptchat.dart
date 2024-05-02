import 'package:flutter/material.dart';
import 'widgets/select_card.dart';
import 'package:http/http.dart' as http;

class GptPage extends StatefulWidget {
  const GptPage({super.key});

  @override
  State<GptPage> createState() => _GptPageState();
}

class _GptPageState extends State<GptPage> {
  bool selectedCard = false; // 선지가 생성됐는지
  bool recieveResult = false; // 결과가 도착했는지
  Key nextKey = UniqueKey(); // 다음으로 이동

  List<String> contents = [
    // test용, 백이랑 연동해보고 삭제.
    // 생성될 선지 버튼
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  void updateData() {
    // 백엔드에서 데이터를 받는 것을 시뮬레이션
    List<String> newData = [
      "New Item 1",
      "New Item 2",
      "New Item 3"
    ]; // 새로운 데이터 리스트
    setState(() {
      contents = newData; // 기존 데이터를 새 데이터로 교체
      nextKey = UniqueKey(); // 버튼에 새로운 키를 할당하여 변화를 강제
      selectedCard = true; // 선지 생성됨.
    });
  }

  List<String> userSymptomChat = []; // 사용자의 채팅입력(증상)
  final TextEditingController _chatControlloer = TextEditingController();

  // 메시지 전송 함수
  void _sendMessage() async {
    String text = _chatControlloer.text; // 현재 텍스트 필드의 텍스트 추출
    // 백엔드로 POST 요청 보내기
    http.Response response = await http.post(
      Uri.parse(
          'http://127.0.0.1:8000/primary_disease_predicton'), // 백엔드 URL. 아직 안 넣음.
      body: {'symptoms': text}, // POST 요청의 바디 (메시지 데이터)
    );

    if (response.statusCode == 200) {
      // 서버 응답 성공 확인
      setState(() {
        userSymptomChat.add(text); // 메시지 목록에 텍스트 추가
        _chatControlloer.clear(); // 텍스트 필드 클리어
      });
    } else {
      // 에러 처리 로직
      print("서버 응답 실패");
    }
  }

  void finalResult() {
    recieveResult = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xffEDEEFF),
                ),
                child: const Column(// 채팅 기록 추가할 수 있어야 함.
                    ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    colorFilter:
                        ColorFilter.mode(Colors.white24, BlendMode.dstATop),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        flex: 1, // 채팅 입력하면 보여주는 구역.
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                itemCount: userSymptomChat.length,
                                itemBuilder: (context, index) => Container(
                                  color: const Color(0xffEDEEFF),
                                  child: ListTile(
                                    title: Text(
                                      userSymptomChat[index],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          if (selectedCard) // 선지가 생성됐을 때 출력.
                            const Text("아래 해당되는 항목을 눌러보세요!",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                        // 선지 선택 카드
                        flex: 8,
                        // Expanded 위젯을 사용하여 Column 내에서 GridView가 차지할 공간을 유동적으로 할당
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 한 줄에 2개의 카드 배치
                            crossAxisSpacing: 10, // 카드 간 가로 간격
                            mainAxisSpacing: 50, // 카드 간 세로 간격
                          ),
                          itemCount: contents.length,
                          itemBuilder: (context, index) {
                            return SelectCard(
                              content: contents[index],
                              order: index + 1,
                            );
                          },
                        ),
                      ),
                      Expanded(
                        // 다음페이지 이동 버튼
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // if (selectedCard)  // 백이랑 합치고 주석 해제.
                            // (
                            if (!recieveResult) // 최종 결과 안 나올 때까지
                              (AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  key: nextKey, // 버튼이 변경될 때마다 새 키 사용
                                  onPressed: updateData,
                                  child: const Text(
                                    '진단 받아보기 >',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ))
                            // )
                            ,
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1, // 증상 채팅 입력바
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: const Color(0xffF1F1F1),
                              child: TextField(
                                controller: _chatControlloer,
                                onSubmitted: (_) => _sendMessage(),
                                decoration: InputDecoration(
                                  labelText: '증상을 입력하세요.',
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: _sendMessage,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ), // 여기에 다른 위젯 추가 가능
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
