import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:health_watch/constants/user_data.dart';
import 'package:health_watch/constants/user_preferences.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';
import 'package:health_watch/constants/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  bool _isObscure = true;
  final formKey = GlobalKey<FormState>();

  void validator(emailController) =>
      emailController != null && !EmailValidator.validate(emailController)
          ? 'Enter a valid email'
          : null;

  void pushRoute(String route) {
    Navigator.pushNamed(context, route);
  }

  void pushReplacementRoute(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  void showError(String text) {
    showErrorDialog(context, text);
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(10, 60, 10, 10),
              child: const Text(
                'Health Watch',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                    fontSize: 30),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 20),
              ),
            ),
            Form(
              key: formKey,
              child: Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      labelText: 'E-mail',
                      prefixIcon: Icon(Icons.email)),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                obscureText: _isObscure,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
              ),
            ),
            Container(
              height: 60,
              padding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 100),
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    String email = emailController.text;
                    String password = passwordController.text;
                    final form = formKey.currentState!;
                    if (form.validate()) {}
                    final userData = await getUserData(email);
                    await storeUserDataInSharedPrefs(email, userData);
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);
                    pushReplacementRoute(logicRoute);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      showError('User not found');
                    } else if (e.code == 'wrong-password') {
                      showError('Wrong password');
                    } else {
                      showError('Error: $e');
                    }
                  } catch (e) {
                    showError('Error: $e');
                  }
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Does not have an account?',
                  style: TextStyle(fontSize: 15),
                ),
                TextButton(
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: () {
                    pushReplacementRoute(registerRoute);
                  },
                ),
              ],
            ),
            TextButton(
                onPressed: () {
                  pushRoute(resetPasswordRoute);
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 15),
                )),
          ],
        ),
      ),
    );
  }
}
