import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ResultlistDetail extends StatefulWidget {
  final String sessionId;
  final String finalDisease;

  const ResultlistDetail(
      {super.key, required this.sessionId, required this.finalDisease});

  @override
  State<ResultlistDetail> createState() => ResultlistDetailState();
}

class ResultlistDetailState extends State<ResultlistDetail> {
  late Future<Map<String, dynamic>> _sessionDetails;

  @override
  void initState() {
    super.initState();
    _sessionDetails = fetchSessionDetails(widget.sessionId);
  }

  Future<Map<String, dynamic>> fetchSessionDetails(String sessionId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString('access_token');

    if (accessToken == null) {
      throw Exception('No user id found in SharedPreferences');
    }
    final response = await http.get(
      Uri.parse('http://52.79.91.82/api/session/$sessionId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load session details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _sessionDetails,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData) {
          return const Text('No data available');
        } else {
          final sessionData = snapshot.data!;
          return GestureDetector(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                    MediaQuery.of(context).size.width * 0.03),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AutoSizeText(
                    'Session ID: ${widget.sessionId}',
                    maxFontSize: 20,
                    minFontSize: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AutoSizeText(
                    'Final Disease: ${widget.finalDisease}',
                    maxFontSize: 20,
                    minFontSize: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AutoSizeText(
                    'Session Data: ${sessionData['data']}',
                    maxFontSize: 20,
                    minFontSize: 5,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.03,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}