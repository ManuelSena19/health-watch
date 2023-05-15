import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:health_watch/constants/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:health_watch/utilities/show_error_dialog.dart';
import 'package:health_watch/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _firestore = FirebaseFirestore.instance;
  late final TextEditingController usernameController = TextEditingController();
  late final TextEditingController passwordController = TextEditingController();
  late final TextEditingController emailController = TextEditingController();
  late final TextEditingController heightController = TextEditingController();
  late final TextEditingController weightController = TextEditingController();
  late final TextEditingController dayController = TextEditingController();
  late final TextEditingController yearController = TextEditingController();
  late final TextEditingController allergyController = TextEditingController();
  late final TextEditingController conditionController =
      TextEditingController();
  late String selectedMonth = "";
  late String selectedGender = "";
  late String selectedBloodGroup = "";
  List<String> monthsInYear() {
    List<String> months = [];
    months.add("");
    for (int i = 1; i <= 12; i++) {
      DateTime monthDate = DateTime(DateTime.now().year, i);
      String monthName = DateFormat('MMMM').format(monthDate);
      months.add(monthName);
    }
    return months;
  }

  List<String> genders = ["", "Male", "Female"];
  List<String> bloodGroups = [
    '',
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
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

  Future<void> addUser(
      String email,
      String username,
      String day,
      String month,
      String year,
      String height,
      String weight,
      String bmi,
      String bloodGroup,
      String allergies,
      String healthConditions,
      String gender,
      String imagePath) async {
    final CollectionReference users = _firestore.collection('users');
    await users.doc(email).set({
      'username': username,
      'email': email,
      'day': day,
      'month': month,
      'year': year,
      'height': weight,
      'weight': weight,
      'bmi': bmi,
      'bloodGroup': bloodGroup,
      'allergies': allergies,
      'healthConditions': healthConditions,
      'gender': gender,
      'imagePath': imagePath
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    allergyController.dispose();
    conditionController.dispose();
    heightController.dispose();
    weightController.dispose();
    dayController.dispose();
    yearController.dispose();
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
        child: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
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
                        'Register',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextField(
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        controller: usernameController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person)),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                              icon: Icon(_isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            )),
                      ),
                    ),
                    Form(
                      key: formKey,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: TextField(
                          autofillHints: const [AutofillHints.email],
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            labelText: 'E-mail',
                            prefixIcon: Icon(Icons.email),
                          ),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Date of Birth",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<String>(
                              hint: const Text("Month"),
                              elevation: 0,
                              onChanged: (String? newMonth) {
                                setState(() {
                                  selectedMonth = newMonth!;
                                });
                              },
                              value: selectedMonth,
                              items: monthsInYear()
                                  .map<DropdownMenuItem<String>>(
                                      (String month) {
                                return DropdownMenuItem(
                                  value: month,
                                  child: Text(" $month"),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            controller: dayController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Day',
                              prefixIcon: Icon(Icons.calendar_month),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: TextInputType.number,
                            controller: yearController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Year',
                              prefixIcon: Icon(Icons.calendar_month),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Medical Information",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: heightController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Height /m',
                              prefixIcon: Icon(Icons.height),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextField(
                            enableSuggestions: false,
                            autocorrect: false,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            controller: weightController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              labelText: 'Weight /kg',
                              prefixIcon: Icon(Icons.line_weight),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Gender",
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<String>(
                              hint: const Text("Gender"),
                              elevation: 0,
                              onChanged: (String? newGender) {
                                setState(() {
                                  selectedGender = newGender!;
                                });
                              },
                              value: selectedGender,
                              items: genders.map<DropdownMenuItem<String>>(
                                  (String gender) {
                                return DropdownMenuItem(
                                  value: gender,
                                  child: Text("   $gender"),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 200,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          "Blood Type",
                          style: TextStyle(fontSize: 15),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  style: BorderStyle.solid, color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: DropdownButton<String>(
                              hint: const Text("Blood Type"),
                              elevation: 0,
                              onChanged: (String? newBloodGroup) {
                                setState(() {
                                  selectedBloodGroup = newBloodGroup!;
                                });
                              },
                              value: selectedBloodGroup,
                              items: bloodGroups.map<DropdownMenuItem<String>>(
                                  (String bloodGroup) {
                                return DropdownMenuItem(
                                  value: bloodGroup,
                                  child: Text("   $bloodGroup"),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 160,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextField(
                        enableSuggestions: true,
                        autocorrect: true,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        controller: allergyController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText: 'Enter your allergies here',
                          prefixIcon: Icon(Icons.coronavirus),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: TextField(
                        enableSuggestions: true,
                        autocorrect: true,
                        keyboardType: TextInputType.text,
                        maxLines: 5,
                        controller: conditionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          labelText:
                              'Enter your medical conditions here if you have any',
                          prefixIcon: Icon(Icons.local_hospital),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 100),
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            String username = usernameController.text;
                            String email = emailController.text;
                            String password = passwordController.text;
                            String month = selectedMonth;
                            String day = dayController.text;
                            String year = yearController.text;
                            String height = heightController.text;
                            String weight = weightController.text;
                            String bmi = (double.parse(weight) /
                                    double.parse(height) *
                                    double.parse(height))
                                .toString();
                            String gender = selectedGender;
                            String bloodGroup = selectedBloodGroup;
                            String allergies = allergyController.text == ""
                                ? "None"
                                : allergyController.text;
                            String healthConditions =
                                conditionController.text == ""
                                    ? "None"
                                    : conditionController.text;
                            String imagePath =
                                "https://th.bing.com/th/id/R.e62421c9ba5aeb764163aaccd64a9583?rik=DzXjlnhTgV5CvA&riu=http%3a%2f%2fcdn.onlinewebfonts.com%2fsvg%2fimg_210318.png&ehk=952QCsChZS0znBch2iju8Vc%2fS2aIXvqX%2f0zrwkjJ3GA%3d&risl=&pid=ImgRaw&r=0";
                            final form = formKey.currentState!;
                            if (form.validate()) {}
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                    email: email, password: password);
                            addUser(
                                email,
                                username,
                                day,
                                month,
                                year,
                                height,
                                weight,
                                bmi,
                                bloodGroup,
                                allergies,
                                healthConditions,
                                gender,
                                imagePath);
                            pushReplacementRoute(logicRoute);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              await showErrorDialog(context,
                                  "Weak password : Password should be above 6 characters");
                            } else if (e.code == 'invalid-password') {
                              await showErrorDialog(
                                  context, 'Invalid-password');
                            } else if (e.code == 'email-already-in-use') {
                              await showErrorDialog(context,
                                  'Email belongs to other user: Register with a different email');
                            } else {
                              await showErrorDialog(context, 'Error: $e.code');
                            }
                          } on TypeError catch (e) {
                            await showErrorDialog(context, e.toString());
                          } catch (e) {
                            await showErrorDialog(context, e.toString());
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
                              "Register",
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
                          'Already have an account?',
                          style: TextStyle(fontSize: 15),
                        ),
                        TextButton(
                          child: const Text(
                            'Sign In',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            pushReplacementRoute(loginRoute);
                          },
                        ),
                      ],
                    ),
                  ],
                );
              default:
                return const CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
