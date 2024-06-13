import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/login_page.dart';
import 'package:frontend/result_list_class.dart';
import 'package:frontend/widgets/popup.dart';
import 'package:frontend/widgets/result_card.dart';
import 'package:frontend/widgets/result_list_detail.dart';
import 'package:frontend/widgets/select_card.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

class DiseaseInfo {
  final String disease;
  final String dept;
  final String description;

  DiseaseInfo(
      {required this.disease, required this.dept, required this.description});
}

class ResultData {
  final List<DiseaseInfo> diseaseInfo;

  ResultData({required this.diseaseInfo});
}

String SessionID = 'null';

class GptPage extends StatefulWidget {
  const GptPage({super.key});

  @override
  State<GptPage> createState() => _GptPageState();
}

// selectcard 인스턴스
SelectCardState? finalSelect;

class _GptPageState extends State<GptPage> {
  final FlutterSecureStorage secureStorage =
      const FlutterSecureStorage(); // SecureStorage 인스턴스 생성
  // 로그인 유저 토큰
  String? accessToken;
  // 토큰 로드 함수
  void _loadAccessToken() async {
    String? token = await secureStorage.read(key: 'access_token');
    setState(() {
      accessToken = token;
    });
  }

  // 새 채팅 시작 버튼이 눌렸을 때 호출
  void startNewChat() {
    resetValue(); // 변수값 초기화
    setState(() {
      nextKey = UniqueKey(); // UI 갱신을 위한 새로운 키 할당
      // UI를 완전히 초기 상태로 리셋
      futureListInfo = fetchResultListInfo();
    });
  }

  // new chat 시 변수값을 초기화.
  void resetValue() {
    cardSelections = {}; //id:선택여부
    isLoading = false; // 로딩 상태를 관리하는 변수
    text = ''; // 사용자가 입력한 증상 채팅 저장하는 변수
    attempt = false; // 채팅 시도 여부
    contents = {}; // 선지 데이터 초기화
    selectedCard = false; // 선지가 생성됐는지
    recieveResult = false; // 결과가 도착했는지
    SessionID = 'null'; // 세션 ID 초기화

    //결과 담는 변수들
    resultlength = 0;
    diseases = [];
    departments = [];
    descriptions = [];

    // 입력 필드 초기화
    _chatControlloer.clear();

    setState(() {});
  }

  Map<String, bool> cardSelections = {}; //id:선택여부
  bool isLoading = false; // 로딩 상태를 관리하는 변수

  @override
  void initState() {
    super.initState();
    _loadAccessToken(); // 로큰 로드 함수 호출
    contents.forEach((key, value) {
      cardSelections[key] = false;
    });
    futureListInfo = fetchResultListInfo();
  }

  void toggleCardState(String id) {
    // 카드의 선택 상태를 변경
    setState(() {
      cardSelections[id] = !cardSelections[id]!;
    });
  }

  String text = ''; // 사용자가 입력한 증상 채팅 저장하는 변수
  bool attempt = false; // 채팅 시도 여부

  bool selectedCard = false; // 선지가 생성됐는지
  bool recieveResult = false; // 결과가 도착했는지
  Key nextKey = UniqueKey(); // 다음으로 이동

  Map<String, String> contents = {}; //ID:값

  final TextEditingController _chatControlloer = TextEditingController();

  int resultlength = 0;
  List<String> diseases = [];
  List<String> departments = [];
  List<String> descriptions = [];

  // 단순히 맨 위에 입력한 증상 띄움. + 백에 전송하는 함수 호출.
  _sendMessage() async {
    setState(() {
      String t = _chatControlloer.text;
      if (t.trim().isEmpty && !attempt) {
        // 공백을 전송하였을 때.
        PopupMessage('증상을 입력해주세요!').showPopup(context);
        return;
      } else {
        text = t;
      }
      isLoading = true; // 로딩 상태 활성화
    });

    SessionData? sessionData = await responseSymptom();
    updateData(sessionData);

    setState(() {
      isLoading = false; // 로딩 상태 비활성화
    });
  }

  // 백에 증상 채팅 입력 보내고 처리.
  Future<SessionData?> responseSymptom() async {
    _chatControlloer.clear(); // 텍스트 필드 클리어

    // 백엔드로 POST 요청 보내기
    try {
      http.Response response = await http.post(
        Uri.parse('https://apayo.kro.kr/api/primary_disease_prediction/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        }, // POST 요청의 헤더
        body: json.encode({'symptoms': text}), // POST 요청의 바디 (메시지 데이터)
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

        SessionID = sessionData.sessionId;
        selectedCard = true; // 선지 생성됨.

        // 생성된 SessionData 객체를 반환
        return sessionData;
      } else {
        // 서버 응답 실패 시
        var errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
        var errorDetail =
            errorResponse['detail'] ?? 'An unknown error occurred.';

        // 팝업 메시지 표시
        PopupMessage(errorDetail).showPopup(context);
      }
    } catch (e) {
      // 네트워크 오류 또는 기타 예외 처리
      PopupMessage('Caught an error: $e').showPopup(context);
    }
    return null;
  }

  // 백엔드에서 데이터를 받아서 업데이트 (채팅 입력 후 선지 생성)
  void updateData(SessionData? sessionData) {
    Map<String, String> newData = {}; // 새로운 데이터 리스트
    Map<String, bool> newCardSelections = {}; // 새로운 선택 리스트
    if (sessionData != null) {
      sessionData.questions.forEach((key, value) {
        newData[key.toString()] = value.toString();
        newCardSelections[key.toString()] = false;
      });
    }

    setState(() {
      contents = newData; // 기존 데이터를 새 데이터로 교체
      cardSelections = newCardSelections; // 기존 선택을 새 선택으로 교체
      nextKey = UniqueKey(); // 버튼에 새로운 키를 할당하여 변화를 강제
    });
  }

  // 선택한 선지 백에 전송하는 함수 호출.
  _sendResponse() async {
    setState(() {
      isLoading = true; // 로딩 상태 활성화
    });

    ResultData? resultData = await responseQuestion();

    if (resultData != null) {
      // resultData의 diseaseInfo 리스트를 반복하여 각 정보를 추출
      for (var diseaseInfo in resultData.diseaseInfo) {
        setState(() {
          diseases.add(diseaseInfo.disease);
          departments.add(diseaseInfo.dept);
          descriptions.add(diseaseInfo.description);
        });
      }
    }

    setState(() {
      resultlength = diseases.length;
      isLoading = false; // 로딩 상태 비활성화
    });
  }

  // 질문 선택 결과 백에 전송.
  Future<ResultData?> responseQuestion() async {
    // SelectCard에서 가져온 선택값

    try {
      print(cardSelections
          .map((key, value) => MapEntry(key, value ? 'yes' : 'no')));
      http.Response response = await http.post(
        Uri.parse('https://apayo.kro.kr/secondary_disease_prediction/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken'
        },
        body: json.encode({
          'session_id': SessionID, // 세션 ID 전송
          'responses': cardSelections
              .map((key, value) => MapEntry(key, value ? 'yes' : 'no'))
        }),
      );

      // JSON 응답 객체에서 'response' 키를 통해 질병 정보를 추출
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(utf8.decode(response.bodyBytes));

        // response 객체에서 각 질병 정보를 추출
        Map<String, dynamic> diseases = jsonResponse;

        // 모든 질병 정보를 리스트로 변환
        List<DiseaseInfo> diseaseInfoList = [
          DiseaseInfo(
              disease: diseases['Disease'],
              dept: diseases['recommended_department'],
              description: diseases['description'])
        ];

        // 응답 데이터를 사용하여 ResultData 객체를 생성
        var resultData = ResultData(diseaseInfo: diseaseInfoList);
        recieveResult = true;
        attempt = true;
        return resultData;
      } else {
        // 서버 응답 실패 시
        var errorResponse = jsonDecode(utf8.decode(response.bodyBytes));
        var errorDetail =
            errorResponse['detail'] ?? 'An unknown error occurred.';

        // 팝업 메시지 표시
        PopupMessage(errorDetail).showPopup(context);
      }
    } catch (e) {
      // 네트워크 오류 또는 기타 예외 처리
      PopupMessage('Caught an error: $e').showPopup(context);
    }
    return null;
  }

  // 로그아웃 함수
  void logoutUser(BuildContext context) async {
    await secureStorage.delete(key: 'access_token'); // SecureStorage에서 토큰 삭제

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

// 사용자 채팅 목록
  late Future<List<ResultInfo>> futureListInfo;

  // UI build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Row(
            children: [
              Text(
                'APAYO TEAM 6',
                style: TextStyle(
                  color: Color.fromARGB(255, 94, 94, 94),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 10),
              Text(
                '         RYU SOOJUNG         LEE SANGYUN         HYUN SOYOUNG',
                style: TextStyle(
                  color: Color.fromARGB(255, 94, 94, 94),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          backgroundColor: const Color.fromARGB(255, 255, 255, 255),
          toolbarHeight: 70,
          titleSpacing: 50, //앱바 왼쪽 간격추가
        ),
        body: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xffEDEEFF),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  backgroundColor: const Color(0xffB1B3F4)),
                              onPressed: () {
                                startNewChat();
                              },
                              child: AutoSizeText(
                                'New Chat',
                                maxFontSize: 20,
                                minFontSize: 5,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.02),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        AutoSizeText(
                          textAlign: TextAlign.center,
                          'Previous Conversations',
                          maxFontSize: 15,
                          minFontSize: 5,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.02,
                              color: const Color(0xffB1B3F4)),
                        ),
                        // 그 동안 채팅 목록
                        Expanded(
                          flex: 7,
                          child: FutureBuilder<List<ResultInfo>>(
                            future: futureListInfo,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data!.isEmpty) {
                                return const Text('No data available');
                              } else {
                                return ListView.builder(
                                  itemCount: snapshot.data!.length,
                                  itemBuilder: (context, index) {
                                    final listInfo = snapshot.data![index];
                                    return ListTile(
                                      title: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ResultlistDetail(
                                                sessionId: listInfo.sessionId,
                                                finalDisease:
                                                    listInfo.finalDisease,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(listInfo.finalDisease),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: TextButton(
                              onPressed: () {
                                logoutUser(context);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize
                                    .min, // Row가 자식 크기에 맞춰 최소 크기를 가지도록 설정
                                children: <Widget>[
                                  Icon(
                                    Icons.logout,
                                    color: const Color(0xffB1B3F4),
                                    size: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                                  AutoSizeText(
                                    'Log Out',
                                    maxFontSize: 20,
                                    minFontSize: 5,
                                    style: TextStyle(
                                        color: const Color(0xffB1B3F4),
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.02),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
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
                              children: [
                                Container(
                                  // 화면크기에 맞게 container 조정.
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffEDEEFF),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Text(
                                    text,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Column(
                            children: [
                              if (selectedCard &&
                                  !recieveResult) // 선지가 생성됐을 때 출력.
                                const Text(
                                  "아래 해당되는 항목을 눌러보세요!",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w900),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            flex: 8,
                            // Expanded 위젯을 사용하여 Column 내에서 GridView가 차지할 공간을 유동적으로 할당
                            child: Column(
                              children: [
                                if (!recieveResult) // 선지 선택 카드
                                  Expanded(
                                    // GridView를 스크롤 가능하게 하기 위해 Expanded로 감쌈.
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2, // 한 줄에 카드 2개씩 배치
                                        childAspectRatio:
                                            8 / 3, //item 의 가로 세로의 비율
                                        crossAxisSpacing: 20, // 카드 간 가로 간격
                                        mainAxisSpacing: 20, // 카드 간 세로 간격
                                      ),
                                      itemCount: contents.length,
                                      itemBuilder: (context, index) {
                                        var entry =
                                            contents.entries.elementAt(index);
                                        return SelectCard(
                                          content: entry.value,
                                          isInverted:
                                              cardSelections[entry.key]!,
                                          toggleInvert: () =>
                                              toggleCardState(entry.key),
                                        );
                                      },
                                    ),
                                  )
                                else // 결과 카드
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: resultlength,
                                      itemBuilder: (context, index) {
                                        return ResultCard(
                                            disease: diseases[index],
                                            description: descriptions[index],
                                            dept: departments[index],
                                            n: index);
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Expanded(
                            // 진단 받기 버튼
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (!recieveResult &&
                                    selectedCard) // 최종 결과 나오지 않고, 선지가 생성됐을 때 진단받기 버튼 생성.
                                  (AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 500),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.black,
                                      ),
                                      key: nextKey, // 버튼이 변경될 때마다 새 키 사용
                                      onPressed: _sendResponse,
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
                                    onSubmitted: (_) =>
                                        attempt // 이미 시도하여 new chat을 해야하는 경우.
                                            ? PopupMessage(
                                                    '\'New Chat\'버튼을 클릭하여 새로운 채팅을 시작해주세요!')
                                                .showPopup(context)
                                            : _sendMessage(), // 증상 입력 시도를 한 번 하면 새로운 채팅 만들라는 메시지 출력
                                    decoration: InputDecoration(
                                      labelText: '증상을 입력하세요.',
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20.0),
                                      suffixIcon: IconButton(
                                        icon: const Icon(Icons.send),
                                        onPressed: () =>
                                            attempt // 이미 시도하여 new chat을 해야하는 경우.
                                                ? PopupMessage(
                                                        '\'New Chat\' 버튼을 클릭하여 새로운 채팅을 시작해주세요!')
                                                    .showPopup(context)
                                                : _sendMessage(),
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
            if (isLoading) // 로딩 상태일 때 CircularProgressIndicator 표시
              Offstage(
                offstage: !isLoading,
                child: const Stack(
                  children: [
                    ModalBarrier(dismissible: false, color: Colors.black45),
                    Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
