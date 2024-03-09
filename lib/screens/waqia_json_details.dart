import 'package:flutter/material.dart';

class WaqiaDetailsScreen extends StatelessWidget {
  final String title;
  final String urdu;
  final String waqia;
  final String hawala;

  const WaqiaDetailsScreen({
    required this.title,
    required this.urdu,
    required this.waqia,
    required this.hawala,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SingleChildScrollView(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          color: Color.fromARGB(255, 81, 26, 0),
                        ),
                      ),
                      Text(
                        urdu,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Color.fromARGB(255, 81, 26, 0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Divider(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'بِسْمِ ٱللّٰهِ الرَّحْمٰنِ الرَّحِيْمِ',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 81, 26, 0),
                      ),
                    ),
                  ],
                ),
                Text(
                  waqia,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Color.fromARGB(255, 230, 76, 5),
                  ),
                ),
                const Divider(height: 10),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Hawala: $hawala',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 81, 26, 0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
