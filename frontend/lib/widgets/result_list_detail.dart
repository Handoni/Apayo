import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Color background = Color(0xffEDEEFF);
const Color category = Color.fromARGB(255, 66, 51, 119);

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
          title: const Text('Send Feedback'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: realDiseaseController,
                decoration:
                    const InputDecoration(hintText: 'Enter real disease'),
              ),
              TextField(
                controller: feedbackController,
                decoration:
                    const InputDecoration(hintText: 'Enter your feedback'),
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
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    image: DecorationImage(
                      image: AssetImage('assets/logoA.png'),
                      colorFilter:
                          ColorFilter.mode(Colors.white24, BlendMode.dstATop),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05,
                            vertical: MediaQuery.of(context).size.width * 0.01),
                        child: Column(
                          children: [
                            AutoSizeText(
                              '내가 선택한 증상',
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: category,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AutoSizeText(
                              '${sessionData['secondary_symptoms']}',
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05,
                            vertical: MediaQuery.of(context).size.width * 0.01),
                        child: Column(
                          children: [
                            AutoSizeText(
                              '예상 질병이나 증상',
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: category,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AutoSizeText(
                              '${sessionData['final_diseases']}',
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AutoSizeText(
                              '${sessionData['final_disease_description']}',
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: category,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AutoSizeText(
                              '${sessionData['recommended_department']}',
                              maxFontSize: 20,
                              minFontSize: 5,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.03,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
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
                    child: const Text('"Aapayo"의 예측은 괜찮았나요?'),
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
