import 'package:flutter/material.dart'; // Importa os widgets visuais do Flutter
import 'dart:async'; // Importa ferramentas para temporizadores (Timer)

class Cronometro extends StatefulWidget { // Define um widget com estado
  const Cronometro({super.key}); // Construtor do widget

  @override
  State<Cronometro> createState() => _CronometroState(); // Cria o estado do widget
}

enum CronometroModo { estudo, pausa } // Enum para controlar o modo atual

class _CronometroState extends State<Cronometro> {
  Timer? _timer; // Timer que controla o cronômetro
  int _seconds = 0; // Segundos contados
  bool _isRunning = false; // Indica se o cronômetro está rodando
  CronometroModo _modo = CronometroModo.estudo; // Modo atual (estudo ou pausa)

  int _tempoEstudoMin = 1; // Tempo de estudo em minutos
  int _tempoPausaMin = 1; // Tempo de pausa em minutos

  @override
  void dispose() { // Método chamado ao destruir o widget
    _timer?.cancel(); // Cancela o timer se ele estiver ativo
    super.dispose(); // Chama o dispose da superclasse
  }

  void _startTimer() { // Inicia o cronômetro
    if (_isRunning) return; // Evita iniciar se já estiver rodando
    _isRunning = true; // Marca como rodando

    _timer = Timer.periodic(const Duration(seconds: 1), (_) { // Executa a cada 1 segundo
      setState(() {
        _seconds++; // Incrementa os segundos

        int limite = (_modo == CronometroModo.estudo ? _tempoEstudoMin : _tempoPausaMin) * 60; // Define o tempo limite

        if (_seconds >= limite) { // Se passou o tempo limite
          _seconds = 0; // Zera o contador
          _modo = _modo == CronometroModo.estudo ? CronometroModo.pausa : CronometroModo.estudo; // Alterna o modo
        }
      });
    });
  }

  void _stopTimer() { // Para o cronômetro
    _timer?.cancel(); // Cancela o timer
    _timer = null; // Remove referência
    setState(() => _isRunning = false); // Atualiza o estado
  }

  void _resetTimer() { // Reseta o cronômetro
    _stopTimer(); // Para o timer
    setState(() {
      _seconds = 0; // Zera os segundos
      _modo = CronometroModo.estudo; // Volta para modo estudo
    });
  }

  String _formatTime(int totalSeconds) { // Formata os segundos em HH:MM:SS
    final hours = totalSeconds ~/ 3600; // Calcula as horas
    final minutes = (totalSeconds % 3600) ~/ 60; // Calcula os minutos
    final seconds = totalSeconds % 60; // Calcula os segundos

    final hStr = hours.toString().padLeft(2, '0'); // Formata horas
    final mStr = minutes.toString().padLeft(2, '0'); // Formata minutos
    final sStr = seconds.toString().padLeft(2, '0'); // Formata segundos

    return '$hStr:$mStr:$sStr'; // Retorna o tempo formatado
  }

  @override
  Widget build(BuildContext context) { // Constrói a interface
    final width = MediaQuery.of(context).size.width; // Obtém a largura da tela
    final isEstudo = _modo == CronometroModo.estudo; // Verifica se está no modo estudo

    return Scaffold( // Estrutura básica da tela
      backgroundColor: const Color(0xFF121212), // Cor de fundo escura
      appBar: AppBar( // Barra superior
        title: const Text('StudyFocus'), // Título
        backgroundColor: Colors.black, // Fundo da AppBar
        foregroundColor: Colors.white, // Cor do texto
        centerTitle: true, // Centraliza o título
      ),
      body: Center( // Centraliza o conteúdo
        child: Container( // Container com padding
          padding: const EdgeInsets.all(24), // Espaçamento interno
          constraints: BoxConstraints(maxWidth: width > 500 ? 500 : width * 0.9), // Largura máxima
          child: Column( // Organiza os widgets em coluna
            mainAxisAlignment: MainAxisAlignment.center, // Centraliza verticalmente
            children: [
              Text( // Texto do modo atual
                isEstudo ? 'Modo Estudo' : 'Modo Pausa', // Mostra o modo
                style: TextStyle(
                  fontSize: 28, // Tamanho da fonte
                  fontWeight: FontWeight.w600, // Peso da fonte
                  color: isEstudo ? Colors.greenAccent : Colors.lightBlueAccent, // Cor condicional
                ),
              ),
              const SizedBox(height: 20), // Espaço vertical
              Text( // Texto do tempo
                _formatTime(_seconds), // Tempo formatado
                style: const TextStyle(
                  fontSize: 60, // Tamanho grande
                  fontWeight: FontWeight.bold, // Negrito
                  color: Colors.white, // Branco
                ),
              ),
              const SizedBox(height: 30), // Espaço vertical
              _inputCampo("Tempo de Estudo (min)", _tempoEstudoMin.toString(), (value) { // Campo de input estudo
                final v = int.tryParse(value); // Converte string para int
                if (v != null && v > 0) setState(() => _tempoEstudoMin = v); // Atualiza se válido
              }),
              const SizedBox(height: 16), // Espaço vertical
              _inputCampo("Tempo de Pausa (min)", _tempoPausaMin.toString(), (value) { // Campo de input pausa
                final v = int.tryParse(value); // Converte string para int
                if (v != null && v > 0) setState(() => _tempoPausaMin = v); // Atualiza se válido
              }),
              const SizedBox(height: 32), // Espaço vertical
              Wrap( // Organiza os botões lado a lado
                spacing: 16, // Espaçamento entre eles
                children: [
                  ElevatedButton.icon( // Botão iniciar/pausar
                    icon: Icon(_isRunning ? Icons.pause_circle : Icons.play_circle), // Ícone condicional
                    label: Text(_isRunning ? 'Pausar' : 'Iniciar'), // Texto condicional
                    onPressed: () { // Ação do botão
                      _isRunning ? _stopTimer() : _startTimer(); // Alterna ação
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, // Cor do botão
                      foregroundColor: Colors.white, // Cor do texto/ícone
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding interno
                      textStyle: const TextStyle(fontSize: 18), // Tamanho da fonte
                    ),
                  ),
                  ElevatedButton.icon( // Botão de reset
                    icon: const Icon(Icons.refresh), // Ícone de reset
                    label: const Text('Zerar'), // Texto do botão
                    onPressed: _resetTimer, // Função de reset
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Cor vermelha
                      foregroundColor: Colors.white, // Cor do texto
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Padding
                      textStyle: const TextStyle(fontSize: 18), // Fonte
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

  Widget _inputCampo(String label, String valorInicial, void Function(String) onChange) { // Cria campo de entrada
    return TextField(
      style: const TextStyle(color: Colors.white), // Cor do texto
      keyboardType: TextInputType.number, // Tipo número
      decoration: InputDecoration(
        labelText: label, // Rótulo do campo
        labelStyle: const TextStyle(color: Colors.white70), // Cor do rótulo
        filled: true, // Fundo preenchido
        fillColor: const Color(0xFF1E1E1E), // Cor do fundo
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), // Borda arredondada
        focusedBorder: OutlineInputBorder( // Borda ao focar
          borderRadius: BorderRadius.circular(12), // Arredondamento
          borderSide: const BorderSide(color: Colors.deepPurpleAccent), // Cor da borda
        ),
      ),
      onChanged: onChange, // Função ao mudar o valor
    );
  }
}