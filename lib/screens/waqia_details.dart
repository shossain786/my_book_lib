import 'package:flutter/material.dart';

class WaqiaDetails extends StatelessWidget {
  final String title;
  final String waqia;
  final String hawala;

  const WaqiaDetails(
      {super.key,
      required this.title,
      required this.waqia,
      required this.hawala});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waqia Details'),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 2,
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Divider(height: 4),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 6, top: 2, right: 6, bottom: 2),
                    child: Text(
                      waqia,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 72, 45, 4),
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(height: 4),
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 6,
                  ),
                  child: Text(
                    hawala,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange.shade900,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const Divider(height: 4),
            ],
          ),
        ),
      ),
    );
  }
}
