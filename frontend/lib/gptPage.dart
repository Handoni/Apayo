import 'package:flutter/material.dart';

class GptPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPT Page'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: '어떤 증상이 있으신가요?',
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // 확인 버튼을 눌렀을 때 처리해야 할 로직 추가
              },
              child: Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
