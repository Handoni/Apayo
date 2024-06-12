import 'package:flutter_secure_storage/flutter_secure_storage.dart'; // 추가
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  const FlutterSecureStorage secureStorage =
      FlutterSecureStorage(); // SecureStorage 인스턴스 생성
  String? accessToken =
      await secureStorage.read(key: 'access_token'); // SecureStorage에서 토큰 로드

  if (accessToken == null) {
    throw Exception('Access token not found');
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
      List<ResultInfo> results = sessions
          .where((data) => data != null && data is Map<String, dynamic>)
          .map((data) => ResultInfo.fromJson(data as Map<String, dynamic>))
          .toList();
      return results;
    } else {
      throw Exception('Unexpected format: sessions is not a list');
    }
  } else {
    throw Exception('Failed to load session information');
  }
}
