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
      finalDisease: json['final_disease'],
    );
  }
}

// API 호출 함수
Future<List<ResultInfo>> fetchResultListInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userid');

  print("token is $userToken");

  if (userToken == null) {
    throw Exception('No user id found in SharedPreferences');
  }

  final response = await http.get(
    Uri.parse('http://52.79.91.82/sessions/$userToken'),
    headers: {
      'Authorization': 'Bearer $userToken',
    },
  );

  if (response.statusCode == 200) {
    List jsonResponse = json.decode(response.body);
    return jsonResponse.map((data) => ResultInfo.fromJson(data)).toList();
  } else {
    throw Exception('Failed to load disease info');
  }
}
