import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> viewedItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        final QuerySnapshot snapshot = await _firestore
            .collection('history')
            .where('userId', isEqualTo: user.uid)
            .orderBy('timestamp', descending: true)
            .get();

        setState(() {
          viewedItems = snapshot.docs.map((doc) {
            return {
              'title': doc['title'],
              'date': (doc['timestamp'] as Timestamp).toDate().toString(),
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('User not logged in');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error occurred while fetching history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Histórico', style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
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