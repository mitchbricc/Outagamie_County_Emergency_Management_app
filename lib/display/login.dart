// ignore: dangling_library_doc_comments, slash_for_doc_comments
/**
Name:Mitchell Bricco
Date:
Description:
Bugs: no known bugs
*/

import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/material.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/create_account.dart';
import 'package:outagamie_emergency_management_app/display/volunteer/volunteer_home.dart';
import 'package:outagamie_emergency_management_app/display/admin/admin_home.dart';
import 'package:outagamie_emergency_management_app/models/login.dart';
import 'package:outagamie_emergency_management_app/models/create_account.dart';
import 'package:provider/provider.dart';

class LoginWidget extends StatefulWidget {
  final LoginModel loginModel;
  const LoginWidget({super.key, required this.loginModel});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  _LoginWidgetState();
  @override
  initState() {
    super.initState();
    model = widget.loginModel;
  }
  late final LoginModel model;
  String email = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void tryLogin() async {
    if (usernameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter valid email'), 
        ),
      );
    } else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Please enter valid password'), 
        ),
      );
    } else {
      await model.fetchPassword(usernameController.text);
      if (!mounted) {
        return;
      } else {
        if (model.user.password == 'not found') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please enter valid username & password'),
            ),
          );
        } else {
          bool passwordGood = BCrypt.hashpw(passwordController.text, model.user.salt) == model.user.password;
              //BCrypt.checkpw(BCrypt.hashpw(passwordController.text, model.user.salt), model.user.password);
          if (passwordGood) {
            if (model.user.type.compareTo("volunteer") == 0) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => const VolunteerHome(),
                ),
              );
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => AdminHome(user: model.user),
                ),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter valid password'),
              ),
            );
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 140, 10, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assests/logo.png'),
              // const Text(
              //   'Outagamie County Management', 
              //   style: TextStyle(
              //     fontSize: 30,
              //     color: Colors.black,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 20),
              TextField(
                style: const TextStyle(fontSize: 20),
                controller: usernameController, 
                decoration: const InputDecoration(
                    hintText: 'Enter your username',
                    hintStyle: TextStyle(fontSize: 20),
                    labelText: 'Username',
                    suffixIcon: Icon(Icons.email, color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusColor: Colors.black),
              ),
              const SizedBox(height: 20),
              TextField(
                onSubmitted: (value) => _tryLogin(),
                style: const TextStyle(fontSize: 20),
                cursorColor: Colors.black,
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(fontSize: 20),
                    labelText: 'Password',
                    suffixIcon: Icon(Icons.key, color: Colors.grey),
                    border: OutlineInputBorder(),
                    focusColor: Colors.black),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _tryLogin, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Login',
                          style: TextStyle(color: Colors.black, fontSize: 19)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _createAccount, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Create Account',
                          style: TextStyle(color: Colors.black, fontSize: 19)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: _forgotPassword, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text('Forgot Password',
                          style: TextStyle(color: Colors.black, fontSize: 19)),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }

  //for testing
  void _tryLogin() async {
    // if(usernameController.text.isNotEmpty && usernameController.text == 'admin'){
    //   await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               fullscreenDialog: true,
    //               builder: (context) => AdminHome(user: model.user,),
    //             ),
    //           );
    // }
    // else if(usernameController.text.isNotEmpty && usernameController.text == 'volunteer'){
    //   await Navigator.push(
    //             context,
    //             MaterialPageRoute(
    //               fullscreenDialog: true,
    //               builder: (context) => const VolunteerHome(),
    //             ),
    //           );
    // }
    // else{
      tryLogin();
    // }
  }

  void _createAccount() async {
      await Navigator.push(
                context,
                MaterialPageRoute(
                  fullscreenDialog: true,
                  builder: (context) => ChangeNotifierProvider<CreateAccountModel>(
                    create: (_) => CreateAccountModel(), 
                    child: Consumer<CreateAccountModel>(
                      builder: (context, model, child) =>
                          CreateAccountWidget(model: model), 
                    ),
                )));
  }
  void _forgotPassword() async {
      ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('A message was sent to the admins. Please contact [Person on call]'),
              ),
            );
  }
}
