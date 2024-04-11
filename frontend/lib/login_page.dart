import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //앱바 **********************************************
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
          Spacer(), //로고 오른쪽 이동
          Image(
            image: AssetImage('assets/logo.png'),
            width: 50,
            height: 50,
          )
        ],
      ),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      toolbarHeight: 70,
      titleSpacing: 0, //앱바 왼쪽 간격 x
      //여기까지가 앱바 **********************************************
    ));
  }
}
