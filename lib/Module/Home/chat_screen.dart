import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../Models/chat_message_model.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late DateTime _entryTime;

  final String _chatOwnerUid = 'ntVOAXRqITQvrh1mdV3A8HuagPw2';

  String _getUsername() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.displayName ?? 'Desconhecido';
  }

  void _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final String username = _getUsername();
    final String? uid = FirebaseAuth.instance.currentUser?.uid;

    _controller.clear();

    await FirebaseFirestore.instance.collection('messages').add({
      'text': text,
      'username': username,
      'uid': uid,
      'timestamp': FieldValue.serverTimestamp(),
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "Data inválida";
    final DateTime dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
  }

  Widget _buildMessage(ChatMessage message, {String? formattedDate, bool isOwner = false, bool isCurrentUser = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blueAccent : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.username ?? 'Desconhecido',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                  if (isOwner)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Image.asset(
                        'assets/Furia_Esports_logo.png',
                        width: 16,
                        height: 16,
                      ),
                    ),
                ],
              ),
            ),
            Text(
              message.text,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black87,
              ),
            ),
            if (formattedDate != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.black54,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _entryTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final String? currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .where('timestamp', isGreaterThan: _entryTime)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                var messages = snapshot.data!.docs;
                List<Widget> messageWidgets = [];

                for (var message in messages) {
                  String text = message['text'];
                  String username = message['username'] ?? 'Desconhecido';
                  String uid = message['uid'] ?? '';
                  Timestamp? timestamp = message['timestamp'];
                  String formattedDate = _formatDate(timestamp);

                  bool isOwner = uid == _chatOwnerUid;
                  bool isCurrentUser = uid == currentUserUid;

                  messageWidgets.add(
                    _buildMessage(
                      ChatMessage(
                        text: text,
                        username: username,
                      ),
                      formattedDate: formattedDate,
                      isOwner: isOwner,
                      isCurrentUser: isCurrentUser,
                    ),
                  );
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    _scrollController.position.maxScrollExtent,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                  );
                });

                return ListView(
                  controller: _scrollController,
                  children: messageWidgets,
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: _sendMessage,
                    decoration: const InputDecoration.collapsed(
                      hintText: 'Digite sua mensagem...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}