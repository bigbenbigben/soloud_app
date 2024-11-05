import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimerPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  late Timer _timer;
  int _seconds = 0;
  bool _isRunning = false;

  Color get _startButtonColor => _isRunning ? Colors.blue[700]! : Colors.blue[300]!;

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true; // タイマーが動いている状態に設定
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false; // タイマーが止まっている状態に設定
      });
    }
  }

  void _resetTimer() {
    _stopTimer(); // 停止してからリセット
    setState(() {
      _seconds = 0; // 秒数をリセット
    });
  }

  String _formatTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _formatTime(_seconds),
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: Text('STOP', style: TextStyle(color: Colors.white)), // 文字色を白に
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(), // 正方形にするために修正
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.blue[700], // STOPボタンの色
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text('START', style: TextStyle(color: Colors.white)), // 文字色を白に
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(24),
                    backgroundColor: _startButtonColor, // STARTボタンの色を動的に決定
                  ),
                ),
              ],
            ),
            SizedBox(height: 20), // STOPとSTARTの間にスペースを追加
            ElevatedButton(
              onPressed: _resetTimer,
              child: Text('RESET', style: TextStyle(color: Colors.white)), // 文字色を白に
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 角を丸くする
                ),
                padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16), // 長方形のサイズを設定
                backgroundColor: Colors.blue[700], // RESETボタンの色
              ),
            ),
          ],
        ),
      ),
    );
  }
}
