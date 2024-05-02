import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String disease, description, dept;

  final _blackColor = const Color(0xffD9D9D9);

  const ResultCard({
    super.key,
    required this.disease,
    required this.description,
    required this.dept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // clipBehavior는 어떤 아이템이 overflow가 되었을 때, 카드와 같은 container가 어떻게 동작하게 하는지 알려줌.
      // container의 바깥 부분을 컨트롤
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: _blackColor,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: isInverted ? _blackColor : Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text(
                      amount,
                      style: TextStyle(
                        color: isInverted ? _blackColor : Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        color: isInverted ? _blackColor : Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Transform.scale(
              // 아이콘만 크기 변경 위함 (카드 크기 변화 x)
              scale: 2.2,
              child: Transform.translate(
                offset: const Offset(-5, 12),
                child: Icon(
                  icon,
                  color: isInverted
                      ? _blackColor
                      : const Color.fromARGB(255, 255, 255, 255),
                  size: 88,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
