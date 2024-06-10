import 'package:flutter/material.dart';
import 'home_page_reactive/homepage_desktop.dart';
import 'home_page_reactive/homepage_mobile.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Text(
              'APAYO TEAM 6',
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
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 70,
        titleSpacing: 50, //앱바 왼쪽 간격추가
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const AssetImage('assets/background_image.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.7),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Center(
            child: LayoutBuilder(builder: (context, constraints) {
              if (constraints.maxWidth < 600) {
                return const MobileLayout();
              } else {
                return const DesktopLayout();
              }
            }),
          ),
        ],
      ),
    );
  }
}
