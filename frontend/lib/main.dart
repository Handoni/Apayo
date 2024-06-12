import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/auth_service.dart';
import 'package:frontend/gptchat.dart';
import 'home_page.dart';

void main() async {
  const FlutterSecureStorage secureStorage =
      FlutterSecureStorage(); // SecureStorage 인스턴스 생성
  WidgetsFlutterBinding.ensureInitialized(); // 필수: Flutter 엔진 초기화 보장
  String? token = await secureStorage.read(key: 'access_token'); // 토큰을 불러옴

  // AuthService 인스턴스 생성
  AuthService authService = AuthService();
  bool isAuthenticated = true;

  // 토큰이 있을 경우, 서버에 토큰 유효성 검증 요청
  if (token != null) {
    isAuthenticated = await authService.verifyTokenWithServer(token);
  } else {
    // 토큰이 없다면
    isAuthenticated = false;
  }

  // runApp에 전달되는 위젯을 조건에 따라 변경
  runApp(MyApp(isAuthenticated: isAuthenticated));
}

class MyApp extends StatelessWidget {
  final bool isAuthenticated; // 인증 여부를 저장하는 변수
  const MyApp({super.key, required this.isAuthenticated});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Responsive Web App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // 인증 상태에 따라 홈 페이지 또는 로그인 페이지로 라우팅
      home: isAuthenticated ? const GptPage() : const MyHomePage(),
    );
  }
}
