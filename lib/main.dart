import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Module/Auth/authenticate_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
      runApp(const FuriaTalk());
    });
    
}

class FuriaTalk extends StatelessWidget {
  const FuriaTalk({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthenticateScreen(),
    );
  }
}
