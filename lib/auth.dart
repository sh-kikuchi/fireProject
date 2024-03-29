import 'package:fire_project/register.dart';
import 'package:fire_project/todo.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthAppPage extends StatefulWidget {
  const AuthAppPage({super.key});

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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, //背景色
                ),
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
                    //ログインに成功したら
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return ToDoPage(user);
                      }),
                    );
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey, //背景色
                ),
                onPressed: () async {
                  try {
                    // User Registration
                    await Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                      return const RegisterUserPage();
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
              Text(DebugText),
            ],
          ),
        ),
      ),
    );
  }
}
