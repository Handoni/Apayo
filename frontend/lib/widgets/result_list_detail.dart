import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Color categoryColor = Color.fromARGB(255, 92, 78, 143);
const Color contentColor = Color.fromARGB(255, 54, 54, 54);
const double title = 50; // 큰 타이틀 간 간격
const double sub = 15; // 타이틀과 그 내용의 간격
const double categorysize = 25; // 타이틀(카테고리) 폰트 사이즈

class ResultlistDetail extends StatefulWidget {
  final String sessionId;
  final String finalDisease;

  const ResultlistDetail(
      {super.key, required this.sessionId, required this.finalDisease});

  @override
  State<ResultlistDetail> createState() => ResultlistDetailState();
}

class ResultlistDetailState extends State<ResultlistDetail> {
  late Future<Map<String, dynamic>> _sessionDetails;
  final FlutterSecureStorage secureStorage =
      const FlutterSecureStorage(); // SecureStorage 인스턴스 생성

  @override
  void initState() {
    super.initState();
    _sessionDetails = fetchSessionDetails(widget.sessionId);
  }

  // 상세 정보 로드
  Future<Map<String, dynamic>> fetchSessionDetails(String sessionId) async {
    String? accessToken =
        await secureStorage.read(key: 'access_token'); // SecureStorage에서 토큰 로드

    if (accessToken == null) {
      throw Exception('Access token not found');
    }
    final response = await http.get(
      Uri.parse('http://52.79.91.82/api/session/$sessionId/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load session details');
    }
  }

  // 피드백 전송 POST
  void _sendFeedback(
      String sessionId, String realDisease, String feedback) async {
    String? accessToken =
        await secureStorage.read(key: 'access_token'); // SecureStorage에서 토큰 로드

    if (accessToken == null) {
      throw Exception('Access token not found');
    }

    final response = await http.post(
      Uri.parse('http://52.79.91.82/api/feedback/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'session_id': sessionId,
        'real_disease': realDisease,
        'feedback': feedback
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback sent successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send feedback.')),
      );
    }
  }

  // 피드백 보내는 팝업창
  void _showFeedbackDialog(String sessionId) {
    TextEditingController feedbackController = TextEditingController();
    TextEditingController realDiseaseController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '"Apayo"에게 말해요!',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: categoryColor,
                fontSize: MediaQuery.of(context).size.width * 0.013,
                fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: realDiseaseController,
                decoration:
                    const InputDecoration(hintText: '병원에서 진단 받은 실제 병명을 알려주세요!'),
              ),
              TextField(
                controller: feedbackController,
                decoration: const InputDecoration(hintText: '하고 싶으신 말을 남겨주세요!'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                _sendFeedback(sessionId, realDiseaseController.text,
                    feedbackController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // UI build
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _sessionDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        } else {
          final sessionData = snapshot.data!;
          final secondarySymptomsRaw = sessionData['secondary_symptoms'] ?? {};
          final secondarySymptoms =
              Map<String, String>.from(secondarySymptomsRaw);
          final List<String> yesSymptoms = secondarySymptoms.entries
              .where((entry) => entry.value == 'yes')
              .map((entry) => entry.key)
              .toList();
          final List<String> noSymptoms = secondarySymptoms.entries
              .where((entry) => entry.value == 'no')
              .map((entry) => entry.key)
              .toList();

          return Column(
            // 세 구역
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // 채팅 증상, 날짜, 뒤로 가기
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color(0xffEDEEFF),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          AutoSizeText(
                            // 입력한 채팅
                            '${sessionData['user_input']}',
                            maxFontSize: 25,
                            minFontSize: 5,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.02,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AutoSizeText(
                            // 업데이트 날짜.
                            '${sessionData['updated_at'].substring(0, 10)}',
                            maxFontSize: 15,
                            minFontSize: 5,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.02,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              Expanded(
                // 선택 증상, 예상 질병, 추천 사항
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: ListView(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width * 0.1,
                            vertical: MediaQuery.of(context).size.width * 0.01),
                        child: Column(
                          children: [
                            AutoSizeText(
                              '내가 선택한 추가 증상들',
                              maxFontSize: categorysize,
                              minFontSize: 10,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: categoryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                      'Yes',
                                      maxFontSize: 20,
                                      minFontSize: 5,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        color: categoryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AutoSizeText(
                                      // 내가 선택한 증상 리스트
                                      yesSymptoms.join('\n'),
                                      maxFontSize: 20,
                                      minFontSize: 5,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 2,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        color: contentColor,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    AutoSizeText(
                                      'No',
                                      maxFontSize: 20,
                                      minFontSize: 5,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        color: categoryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    AutoSizeText(
                                      // 내가 선택하지 않은 증상 리스트
                                      noSymptoms.join('\n'),
                                      maxFontSize: 20,
                                      minFontSize: 5,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        height: 2,
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.03,
                                        color: contentColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: title,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.15,
                            vertical: MediaQuery.of(context).size.width * 0.01),
                        child: Column(
                          children: [
                            AutoSizeText(
                              '예상 질병이나 증상',
                              maxFontSize: categorysize,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: categoryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: sub,
                            ),
                            AutoSizeText(
                              '${sessionData['final_diseases']}',
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: contentColor,
                              ),
                            ),
                            const SizedBox(
                              height: sub,
                            ),
                            AutoSizeText(
                              '${sessionData['final_disease_description']}',
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                height: 2,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: contentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: title,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05,
                            vertical: MediaQuery.of(context).size.width * 0.01),
                        child: Column(
                          children: [
                            AutoSizeText(
                              '추천 진료과',
                              maxFontSize: categorysize,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: categoryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: sub,
                            ),
                            AutoSizeText(
                              '${sessionData['recommended_department']}',
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: contentColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                // 피드백
                flex: 1,
                child: Center(
                  child: TextButton(
                    child: const Text('"Aapayo"가 당신께 도움이 됐나요?'),
                    onPressed: () {
                      _showFeedbackDialog(widget.sessionId);
                    },
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
