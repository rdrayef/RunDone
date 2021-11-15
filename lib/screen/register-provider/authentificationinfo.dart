import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rundone/const/colors.dart';
import 'package:rundone/screen/register-provider/RegistrationService.dart';
import 'package:rundone/screen/register-provider/providerinfo.dart';

class AuthentificationInfo extends StatefulWidget {
  const AuthentificationInfo({Key? key}) : super(key: key);

  @override
  _AuthentificationInfoState createState() => _AuthentificationInfoState();
}

class _AuthentificationInfoState extends State<AuthentificationInfo> {
  final RegistrationService _auth = RegistrationService();
  final _key = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text(
                    "S'inscrire",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Créer votre compte et présenté vos services ",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    inputFile(
                        label: "Email",
                        controller: _emailController,
                        email: true),
                    inputFile(
                        label: "Password",
                        obscureText: true,
                        controller: _passwordController,
                        password: true),
                    inputFile(
                        label: "Confirm Password ",
                        obscureText: true,
                        confimpassword: true,
                        controller: _confirmpasswordController),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 3, left: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    border: const Border(
                      bottom: BorderSide(color: Colors.black),
                      top: BorderSide(color: Colors.black),
                      left: BorderSide(color: Colors.black),
                      right: BorderSide(color: Colors.black),
                    )),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    if (_key.currentState!.validate()) {
                      createUser();
                    }
                  },
                  color: SecondaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Text(
                    "Continuer",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text("Already have an account?"),
                  Text(
                    " Login",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: SecondaryColor),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void createUser() async {
    dynamic result = await _auth.createNewUser(
        _emailController.text, _passwordController.text);
    if (result == null) {
      print("Email is not valid");
    } else {
      print("Result: " + result.toString());
      Fluttertoast.showToast(msg: "Votre compte a été créer avec succèes");
      _emailController.clear();
      _passwordController.clear();
      _confirmpasswordController.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProviderInfo()),
      );
    }
  }

  bool isEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  Widget inputFile(
      {label,
      obscureText = false,
      controller,
      email = false,
      confimpassword = false,
      password = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "Champ requis (*)";
            }
            if (email) {
              return isEmail(value) ? null : "Email invalide";
            }
            if (password) {
              return value.length >= 6
                  ? null
                  : "Mot de passe doit être supérieure à 8 caractère";
            }
            if (confimpassword) {
              return value == _passwordController.text
                  ? null
                  : "Les mots de passe ne correspondent pas";
            }
          },
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: (Colors.grey[400])!),
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: (Colors.grey[400])!)),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
