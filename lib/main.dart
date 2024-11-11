import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/display/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outagamie_emergency_management_app/models/login.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Outagamie Emergency Management',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider<LoginModel>(
        create: (_) => LoginModel(), 
        child: Consumer<LoginModel>(
          builder: (context, loginModel, child) =>
              LoginWidget(loginModel: loginModel), 
        ),
    ));
  }
}