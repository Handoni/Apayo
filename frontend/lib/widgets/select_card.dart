import 'package:flutter/material.dart';

class SelectCard extends StatefulWidget {
  final String content;
  const SelectCard({
    super.key,
    required this.content, // 항목 내용
  });

  @override
  State<SelectCard> createState() => SelectCardState();
}

const greybackground = Color(0xffD9D9D9);
const _invertedColor = Color(0xffC2F7C1);

class SelectCardState extends State<SelectCard> {
  bool _isInverted = false; // 선지를 선택했을 때.

  void toggleInvert() {
    setState(() {
      _isInverted = !_isInverted; // isInverted 상태를 토글 (선택 상태 표시)
    });
  }

  Map<String, String> getFinalSelect() {
    return {widget.content: _isInverted ? "yes" : "no"};
  }

  // 위젯의 빌드 메서드를 오버라이드합니다.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleInvert, // 카드 탭 시 _toggleInvert 함수 호출
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          // 카드의 색상은 isInverted가 true일 때(마우스 선택)는 연두, 아니면 _blackColor 사용
          color: _isInverted ? _invertedColor : greybackground,
          // 카드 모서리를 둥글게 처리
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          // 카드 내부의 패딩 설정
          padding: const EdgeInsets.all(30),
          child: Column(
            // 세로축 기준으로 텍스트를 왼쪽 정렬
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 항목 내용 표시
              Text(
                widget.content,
                style: const TextStyle(
                  // 스타일 조건부 적용
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
