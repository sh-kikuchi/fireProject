import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase_Auth_App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthAppPage(title: 'Firebase_Auth_App'),
    );
  }
}

class AuthAppPage extends StatefulWidget {
  const AuthAppPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<AuthAppPage> createState() => _AuthAppPageState();
}

class _AuthAppPageState extends State<AuthAppPage> {
  // Registration Field Email Address
  String registerUserEmail = "";
  // Registration Field Password
  String registerUserPassword = "";
  // Login field email address
  String loginUserEmail = "";
  // Login field password (login)
  String loginUserPassword = "";
  // View information about registration and login
  String DebugText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TextFormField(
                // Set labels for text input
                decoration: const InputDecoration(labelText: "Mail Address"),
                onChanged: (String value) {
                  setState(() {
                    registerUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(
                    labelText: "6 character long Password"),
                // Mask not to show password
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    registerUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 1),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // User Registration
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.createUserWithEmailAndPassword(
                      email: registerUserEmail,
                      password: registerUserPassword,
                    );
                    // Registered User Information
                    final User user = result.user!;
                    setState(() {
                      DebugText = "Register OK：${user.email}";
                    });
                  } catch (e) {
                    // Failed User Information
                    setState(() {
                      DebugText = "Register Fail：${e.toString()}";
                    });
                  }
                },
                child: const Text("User Registration"),
              ),
              const SizedBox(height: 1),
              TextFormField(
                decoration: const InputDecoration(labelText: "Mail Address"),
                onChanged: (String value) {
                  setState(() {
                    loginUserEmail = value;
                  });
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    loginUserPassword = value;
                  });
                },
              ),
              const SizedBox(height: 1),
              ElevatedButton(
                onPressed: () async {
                  try {
                    // Try login
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final UserCredential result =
                        await auth.signInWithEmailAndPassword(
                      email: loginUserEmail,
                      password: loginUserPassword,
                    );
                    // Succeeded to login
                    final User user = result.user!;
                    setState(() {
                      DebugText = "Succeeded to Login：${user.email}";
                    });
                  } catch (e) {
                    // Failed to login
                    setState(() {
                      DebugText = "Failed to Login：${e.toString()}";
                    });
                  }
                },
                child: const Text("Login"),
              ),
              const SizedBox(height: 8),
              Text(DebugText),
            ],
          ),
        ),
      ),
    );
  }
}
