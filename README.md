# 📄 Briefing do Projeto: StudyFocus

## 🎯 Visão Geral

O **StudyFocus** é um aplicativo Flutter que ajuda o usuário a manter o foco nos estudos, alternando entre períodos de estudo e pausa. Com um design escuro, controles intuitivos e campos de tempo ajustáveis, ele é ideal para estudantes que utilizam técnicas como Pomodoro.

---

![](https://github.com/DEV310107/StudyFocusMain/raw/main/img/img.png)

---

### 🎨 Design do Projeto

O layout da aplicação foi elaborado no Figma, garantindo uma interface intuitiva e responsiva.

Você pode acessar o protótipo completo pelo link abaixo:

[Figma - Protótipo do StudyFocus](https://www.figma.com/design/uLlV1BpHswsyPIs0RDWy6c/Untitled?node-id=0-1&p=f&t=yEiQboXWi1fMPwxU-0)

---

## 📂 Organização do Projeto

- `main.dart`: inicia a aplicação e define o widget principal.
- `cronometro.dart`: contém a lógica do cronômetro e toda a interface da aplicação.

```
.
├── .dart_tool/
├── .idea/
├── .vscode/
├── android/
├── build/
├── ios/
├── img/
├── lib/
│   ├── ui/
│   │   └── cronometro.dart
│   └── main.dart
├── linux/
├── macos/
├── test/
├── web/
├── windows/
├── .metadata
├── analysis_options.yaml
├── flutter_application_1.iml
├── pubspec.lock
├── pubspec.yaml
└── README.md
```

---

## 🧠 Explicação do `main.dart`

Este arquivo inicia o aplicativo Flutter. Ele importa o pacote principal de widgets e define o ponto de entrada com a função `main()`, que roda o app. A classe `App` é um widget sem estado (`StatelessWidget`) que retorna um `MaterialApp` com o widget `Cronometro` como tela principal. Esse padrão é usado para deixar a inicialização simples e clara, separando lógica de visual.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/ui/cronometro.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Cronometro(),
    );
  }  
}
```

---

## ⏱️ Lógica do Cronômetro (`cronometro.dart`)

A tela principal é um `StatefulWidget`, pois o cronômetro precisa atualizar a interface em tempo real com base em mudanças de estado. O temporizador é criado usando `Timer.periodic`, que incrementa os segundos e alterna entre os modos "estudo" e "pausa" conforme o tempo limite. O gerenciamento de estado é feito com `setState`, que força a reconstrução da interface sempre que os dados mudam.

O código também utiliza o método `dispose()` para garantir que o `Timer` seja cancelado corretamente quando o widget for destruído, evitando vazamentos de memória — uma aplicação direta do ciclo de vida dos widgets.

Dois campos `TextField` permitem que o usuário insira os tempos desejados para estudo e pausa. Os valores inseridos são tratados e convertidos para `int`, com verificação de validade. Isso demonstra uso de input controlado e validação.

A interface é responsiva: há uso de `MediaQuery` para ajustar o layout dependendo da largura da tela. Além disso, `Wrap` organiza os botões para que fiquem lado a lado de forma adaptativa.

---

## 🧪 Briefing da Entrevista Técnica

1. **Gerenciamento de estado:** `setState` é usado no `StatefulWidget` para atualizar a UI com o tempo.
2. **Armazenamento interno:** ainda não utiliza, mas pode-se usar `shared_preferences` no futuro.
3. **Organização do projeto:** arquivos separados por responsabilidade (`main.dart` e `cronometro.dart`).
4. **Builders:** o método `build()` constrói a interface dinamicamente com base no estado.
5. **Ciclo de vida:** o `dispose()` é usado para cancelar o Timer corretamente.
6. **TextEditingController:** não foi necessário, mas se usado, é fundamental usar `dispose()` para evitar vazamento de memória.

---

## 🛠️ Como Gerar um APK no Flutter

### ✅ 1. Criar Keystore

Abra o terminal e digite:

```bash
keytool -genkey -v -keystore ~/meu-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias minha-chave
```

Depois mova o `.jks` para `android/app`.

### ✅ 2. Criar o arquivo `key.properties`

Dentro da pasta `android/`, crie o arquivo:

```
storePassword=minhaSenha
keyPassword=minhaSenha
keyAlias=minha-chave
storeFile=meu-keystore.jks

```

### ✅ 3. Editar `android/app/build.gradle`

No topo do arquivo:

```
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file("key.properties")
keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
```

Depois:

```
signingConfigs {
  release {
    keyAlias keystoreProperties['keyAlias']
    keyPassword keystoreProperties['keyPassword']
    storeFile file(keystoreProperties['storeFile'])
    storePassword keystoreProperties['storePassword']
  }
}
```

E:

```
buildTypes {
  release {
    signingConfig signingConfigs.release
    minifyEnabled false
    shrinkResources false
    proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
  }
}
```

### ✅ 4. Gerar o APK

Rode no terminal:

```bash
flutter build apk --release
```

O APK final estará em:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 📱 Como Iniciar o Emulador Android pelo VS Code

### 🔧 Pré-requisitos

- Android Studio com Android Emulator instalado
- SDK configurado corretamente
- Flutter e Dart instalados

### 🚀 Passos

1. Abra o VS Code no projeto.
2. Pressione `Ctrl + Shift + P` e digite:
    
    ```
    Flutter: Launch Emulator
    ```
    
3. Selecione um emulador da lista (criado no Android Studio).
4. O emulador será iniciado e você poderá rodar o app com:
    
    ```
    flutter run
    ```
    

Se não aparecer nenhum emulador, abra o Android Studio > Device Manager > Crie um novo emulador.
