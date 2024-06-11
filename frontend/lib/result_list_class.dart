import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// 최종 결과 리스트
class ResultInfo {
  final String sessionId;
  final String finalDisease;

  ResultInfo({required this.sessionId, required this.finalDisease});

  factory ResultInfo.fromJson(Map<String, dynamic> json) {
    return ResultInfo(
      sessionId: json['session_id'],
      finalDisease: json['final_diseases'],
    );
  }
}

// API 호출 함수
Future<List<ResultInfo>> fetchResultListInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');

  if (accessToken == null) {
    throw Exception('No user id found in SharedPreferences');
  }

  final response = await http.get(
    Uri.parse('http://52.79.91.82/api/users/me/sessions/'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse =
        json.decode(utf8.decode(response.bodyBytes));

    // jsonResponse['sessions']가 List인지 확인
    if (jsonResponse['sessions'] is List) {
      List<dynamic> sessions = jsonResponse['sessions'];

      // null 값 처리 및 타입 확인
      List<ResultInfo> results = sessions
          .where((data) => data != null && data is Map<String, dynamic>)
          .map((data) => ResultInfo.fromJson(data as Map<String, dynamic>))
          .toList();
      return results;
    } else {
      throw Exception('Unexpected format: sessions is not a list');
    }
  } else {
    throw Exception('Failed to load disease info');
  }
}
