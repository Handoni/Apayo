import 'package:flutter/material.dart';
import 'package:frontend/login_page.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

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
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
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
                    //width: formFieldWidth, // 폼 필드 동적 조절
                    child: Container(
                      padding: EdgeInsets.all(paddingSize * 1.9), // 패딩 동적 조절
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      height: screenHeight, //* 0.7, //박스크기
                      //***************************************************
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SignUp APAYO",
                            style: TextStyle(
                                fontSize: fontSize * 1.3, color: Colors.black),
                          ),
                          //*******************************************
                          Text(
                            "Sign Up APAYO free to access",
                            style: TextStyle(
                                fontSize: fontSize * 0.7,
                                color: Colors.grey,
                                fontWeight: FontWeight.w100),
                          ),
                          //유저이름 *********************************
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'User Name',
                            ),
                            obscureText: false,
                          ),

                          //비번 *************************************
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true, // 비번 가리기
                          ),

                          //생일***************************************
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Age',
                            ),
                          ),

                          //성별***********************************
                          SizedBox(height: screenHeight * 0.02),
                          DropdownButtonFormField<String>(
                            value: 'Male',
                            onChanged: (String? newValue) {},
                            items: <String>['Male', 'Female']
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

                          // 회원가입 버튼 *******************************
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: formFieldWidth * 0.5,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 55, 207, 207),
                                fixedSize: const Size.fromHeight(50),
                              ),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: fontSize,
                                    fontWeight: FontWeight.w200),
                              ),
                            ),
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
                                "Already have an account? Login",
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w100,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //SizedBox(height: screenHeight), // 이미지 상단 간격 조정
            MediaQuery.of(context).size.width >= 600
                ? Expanded(
                    child: Center(
                      child: Visibility(
                          visible: MediaQuery.of(context).size.width >= 400,
                          child: Image.asset(
                            'assets/signUpPagePic.png',
                          )),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ), // SingleChildScrollView 닫기
    );
  }
}
