import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rundone/const/colors.dart';
import 'package:rundone/Modals/provider_modal.dart';
import 'package:rundone/screen/register-provider/serviceinfo.dart';

class ProviderInfo extends StatefulWidget {
  const ProviderInfo({Key? key}) : super(key: key);

  @override
  _ProviderInfoState createState() => _ProviderInfoState();
}

class _ProviderInfoState extends State<ProviderInfo> {
  final _auth = FirebaseAuth.instance;
  final _key = GlobalKey<FormState>();

  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _cinController = TextEditingController();
  final TextEditingController _gsmController = TextEditingController();
  final TextEditingController _adresseController = TextEditingController();
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
                    "Complétez votre profil",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Complétez votre profil et présenté vos services ",
                    style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                  )
                ],
              ),
              Form(
                key: _key,
                child: Column(
                  children: <Widget>[
                    inputFile(label: "Nom", controller: _nomController),
                    inputFile(label: "Prénom", controller: _prenomController),
                    inputFile(label: "CIN", controller: _cinController),
                    inputFile(label: "GSM", controller: _gsmController),
                    inputFile(label: "Adresse", controller: _adresseController),
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
                    postDetailstoFirestore();
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
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  postDetailstoFirestore() async {
    //Call Firestore
    //Call user MOdel
    //sending values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    ProviderModel providerModel = ProviderModel();

    //Writing all values
    providerModel.email = user!.email;
    providerModel.uid = user.uid;
    providerModel.nom = _nomController.text;
    providerModel.prenom = _prenomController.text;
    providerModel.gsm = _gsmController.text;
    providerModel.adresse = _adresseController.text;
    providerModel.cin = _cinController.text;

    await firebaseFirestore
        .collection("providers")
        .doc(user.uid)
        .set(providerModel.toMap());

    Fluttertoast.showToast(msg: "Vos données sont enregistrées avec succèes");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => ServiceInfo()),
        (route) => false);
  }
}

Widget inputFile({label, obscureText = false, controller}) {
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
