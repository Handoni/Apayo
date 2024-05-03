import 'package:flutter/material.dart';

class SelectCard extends StatefulWidget {
  final String content;
  final int order;

  const SelectCard({
    super.key,
    required this.content, // 항목 내용
    required this.order, // 위젯 배치 순서
  });

  @override
  State<SelectCard> createState() => _SelectCardState();
}

class _SelectCardState extends State<SelectCard> {
  bool _isInverted = false; // 선지를 선택했을 때.

  // 반전되지 않은 텍스트와 요소에 사용될 상수 색상을 정의합니다.
  final greybackground = const Color(0xffD9D9D9);
  final _invertedColor = const Color(0xffC2F7C1);

  void _toggleInvert() {
    setState(() {
      _isInverted = !_isInverted; // isInverted 상태를 토글 (선택 상태 표시)
    });
  }

  // 위젯의 빌드 메서드를 오버라이드합니다.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleInvert, // 카드 탭 시 _toggleInvert 함수 호출
      child: Transform.translate(
        // 카드의 위치를 정렬하기 위해 Transform.translate 사용
        offset: Offset(0, (widget.order - 1) * -20),
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
      ),
    );
  }
}
