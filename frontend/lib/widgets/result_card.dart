import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

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
          Row(
            children: [
              AutoSizeText(
                '    진단 결과를 알려드릴게요!',
                maxFontSize: 18,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
              AutoSizeText(
                '  (병원에 방문하실 때 참고해보세요)',
                maxFontSize: 18,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.02,
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
                  AutoSizeText(
                    '예상 질병이나 증상 : $disease\n',
                    maxFontSize: 20,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                    ),
                  ),
                  AutoSizeText(
                    '$description\n',
                    maxFontSize: 18,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.02),
                  ),
                  AutoSizeText(
                    '추천 진료과 : $dept',
                    maxFontSize: 18,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.02,
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
