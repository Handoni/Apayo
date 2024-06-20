import 'package:http/http.dart' as http;

class AuthService {
  Future<bool> verifyTokenWithServer(String token) async {
    try {
      var response = await http.get(
        Uri.parse('https://apayo.kro.kr/api/users/me/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      print('auth : ${response.statusCode}');
      bool auth = true;
      if (response.statusCode == 200) {
        auth = true;
      } else {
        auth = false;
      }

      return auth;
    } catch (e) {
      print('Error verifying token: $e');
      return false;
    }
  }
}
