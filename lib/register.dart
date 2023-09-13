import 'package:fire_project/todo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUserPage> {
  // Registration Field Email Address
  String registerUserEmail = "";
  // Registration Field Password
  String registerUserPassword = "";
  // Login field email address
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, //背景色
                ),
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
                    await Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return ToDoPage(user);
                    }));
                  } catch (e) {
                    // Failed User Information
                    setState(() {
                      DebugText = "Register Fail：${e.toString()}";
                    });
                  }
                },
                child: const Text("User Registration"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
