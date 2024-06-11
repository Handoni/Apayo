import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Resultlist extends StatefulWidget {
  const Resultlist({super.key});

  @override
  State<Resultlist> createState() => ResultlistState();
}

const greybackground = Color(0xffD9D9D9);

class ResultlistState extends State<Resultlist> {
  // 위젯의 빌드 메서드를 오버라이드합니다.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //onTap: widget.toggleInvert, // 카드 탭 시 _toggleInvert 함수 호출
      child: Container(
        decoration: BoxDecoration(
          // 카드 모서리를 둥글게 처리
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.03),
        ),
        child: Column(
          // 세로축 기준으로 텍스트를 왼쪽 정렬
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 항목 내용 표시
            AutoSizeText(
              '',
              maxFontSize: 20,
              minFontSize: 5,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width * 0.03,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
