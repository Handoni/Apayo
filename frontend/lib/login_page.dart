import 'package:flutter/material.dart';
import 'package:frontend/gptchat.dart';


import 'package:frontend/signUp_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //넓이
    double screenHeight = MediaQuery.of(context).size.height; //높이 가져옴

    // 화면 크기에 따라 폰트 크기와 패딩을 동적으로 설정

    double fontSize = screenWidth < 800 ? 18 : 18;
    double paddingSize = screenWidth < 800 ? 20 : 50;
    double formFieldWidth =
        screenWidth < 800 ? screenWidth * 0.8 : screenWidth * 0.3;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'KIM MINSEO',
              style: TextStyle(
                color: Color.fromARGB(255, 94, 94, 94),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),

            ),
            SizedBox(width: 10),
            Text(
              '          RYU SOOJUNG         LEE SANGYUN         HYUN SOYOUNG',
              style: TextStyle(
                color: Color.fromARGB(255, 94, 94, 94),
                fontSize: 10,
              ),
            ),
            Spacer(), // 로고 오른쪽 이동
            Image(
              image: AssetImage('assets/logo.png'),
              width: 50,
              height: 50,
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 70,
        titleSpacing: 0,
      ), // 앱바 *************************************************
      backgroundColor: const Color(0xFFF1F1F1),
      body: SingleChildScrollView(
        // SingleChildScrollView 추가
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: formFieldWidth, // 폼 필드 동적 조절
                    child: Container(
                      padding: EdgeInsets.all(paddingSize), // 패딩 동적 조절
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20), // 박스 각도 추가
                      ),

                      //height: screenHeight * 0.7, //박스크기
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Log In APAYO",
                            style: TextStyle(
                                fontSize: fontSize * 1.4,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          //유저이름 *********************************
                          SizedBox(height: screenHeight * 0.06),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'User Name',
                            ),
                            obscureText: false,
                          ),
                          //비번 *************************************
                          SizedBox(height: screenHeight * 0.04),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true, // 비번 가리기
                          ),
                          // 로그인 버튼 *******************************
                          SizedBox(height: screenHeight * 0.06),
                          SizedBox(
                            width: formFieldWidth,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const GptPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 55, 207, 207),
                                fixedSize: const Size.fromHeight(50),
                              ),
                              child: Text(
                                'Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
                          ),

                          // or 사진 *************************************

                          SizedBox(height: screenHeight * 0.02),
                          Image.asset(
                            'assets/or.png',
                            width: 300,
                            height: 40,
                          ),

                          //read policy***************************************
                          SizedBox(height: screenHeight * 0.02),
                          TextButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                              ),
                              child: const Text(
                                "Click here to read APAYO's policy",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w100,
                                ),
                              )),

                          // 회원가입 버튼 ******************************
                          SizedBox(height: screenHeight * 0.03),
                          Container(
                            width: formFieldWidth,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpPage(),
                                  ),
                                );

                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  fixedSize: const Size.fromHeight(50),
                                  side: const BorderSide(
                                      color: Colors.black, width: 0.1),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: Text(
                                "don't have account? Sign Up",
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),

                                  fontSize: fontSize * 0.7,

                                  fontWeight: FontWeight.w200,
                                  //decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), // 컨테이너 높이 동적 조절
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.9), // 이미지 상단 간격 조정
            MediaQuery.of(context).size.width >= 600
                ? Expanded(
                    child: Center(
                      child: Visibility(
                        visible: MediaQuery.of(context).size.width >= 400,
                        child: Image.asset(
                          'assets/loginPagePic.png',
                          width: 650,
                          height: 650,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ), // SingleChildScrollView 닫기
    );
  }
}
