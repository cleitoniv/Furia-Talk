import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:furia_talk/Module/Home/chat_screen.dart';
import 'package:furia_talk/Module/Repositories/Panda_score.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Função para abrir o WhatsApp ou o navegador
  void _openWhatsApp() async {
    final Uri whatsappUrl = Uri.parse("https://wa.me/5511993404466");

    try {
      if (await canLaunchUrl(whatsappUrl)) {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(whatsappUrl, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      'Erro ao tentar abrir o WhatsApp ou o navegador: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Image.asset(
          'assets/furia_talk.png',
          width: 200.0,
          height: 100.0,
          fit: BoxFit.cover,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatScreen()),
                  );
                },
                icon: Icon(Icons.chat_bubble_outline),
                label: Text("Entrar no Chat"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FuriaPage()),
                  );
                },
                icon: Icon(Icons.newspaper),
                label: Text("Ver Notícias"),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openWhatsApp,
        backgroundColor: Colors.green,
        child: Image.asset(
          'assets/whatsapp_icon.png',
          width: 50.0,
          height: 50.0,
          fit: BoxFit.cover,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}