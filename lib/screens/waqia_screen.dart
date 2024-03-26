// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_book_lib/main.dart';
import 'package:my_book_lib/screens/waqia_json_details.dart';

class WaqiasScreen extends StatefulWidget {
  const WaqiasScreen({Key? key}) : super(key: key);

  @override
  _WaqiasScreenState createState() => _WaqiasScreenState();
}

class _WaqiasScreenState extends State<WaqiasScreen> {
  late Future<List<dynamic>> _getWaqias;

  @override
  void initState() {
    super.initState();
    _getWaqias = getWaqias();
  }

  Future<List<dynamic>> getWaqias() async {
    String jsonString =
        await rootBundle.loadString('assets/json_files/waqia.json');
    List<dynamic> data = jsonDecode(jsonString);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Dilchasp Waqiat'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _getWaqias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<dynamic> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final waqia = items[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2),
                  child: Card(
                    elevation: 5.0,
                    color: kColorScheme.onPrimaryContainer,
                    shadowColor: Colors.yellowAccent,
                    child: ListTile(
                      trailing: const Icon(
                        Icons.arrow_circle_right,
                        color: Colors.yellowAccent,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WaqiaDetailsScreen(
                              title: waqia['title'],
                              urdu: waqia['urdu'],
                              waqia: waqia['waqia'],
                              hawala: waqia['hawala'],
                            ),
                          ),
                        );
                      },
                      title: Text(
                        waqia['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kColorScheme.onPrimary,
                        ),
                      ),
                      subtitle: Text(
                        waqia['urdu'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kColorScheme.onPrimary,
                        ),
                      ),
                      leading: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.yellowAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/wqa.jpeg',
                            width: 50,
                            height: 50,
                          ),
                        ),
                      ),
                    ),
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
