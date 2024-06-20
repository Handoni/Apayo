import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:frontend/google_map.dart';

class ResultCard extends StatelessWidget {
  final String disease, description, dept;
  final int n;

  void _onMapPressed(BuildContext context) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => MapScreen(dept: dept)));
  }

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
          AutoSizeText(
            '    진단 결과를 알려드릴게요!',
            maxFontSize: 18,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.03,
              fontWeight: FontWeight.bold,
            ),
          ),
          AutoSizeText(
            '        \n(병원에 방문하실 때 참고해보세요)',
            maxFontSize: 18,
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.02,
            ),
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
          ),
          const SizedBox(
            height: 10,
          ),
          AutoSizeText(
            '이 서비스는 단순 참고용으로, 반드시 병원을 내원해 의사의 진단에 따르시길 바랍니다.',
            maxFontSize: 15,
            minFontSize: 5,
            style: TextStyle(
              color: Colors.black54,
              fontSize: MediaQuery.of(context).size.width * 0.02,
            ),
          ),
          InkWell(
            onTap: () => _onMapPressed(context),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/map.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // 반투명 검정색 오버레이
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(200, 255, 255, 255),
                      border: Border.all(
                          color: Color.fromARGB(200, 255, 255, 255),
                          width: 0.0),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Text(
                      '내 주변에 있는 $dept 찾아보기',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
