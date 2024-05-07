import 'package:flutter/material.dart';

class SelectCard extends StatefulWidget {
  final String content;
  final bool isInverted;
  final VoidCallback toggleInvert;
  const SelectCard({
    super.key,
    required this.content,
    required this.isInverted,
    required this.toggleInvert,
  });

  @override
  State<SelectCard> createState() => SelectCardState();
}

const greybackground = Color(0xffD9D9D9);
const _invertedColor = Color(0xffC2F7C1);

class SelectCardState extends State<SelectCard> {
  // 위젯의 빌드 메서드를 오버라이드합니다.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.toggleInvert, // 카드 탭 시 _toggleInvert 함수 호출
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          // 카드의 색상은 isInverted가 true일 때(마우스 선택)는 연두, 아니면 _blackColor 사용
          color: widget.isInverted ? _invertedColor : greybackground,
          // 카드 모서리를 둥글게 처리
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          // 카드 내부의 패딩 설정
          padding: const EdgeInsets.all(30),
          child: Column(
            // 세로축 기준으로 텍스트를 왼쪽 정렬
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 항목 내용 표시
              Text(
                widget.content,
                style: const TextStyle(
                  // 스타일 조건부 적용
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
