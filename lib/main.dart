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
  bool _buttonCooldown = false; // ボタンが押されるのを制御するフラグ

  Color get _startButtonColor {
    if (_buttonCooldown) {
      return _isRunning ? Colors.blue : Colors.blue[100]!; // チャタリング中は色を固定
    }
    return _isRunning ? Colors.blue : Colors.blue[100]!;
  }

  Color get _startTextColor {
    if (_buttonCooldown) {
      return _isRunning ? Colors.white : Colors.blue[900]!; // チャタリング中は色を固定
    }
    return _isRunning ? Colors.white : Colors.blue[900]!;
  }

  void _startTimer() {
    if (_isRunning || _buttonCooldown) return;

    setState(() {
      _isRunning = true;
      _buttonCooldown = true;
    });

    Future.delayed(Duration(milliseconds: 30), () {
      setState(() {
        _buttonCooldown = false;
      });
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void _stopTimer() {
    if (_buttonCooldown) return;

    if (_isRunning) {
      _timer.cancel();
      setState(() {
        _isRunning = false;
        _buttonCooldown = true;
      });

      Future.delayed(Duration(milliseconds: 30), () {
        setState(() {
          _buttonCooldown = false;
        });
      });
    }
  }

  void _resetTimer() {
    if (_buttonCooldown) return;

    _stopTimer();
    setState(() {
      _seconds = 0;
      _buttonCooldown = true;
    });

    Future.delayed(Duration(milliseconds: 30), () {
      setState(() {
        _buttonCooldown = false;
      });
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
              style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _buttonCooldown ? null : _stopTimer,
                  child: Text('STOP', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(),
                    padding: EdgeInsets.all(20),
                    backgroundColor: Colors.blue,
                    side: BorderSide(color: Colors.blue.shade100, width: 2),
                    elevation: 3, // 立体感を追加
                    shadowColor: Colors.blue[900], // 影の色
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _buttonCooldown ? null : _startTimer,
                  child: Text('START', style: TextStyle(color: _startTextColor)),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(24),
                    backgroundColor: _startButtonColor,
                    side: BorderSide(color: Colors.blue.shade900, width: 2),
                    elevation: 3, // 立体感を追加
                    shadowColor: Colors.blue[900], // 影の色
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _buttonCooldown ? null : _resetTimer,
              child: Text('RESET', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: EdgeInsets.symmetric(horizontal: 64, vertical: 16),
                backgroundColor: Colors.blue,
                side: BorderSide(color: Colors.blue.shade100, width: 2),
                elevation: 3, // 立体感を追加
                shadowColor: Colors.blue[900], // 影の色
              ),
            ),
          ],
        ),
      ),
    );
  }
}
