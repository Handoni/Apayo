import 'package:flutter/material.dart';
import 'package:frontend/login_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _selectedGender = '';

  // "Sign Up" 버튼 클릭 시 실행되는 함수
  void signUp(BuildContext context) async {
    String userName = _userNameController.text;
    String password = _passwordController.text;
    int age = int.tryParse(_ageController.text) ?? 0;

    if (userName.isNotEmpty &&
        password.isNotEmpty &&
        age > 0 &&
        _selectedGender != '') {
      Uri url = Uri.parse('메롱메롱메롱메롱');

      Map<String, dynamic> requestBody = {
        'userName': userName,
        'password': password,
        'age': age,
        'gender': _selectedGender,
      };

      try {
        final response = await http.post(
          url,
          body: jsonEncode(requestBody),
          headers: {'Content-Type': 'application/json'},
        );
        //회원가입 성공시 로그인 페이지 이동
        if (response.statusCode == 200) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('회원가입에 실패했습니다.')),
          );
        }
      } catch (e) {
        print('Error during sign up: $e');
        if (e.toString().contains('Duplicate entry')) {
          // 이미 사용 중인 사용자 이름인 경우 에러 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('이미 사용 중인 사용자 이름입니다. 다른 이름을 선택해주세요.')),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('모든 필수 정보를 입력해주세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width; //넓이
    double screenHeight = MediaQuery.of(context).size.height; //높이 가져옴

    // 화면 크기에 따라 폰트 크기와 패딩을 동적으로 설정
    double fontSize = screenWidth < 850 ? 12 : 18;
    double paddingSize = screenWidth < 850 ? 20 : 50;
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
                      padding: EdgeInsets.only(
                        top: paddingSize * 1,
                        left: paddingSize * 3,
                        bottom: paddingSize * 3,
                        right: paddingSize * 3,
                      ), // 패딩 동적 조절
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
                            controller: _userNameController,
                            decoration: const InputDecoration(
                              labelText: 'User Name',
                            ),
                            obscureText: false,
                          ),

                          //비번 *************************************
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            controller: _passwordController,
                            decoration:
                                const InputDecoration(labelText: 'Password'),
                            obscureText: true, // 비번 가리기
                          ),

                          //생일***************************************
                          SizedBox(height: screenHeight * 0.02),
                          TextFormField(
                            controller: _ageController,
                            decoration: const InputDecoration(
                              labelText: 'Age',
                            ),
                          ),

                          //성별***********************************
                          SizedBox(height: screenHeight * 0.02),
                          // 사용자가 선택한 성별을 저장하는 변수
                          DropdownButtonFormField<String>(
                            value: _selectedGender, // 선택된 값
                            onChanged: (String? newValue) {
                              // 사용자가 선택한 값을 저장
                              _selectedGender = newValue!;
                            },
                            items: <String>['', 'Male', 'Female'] // 기본값 추가
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(
                                  value,
                                  style: TextStyle(fontSize: fontSize * 0.7),
                                ),
                              );
                            }).toList(),
                            decoration: const InputDecoration(
                              labelText: 'Gender',
                            ),
                          ),

                          // 회원가입 버튼 *******************************
                          // 회원가입 버튼 *******************************
                          SizedBox(height: screenHeight * 0.02),
                          SizedBox(
                            width: formFieldWidth * 0.5,
                            child: ElevatedButton(
                              onPressed: () => signUp(context), // signUp 함수 호출
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
            MediaQuery.of(context).size.width >= 850
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
