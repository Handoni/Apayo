import 'package:flutter/material.dart';

class GptPage extends StatefulWidget {
  const GptPage({super.key});

  @override
  State<GptPage> createState() => _GptPageState();
}

class _GptPageState extends State<GptPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xff9FA9D8),
                ),
                child: const Column(// 채팅 기록
                    ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/logo.png'),
                    colorFilter:
                        ColorFilter.mode(Colors.white24, BlendMode.dstATop),
                    fit: BoxFit.contain,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 7,
                        child: SingleChildScrollView(
                          child: Column(
                            // 채팅창 내용
                            children: [],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1, // 검색바
                        child: Center(
                            child: TextField(
                          decoration: InputDecoration(
                            hintText: '어떤 증상을 겪고 계신가요?',
                            labelStyle: TextStyle(color: Color(0xff9FA9D8)),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xff9FA9D8)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  width: 1, color: Color(0xff9FA9D8)),
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                        )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
