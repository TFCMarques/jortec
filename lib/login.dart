import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:html' show window;

Future login(BuildContext context, String email, String password) async {
  Response res = await post(
    Uri.http("ws-api.neec-fct.com", "/user/login"),
    headers: <String, String> {
      "Content-Type": "application/json"
    },
    body: jsonEncode(<String, String>{
      "email": email,
      "password": password
    })
  );

  if (res.statusCode == 200) {
    final responseJSON = jsonDecode(res.body);
    window.localStorage["token"] = responseJSON["token"];
    Navigator.pushNamed(context, "/home");
  } else if (res.statusCode == 401){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Invalid Login"),
          content: Text("Please insert email and password correctly!"),
          actions: <Widget>[
            new TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"))
          ],
        );
      }
    );
  }
}

class Login extends StatefulWidget {
  @override
  LoginState createState() => new LoginState();
}

class LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Padding(
      padding: EdgeInsets.all(20.0), 
      child: Hero(
        tag: 'hero',
        child: Icon(
          Icons.movie,
          size: 100,
        ),
      )
    );

    final inputEmail = Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: "Email",
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0)
          ),
        ),
      ),
    );

    final inputPassword = Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.text,
        obscureText: true,
        decoration: InputDecoration(
          hintText: "Password",
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0)
          )
        )
      ),
    );

    final buttonLogin = Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: ButtonTheme(
        height: 56,
        child: ElevatedButton(
          child: Text("Login", style: TextStyle(color: Colors.white, fontSize: 16)),
          onPressed: () {
           login(context, emailController.text, passwordController.text);
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.blue),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("Login")
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.33),
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        children: [
                          logo,
                          inputEmail,
                          inputPassword,
                          buttonLogin
                        ],
                      )
                    ),
                  ],
                )
              ),
            ]
          )
        ),
      )
    );
  }
}