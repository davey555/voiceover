import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:highlight_text/highlight_text.dart';

//TODO: ADD MORE FEATURES TO IT LIKE THIS
//TODO: ADD A BEAUTIFUL UI
//TODO:ADD A PLACE TO HIGHLIGHT TEXT YOU WANT EMPHASIZED
//TODO: ADD A BUSINESS LOGIC WHERE IT SAVES YOUR CONVERSATION IN A FILE IN YOUR PHONE
//TODO: ADD A RECORDED AUDIO SECTION WHERE YOU CAN PLAY OLD AUDIOS YOU RECORDED AND ALSO THE NOTES ASSOCIATED WITH IT

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Voice(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Voice extends StatefulWidget {
  @override
  VoiceState createState() => VoiceState();
}

class VoiceState extends State<Voice> {
  final Map<String, HighlightedWord> _highlights = {
    'Coding': HighlightedWord(
        onTap: () {},
        textStyle: TextStyle(
          color: Colors.green,
          fontSize: 45,
          fontWeight: FontWeight.bold,
        )),
    'David': HighlightedWord(
        onTap: () {},
        textStyle: TextStyle(
          color: Colors.blue,
          fontSize: 45,
          fontWeight: FontWeight.bold,
        )),
    'President': HighlightedWord(
        onTap: () {},
        textStyle: TextStyle(
            color: Colors.indigo,
            fontSize: 45,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic)),
  };
  stt.SpeechToText _speech;
  bool _isListening = true;
  String _text = 'Press The button to Start talking';
  double confidence = 1.0;
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        leading: Icon(Icons.arrow_back),
        title: Text('Confidence ${(confidence * 100.0).toStringAsFixed(1)}%'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 30, 50, 150),
          child: TextHighlight(
              text: _text,
              words: _highlights,
              textStyle: TextStyle(
                fontSize: 32,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              )),
        ),
      ),
      floatingActionButton: AvatarGlow(
          animate: _isListening,
          glowColor: Colors.redAccent,
          endRadius: 75,
          duration: const Duration(milliseconds: 2900),
          repeatPauseDuration: const Duration(milliseconds: 100),
          repeat: true,
          child: FloatingActionButton(
              child: Icon(_isListening ? Icons.mic : Icons.mic_none),
              onPressed: _listen)),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print("onError: $val"),
      );
      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                  if (val.hasConfidenceRating && val.confidence > 0) {
                    confidence = val.confidence;
                  }
                }));
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }
}
