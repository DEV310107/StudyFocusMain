import 'package:flutter/material.dart';
import 'dart:async';

class Cronometro extends StatefulWidget {
  const Cronometro({super.key});

  @override
  State<Cronometro> createState() => _CronometroState();
}

enum CronometroModo { estudo, pausa }

class _CronometroState extends State<Cronometro> {
  Timer? _timer;
  int _seconds = 0;
  bool _isRunning = false;
  CronometroModo _modo = CronometroModo.estudo;

  static const int _tempoEstudo = 10 ; 
  static const int _tempoPausa = 15 ; 

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (_isRunning) return;
    _isRunning = true;

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;

        int limite = _modo == CronometroModo.estudo ? _tempoEstudo : _tempoPausa;

        if (_seconds >= limite) {
          _seconds = 0;
          _modo = _modo == CronometroModo.estudo ? CronometroModo.pausa : CronometroModo.estudo;
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _seconds = 0;
      _modo = CronometroModo.estudo;
    });
  }

  String _formatTime(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    final hStr = hours.toString().padLeft(2, '0');
    final mStr = minutes.toString().padLeft(2, '0');
    final sStr = seconds.toString().padLeft(2, '0');

    return '$hStr:$mStr:$sStr';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('StudyFocus'),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          constraints: BoxConstraints(maxWidth: width > 500 ? 500 : width * 0.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _modo == CronometroModo.estudo ? 'Estudo' : 'Pausa',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: _modo == CronometroModo.estudo ? Colors.green : Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _formatTime(_seconds),
                style: const TextStyle(
                  fontSize: 70,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Wrap(
                spacing: 20,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                    label: Text(_isRunning ? 'Parar' : 'Iniciar'),
                    onPressed: () {
                      if (_isRunning) {
                        _stopTimer();
                      } else {
                        _startTimer();
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Zerar'),
                    onPressed: _resetTimer,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
