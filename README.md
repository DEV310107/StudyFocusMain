
# 📘 Documentação do Projeto: **StudyFocus**

## 📝 Descrição
**StudyFocus** é um aplicativo desenvolvido em Flutter com o objetivo de auxiliar os usuários na gestão do tempo de estudos utilizando o método Pomodoro (tempo de estudo seguido por pausas). O usuário pode personalizar a duração dos ciclos e alternar entre "Modo Estudo" e "Modo Pausa".

---

## 📁 Estrutura do Projeto

```
StudyFocus/
│
├── android/            → Projeto Android nativo
├── ios/                → Projeto iOS nativo
├── linux/              → Projeto Linux
├── macos/              → Projeto macOS
├── windows/            → Projeto Windows
├── lib/
│   ├── ui/
│   │   └── cronometro.dart   → Tela principal do cronômetro
│   └── main.dart             → Ponto de entrada do app
├── pubspec.yaml         → Gerenciador de dependências e metadados
├── README.md            → Descrição inicial do projeto
└── .gitignore           → Arquivos ignorados pelo Git
```

---

## 🚀 Como Executar

1. Certifique-se de ter o Flutter instalado.  
2. No terminal, vá até a raiz do projeto e execute:
   ```bash
   flutter pub get
   flutter run
   ```

---

## 📦 Dependências

- `flutter`: SDK principal.
> O projeto não usa nenhuma dependência externa além do Flutter nativo.

---

## 📄 Arquivos Importantes

### `main.dart`

```dart
void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Cronometro(),
    );
  }
}
```
> Ponto de entrada que chama a tela do cronômetro.

---

### `cronometro.dart`

Contém toda a lógica do cronômetro e UI:

- **`CronometroModo`**: Enum para alternar entre estudo e pausa.
- **Estados controlados**: `_seconds`, `_isRunning`, `_tempoEstudoMin`, `_tempoPausaMin`.
- **Funções principais**:
  - `_startTimer()`: Inicia o contador.
  - `_stopTimer()`: Pausa o contador.
  - `_resetTimer()`: Reinicia o tempo e volta para modo estudo.
  - `_formatTime()`: Formata segundos em `hh:mm:ss`.

---

## 🖥️ Funcionalidades

- ⏱️ Cronômetro com contagem regressiva.
- 🔁 Alternância automática entre modos de estudo e pausa.
- 🧠 Personalização do tempo (em minutos).
- 🎨 Interface escura responsiva.
- ✅ Compatível com diferentes tamanhos de tela.

---

## 📌 Conclusão

**StudyFocus** é um app simples, útil e fácil de usar para estudantes que desejam controlar seu tempo de foco. Com poucos arquivos e lógica bem organizada, ele serve como uma excelente base para expandir com mais funcionalidades.
