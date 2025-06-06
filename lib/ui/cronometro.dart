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

  int _tempoEstudoMin = 1;
  int _tempoPausaMin = 1;

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

        int limite = (_modo == CronometroModo.estudo ? _tempoEstudoMin : _tempoPausaMin) * 60;

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
    setState(() => _isRunning = false);
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
    final isEstudo = _modo == CronometroModo.estudo;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('StudyFocus'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: BoxConstraints(maxWidth: width > 500 ? 500 : width * 0.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEstudo ? 'Modo Estudo' : 'Modo Pausa',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: isEstudo ? Colors.greenAccent : Colors.lightBlueAccent,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _formatTime(_seconds),
                style: const TextStyle(
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              _inputCampo("Tempo de Estudo (min)", _tempoEstudoMin.toString(), (value) {
                final v = int.tryParse(value);
                if (v != null && v > 0) setState(() => _tempoEstudoMin = v);
              }),
              const SizedBox(height: 16),
              _inputCampo("Tempo de Pausa (min)", _tempoPausaMin.toString(), (value) {
                final v = int.tryParse(value);
                if (v != null && v > 0) setState(() => _tempoPausaMin = v);
              }),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(_isRunning ? Icons.pause_circle : Icons.play_circle),
                    label: Text(_isRunning ? 'Pausar' : 'Iniciar'),
                    onPressed: () {
                      _isRunning ? _stopTimer() : _startTimer();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.refresh),
                    label: const Text('Zerar'),
                    onPressed: _resetTimer,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputCampo(String label, String valorInicial, void Function(String) onChange) {
    return TextField(
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.deepPurpleAccent),
        ),
      ),
      onChanged: onChange,
    );
  }
}
