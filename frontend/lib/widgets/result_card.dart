import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String disease, description, dept;
  final int n;

  final greybackground = const Color(0xffD9D9D9);

  const ResultCard({
    super.key,
    required this.disease,
    required this.description,
    required this.dept,
    required this.n,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text(
                '    진단 결과를 알려드릴게요!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '  (병원에 방문하실 때 참고해보세요)',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: greybackground,
              // 카드 모서리를 둥글게 처리
              borderRadius: BorderRadius.circular(25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // 결과
                children: [
                  Text(
                    //'예상 질병 $n 순위 : $disease\n',
                    '예상 질병이나 증상 : $disease\n',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '$description\n',
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text(
                    '추천 진료과 : $dept',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
