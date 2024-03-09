import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_book_lib/screens/waqia_details.dart';

class WaqiasScreen extends StatefulWidget {
  const WaqiasScreen({super.key});

  @override
  State<WaqiasScreen> createState() => _WaqiasScreenState();
}

class _WaqiasScreenState extends State<WaqiasScreen> {
  late Future<List<dynamic>> _getWaqias;
  String apiUrl =
      'https://mohammad-hossain-saddy.github.io/api_host/waqia.json';

  @override
  void initState() {
    super.initState();
    _getWaqias = getWaqias();
  }

  Future<List<dynamic>> getWaqias() async {
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception(
          'Failed to load data. ${response.statusCode}\n${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dilchasp Waqia'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _getWaqias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            List<dynamic> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final waqia = items[index];
                return Card(
                  elevation: 4,
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WaqiaDetails(
                            waqia: waqia['waqia'],
                            title: waqia['title'],
                            hawala: waqia['hawala'],
                          ),
                        ),
                      );
                    },
                    title: Text(
                      waqia['title'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade600,
                      child: const Icon(Icons.circle_outlined),
                    ),
                    trailing: const Icon(Icons.arrow_right_alt),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
