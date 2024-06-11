import 'package:flutter/material.dart';
import 'package:frontend/google_map.dart';
import 'package:frontend/login_page.dart';
import 'package:frontend/signUp_page.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key});

  void _onLogInPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  void _onSignUpPressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  void _onGooglePressed(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MapScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 왼쪽부분
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(30.0),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, //정렬
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: AssetImage('assets/logo.png'),
                    width: 500,
                    height: 250,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'APAYO 에게 어디가 어떻게 아픈지 말해보세요! \n몸에 문제가 생긴건 아닌지 불안하신가요? APAYO가 찾아볼게요!',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w200),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // 오른쪽 부분
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () => _onLogInPressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 55, 207, 207),
                      minimumSize: const Size(120, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _onSignUpPressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 55, 207, 207),
                      minimumSize: const Size(120, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => _onGooglePressed(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 55, 207, 207),
                      minimumSize: const Size(120, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('구글맵 임시 버튼'),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
