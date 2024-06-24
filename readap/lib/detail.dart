import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readap/profile.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Detail extends StatefulWidget {
  final String title;
  final String content;

  Detail({required this.title, required this.content});

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late FlutterTts flutterTts;
  bool isPlaying = false;
  List<String> textChunks = [];
  int currentChunkIndex = 0;

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _initializeTts();
  }

  void _initializeTts() {
    flutterTts.setStartHandler(() {
      setState(() {
        isPlaying = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
      _speakNextChunk();
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        isPlaying = false;
      });
      print("Error: $msg");
    });

    _setLanguage();
    textChunks = _splitTextIntoChunks(widget.content, 400);
  }

  Future<void> _setLanguage() async {
    try {
      var languages = await flutterTts.getLanguages;
      print("Available languages: $languages");

      if (languages.contains("es-US")) {
        await flutterTts.setLanguage("es-US");
        print("Language set to Spanish");
      } else {
        print("Spanish language not supported on this device.");
      }
    } catch (e) {
      print("Error setting language: $e");
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    super.dispose();
  }

  Future<void> _speakNextChunk() async {
    if (currentChunkIndex < textChunks.length) {
      try {
        await flutterTts.setVolume(0.8); 
        await flutterTts.setSpeechRate(0.4); 
        await flutterTts.setPitch(1.2);

        var result = await flutterTts.speak(textChunks[currentChunkIndex]);
        print("Speak result: $result");
        if (result == 1) {
          setState(() {
            isPlaying = true;
            currentChunkIndex++;
          });
        }
      } catch (e) {
        print("Error in _speakNextChunk: $e");
      }
    }
  }

  Future<void> _speak(String text) async {
    currentChunkIndex = 0;
    await _speakNextChunk();
  }

  Future<void> _stop() async {
    try {
      var result = await flutterTts.stop();
      print("Stop result: $result");
      if (result == 1) setState(() => isPlaying = false);
    } catch (e) {
      print("Error in _stop: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> pages = _paginateContent(widget.content, 1002);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF8D5EB2),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.title,
          style: GoogleFonts.lato(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
            onPressed: () {
              if (isPlaying) {
                _stop();
              } else {
                _speak(widget.content);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Text(
                    pages[index],
                    style: GoogleFonts.lato(fontSize: 20),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pop(context);
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Leer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: Color(0xFF8D5EB2),
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  List<String> _paginateContent(String content, int pageLength) {
    List<String> pages = [];
    for (int i = 0; i < content.length; i += pageLength) {
      pages.add(content.substring(i, i + pageLength > content.length ? content.length : i + pageLength));
    }
    return pages;
  }

  List<String> _splitTextIntoChunks(String text, int chunkSize) {
    List<String> chunks = [];
    for (int i = 0; i < text.length; i += chunkSize) {
      chunks.add(text.substring(i, i + chunkSize > text.length ? text.length : i + chunkSize));
    }
    return chunks;
  }
}