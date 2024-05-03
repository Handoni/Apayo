import 'dart:async';

import 'package:flutter/material.dart';
import 'widgets/result_card.dart';
import 'widgets/select_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SessionData {
  final String sessionId;
  final List<String> symptoms;
  final Map<String, String> questions;

  SessionData(
      {required this.sessionId,
      required this.symptoms,
      required this.questions});
}

class GptPage extends StatefulWidget {
  const GptPage({super.key});

  @override
  State<GptPage> createState() => _GptPageState();
}

class _GptPageState extends State<GptPage> {
  // 백에 증상 채팅 입력 보내고 처리.
  Future<SessionData?> responseSymptom() async {
    String text = _chatControlloer.text; // 현재 텍스트 필드의 텍스트 추출
    _chatControlloer.clear(); // 텍스트 필드 클리어
    // 백엔드로 POST 요청 보내기
    try {
      http.Response response = await http.post(
        Uri.parse('http://127.0.0.1:8000/primary_disease_prediction/'),
        headers: {'Content-Type': 'application/json'}, // POST 요청의 헤더
        body: json.encode(
            {'user_id': '777', 'symptoms': text}), // POST 요청의 바디 (메시지 데이터)
      );

      if (response.statusCode == 200) {
        // 서버 응답 성공 확인

        // 서버의 응답에서 JSON 데이터를 파싱
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // 질문 각각 추출, 응답에서 "questions"를 추출하여 Map에 저장
        Map<String, String> questions = {};
        if (jsonResponse['questions'] != null) {
          jsonResponse['questions'].forEach((key, value) {
            questions[key] = value.toString();
          });
        }

        // 응답 데이터를 사용하여 SessionData 객체를 생성
        var sessionData = SessionData(
            sessionId: jsonResponse['session_id'],
            symptoms: List<String>.from(jsonResponse['symptoms']),
            questions: questions);

        // Optionally print or return session data
        // print('Session ID: ${sessionData.sessionId}');
        // print('Symptoms: ${sessionData.symptoms}');
        // print('Questions: ${sessionData.questions}');

        // 생성된 SessionData 객체를 반환
        return sessionData;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      print('Caught an error: $e');
    }
    return null;
  }

  _sendMessage() async {
    // 단순히 맨 위에 입력한 증상 띄움. + 백에 전송.
    setState(() {
      String text = _chatControlloer.text;
      userSymptomChat.add(text); // 메시지 목록에 텍스트 추가
    });
    SessionData? sessionData = await responseSymptom();
    updateData(sessionData);
  }

  bool selectedCard = false; // 선지가 생성됐는지
  bool recieveResult = false; // 결과가 도착했는지
  Key nextKey = UniqueKey(); // 다음으로 이동

  List<String> contents = [];

  void updateData(SessionData? sessionData) {
    // 백엔드에서 데이터를 받는 것을 시뮬레이션
    List<String> newData = []; // 새로운 데이터 리스트
    if (sessionData != null) {
      sessionData.questions.forEach((key, value) {
        newData.add(value.toString());
      });
    }

    setState(() {
      contents = newData; // 기존 데이터를 새 데이터로 교체
      nextKey = UniqueKey(); // 버튼에 새로운 키를 할당하여 변화를 강제
      selectedCard = true; // 선지 생성됨.
    });
  }

  List<String> userSymptomChat = []; // 사용자의 채팅입력(증상)
  final TextEditingController _chatControlloer = TextEditingController();

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
                            const Text(
                              "아래 해당되는 항목을 눌러보세요!",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w900),
                            ),
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
                        // 진단 받기 버튼
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            //if (selectedCard) // 백이랑 합치고 주석 해제.
                            if (!recieveResult) // 최종 결과 안 나올 때까지
                              (AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  key: nextKey, // 버튼이 변경될 때마다 새 키 사용
                                  onPressed: () {},
                                  child: const Text(
                                    '진단 받아보기 >',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              )),
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
