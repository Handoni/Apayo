// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:frontend/login_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // 추가 구현 필요.
// class AuthenticationService {
//   final FlutterSecureStorage storage = const FlutterSecureStorage();

// // 토큰을 안전하게 저장.
//   Future<void> saveToken(String token) async {
//     await storage.write(key: 'auth_token', value: token);
//   }

// // 저장된 토큰을 로딩.
//   Future<String?> loadToken() async {
//     return await storage.read(key: 'auth_token');
//   }

//   Future<void> checkLoginStatus() async {
//     String? token = await loadToken();
//     if (token != null) {
//       // 토큰 유효성 검증 로직
//       bool isValid = await verifyToken(token);
//       if (isValid) {
//         // 로그인 상태 유지
//       } else {
//         SharedPreferences prefs = await SharedPreferences.getInstance();
//         await prefs.remove('authToken');
//       }
//     } else {
//       // 토큰이 없다면 로그인 페이지로 이동
//     }
//   }

//   Future<void> logout() async {
//     await storage.delete(key: 'auth_token');
//     // 로그아웃 처리 후 로그인 페이지로 이동
//   }
// }
