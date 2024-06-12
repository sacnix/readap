import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class History extends StatelessWidget {
  final List<Map<String, String>> viewedItems = [
    {'title': 'Legend of White Snake', 'date': '2023-10-01'},
    {'title': 'Another Story', 'date': '2023-10-02'},
    {'title': 'Yet Another Story', 'date': '2023-10-03'},
    {'title': 'More Stories', 'date': '2023-10-04'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:
            Text('Histórico', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: ListView.builder(
        itemCount: viewedItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              viewedItems[index]['title']!,
              style: GoogleFonts.lato(fontSize: 16),
            ),
            subtitle: Text(
              viewedItems[index]['date']!,
              style: GoogleFonts.lato(fontSize: 14),
            ),
          );
        },
      ),
    );
  }
}
