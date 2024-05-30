import 'package:flutter/material.dart';

class PopupMessage {
  final String noti;

  PopupMessage(this.noti);

  void showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Notice',
            style: TextStyle(
              fontSize: 15,
            ),
          ),
          content: Text(
            noti,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
