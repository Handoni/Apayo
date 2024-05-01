import 'package:flutter/material.dart';
import 'package:frontend/gptchat.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //넓이
    double screenHeight = MediaQuery.of(context).size.height; //높이 가져옴

    // 화면 크기에 따라 폰트 크기와 패딩을 동적으로 설정
    double fontSize = screenWidth < 800 ? 12 : 18;
    double paddingSize = screenWidth < 800 ? 20 : 50;
    double formFieldWidth =
        screenWidth < 600 ? screenWidth * 0.8 : screenWidth * 0.3;

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
                      // height: screenHeight * 0.7, //박스크기
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LogIn APAYO",
                            style: TextStyle(
                                fontSize: fontSize * 1.3, color: Colors.grey),
                          ),
                          //유저이름 *********************************
                          SizedBox(height: screenHeight * 0.01),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'User Name',
                            ),
                          ),

                          //비번 *************************************
                          SizedBox(height: screenHeight * 0.01),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true, // 비번 가리기
                          ),

                          //생일***************************************
                          SizedBox(height: screenHeight * 0.01),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Date of Birth',
                            ),
                          ),

                          //성별***********************************
                          SizedBox(height: screenHeight * 0.01),
                          DropdownButtonFormField<String>(
                            value: 'Male',
                            onChanged: (String? newValue) {},
                            items: <String>['Male', 'Female', 'Other']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value,
                                    style: TextStyle(fontSize: fontSize * 0.7)),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

                          // 로그인 버튼 *******************************
                          SizedBox(height: screenHeight * 0.01),
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
                          SizedBox(height: screenHeight * 0.01),
                          Image.asset(
                            'assets/or.png',
                            width: 300,
                            height: 40,
                          ),

                          // 회원가입 버튼 ******************************
                          Container(
                            width: formFieldWidth,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GptPage(),
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
                                  fontSize: fontSize * 0.6,
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
