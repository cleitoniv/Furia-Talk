# 📱 FURIA Talk - Documentação do Projeto

Este projeto é um app Flutter com integração em tempo real com Firebase e dados da PandaScore API, focado em fãs da equipe **FURIA Esports**. Abaixo está a descrição técnica das principais funcionalidades.

---

## 📋 1. RegisterUserPopUp - Pop-up de Registro de Usuário

### 🔍 Visão Geral
A classe `RegisterUserPopUp` exibe um pop-up com formulário para o usuário se registrar, contendo validações para nome, email, senha e confirmação de senha. 

### 🛠️ Funcionalidades

- `registrationPopup(BuildContext context, Function registerFunc)`
  - Exibe um `AlertDialog` com:
    - Campo de **Nome** (não pode estar vazio)
    - Campo de **Email** (validação com regex)
    - Campo de **Senha** (mínimo 6 caracteres)
    - Campo de **Confirmação de Senha** (deve ser igual à senha)
  - Se o formulário for válido, executa `registerFunc(nome, email, senha)`

### 💡 Exemplo de Uso
```dart
RegisterUserPopUp.registrationPopup(context, registerFunc);
💬 2. ChatScreen - Tela de Chat
🔍 Visão Geral
Permite envio e recebimento de mensagens em tempo real via Firebase, com exibição de nome, texto e timestamp.

🛠️ Funcionalidades
_getUsername()
Retorna o nome do usuário logado ou "Desconhecido"

_sendMessage(String text)
Envia a mensagem para o Firestore se o texto não estiver vazio.

_formatDate(Timestamp? timestamp)
Formata a data no padrão dd/MM/yyyy HH:mm

_buildMessage(...)
Exibe mensagem com:

Nome do remetente

Texto

Data

Ícone especial se for o dono do chat

StreamBuilder<QuerySnapshot>
Escuta atualizações em tempo real do Firestore.

💡 Exemplo de Uso
dart
Copiar
Editar
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ChatScreen()),
);
🏠 3. HomeScreen - Tela Inicial
🔍 Visão Geral
Tela inicial com botões para acessar o chat, ver notícias, e um botão flutuante para abrir o WhatsApp.

🛠️ Funcionalidades
_openWhatsApp()
Abre o número +55 11 99340-4466 via WhatsApp ou navegador.

build(BuildContext context)

Botão para o Chat

Botão para Notícias

Botão flutuante com ícone do WhatsApp

💡 Exemplo de Uso
dart
Copiar
Editar
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ChatScreen()),
);
📰 4. FuriaPage - Página de Notícias do Time FURIA
🔍 Visão Geral
Exibe informações do time FURIA e suas partidas (futuras e passadas), usando a API da PandaScore.

🛠️ Funcionalidades
fetchTeamAndMatches()

Busca dados do time FURIA e partidas pela API PandaScore.

Separa partidas futuras e passadas.

translateStatus(String status)
Traduz status da API:

not_started → 🕒 Em breve

running → 🔥 Jogando agora

finished → ✅ Finalizado

matchTile(dynamic match)
Cria um ListTile com:

Nome da partida

Ícone do adversário

Data

Resultado (Vitória/Derrota)

section(String title, List<dynamic> matches)
Agrupa partidas com título e separador.

💡 Exemplo de Uso
dart
Copiar
Editar
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => FuriaPage()),
);
✅ Considerações Finais
As telas são bem separadas por responsabilidade.

A integração com Firebase e PandaScore API é eficiente e bem estruturada.

Utiliza:

StreamBuilder para mensagens em tempo real.

Requisições HTTP para partidas de CS:GO.

Interface intuitiva e navegação simples.

🔗 Recursos Utilizados
Firebase Authentication

Cloud Firestore

PandaScore API

Flutter

🧠 Autor
Desenvolvido com foco na comunidade fã de e-sports da FURIA.

