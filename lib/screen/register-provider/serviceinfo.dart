import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rundone/Modals/service_modal.dart';
import 'package:rundone/const/colors.dart';

class ServiceInfo extends StatefulWidget {
  const ServiceInfo({Key? key}) : super(key: key);

  @override
  _ServiceInfoState createState() => _ServiceInfoState();
}

class _ServiceInfoState extends State<ServiceInfo> {
  final _auth = FirebaseAuth.instance;
  final _key = GlobalKey<FormState>();
  final _keyDescription = GlobalKey<FormState>();
  final _keyImage = GlobalKey<FormState>();
  String dropdownValue = 'Plomberie';

  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _intituleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final imagePicker = ImagePicker();
  File? pickedImage;
  String? downloadUrl;

  pickImage(ImageSource imageType) async {
    try {
      final photo = await ImagePicker().pickImage(source: imageType);
      if (photo == null) {
        return showSnackBar(
            "Aucun Fichier Sélectionné", const Duration(milliseconds: 400));
      }

      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void imagePickerOption() {
    Get.bottomSheet(
      SingleChildScrollView(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          ),
          child: Container(
            color: Colors.white,
            height: 250,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Ajouter une image depuis",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.camera);
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("CAMERA"),
                    style: ElevatedButton.styleFrom(
                        primary: SecondaryColor,
                        fixedSize: const Size(100, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      pickImage(ImageSource.gallery);
                    },
                    icon: const Icon(Icons.image),
                    label: const Text("GALLERY"),
                    style: ElevatedButton.styleFrom(
                        primary: SecondaryColor,
                        fixedSize: const Size(100, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text("CANCEL"),
                    style: ElevatedButton.styleFrom(
                        primary: SecondaryColor,
                        fixedSize: const Size(100, 55),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future uploadImage() async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("ServicesImages")
        .child(_auth.currentUser!.uid + "/" + DateTime.now().toString());
    await ref.putFile(pickedImage!);
    downloadUrl = await ref.getDownloadURL();
    postDetailstoFirestore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: SecondaryColor,
        centerTitle: true,
        title: const Text('Ajouter un service'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 30),
                Center(
                    child: SvgPicture.asset(
                  "assets/images/logo.svg",
                  color: SecondaryColor,
                  height: 70,
                )),
                const SizedBox(height: 15),
                const Text(
                  "Détails du service",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 35),
                // basic details form
                Form(
                  key: _key,
                  child: ExpansionTile(
                    maintainState: true,
                    title: const Text(
                      "Informations de base",
                      style: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18),
                    ),
                    leading: const Icon(
                      Icons.shop,
                      color: SecondaryColor,
                    ),
                    childrenPadding: const EdgeInsets.symmetric(vertical: 20),
                    children: [
                      // title field

                      DropdownButtonFormField<String>(
                        value: dropdownValue,
                        validator: (value) {
                          if (value!.isEmpty) {
                            showSnackBar("Veuillez sélectionner une catégorie",
                                const Duration(milliseconds: 600));
                          }
                        },
                        hint: const Text("Catégorie"),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>[
                          'Plomberie',
                          'Electrician',
                          'Nettoyage',
                          'Jardinage',
                          'Chauffeur',
                          'Baby sitting',
                          'Menuiserie',
                          'Peintre',
                          'Aménagement'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20),
                      // original price
                      TextFormField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: "e.g., 300.0",
                          labelText: "Prix du service",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            showSnackBar("Veuillez sélectionner une catégorie",
                                const Duration(milliseconds: 600));
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // description form
                Form(
                  key: _keyDescription,
                  child: ExpansionTile(
                    maintainState: true,
                    title: const Text(
                      "Description du service",
                      style: TextStyle(
                        color: Color(0XFF8B8B8B),
                        fontSize: 18,
                      ),
                    ),
                    leading: const Icon(
                      Icons.description,
                      color: SecondaryColor,
                    ),
                    childrenPadding: const EdgeInsets.symmetric(vertical: 20),
                    children: [
                      TextFormField(
                        controller: _intituleController,
                        keyboardType: TextInputType.name,
                        decoration: const InputDecoration(
                          hintText:
                              "e.g., Installation et branchement de lave-vaisselle",
                          labelText: "Intitulé Service",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            showSnackBar(
                                "Veuillez saisir un titre pour ce service",
                                const Duration(milliseconds: 600));
                          }
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      // description field
                      TextFormField(
                        controller: _descriptionController,
                        keyboardType: TextInputType.multiline,
                        decoration: const InputDecoration(
                          hintText:
                              "e.g., Que ce soit seulement quelques nouveaux meubles de cuisine ou une cuisine complète en U ou en L...",
                          labelText: "Description",
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            showSnackBar(
                                "Veuillez saisir une description pour ce service",
                                const Duration(milliseconds: 600));
                          }
                        },
                        maxLines: null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                    ],
                  ),
                ),
                // upload images form
                const SizedBox(height: 30),
                Form(
                  // key: _uploadImagesFormKey,
                  child: ExpansionTile(
                    maintainState: true,
                    title: const Text(
                      "Upload Image",
                      style: TextStyle(
                        color: Color(0XFF8B8B8B),
                        fontSize: 18,
                      ),
                    ),
                    leading: const Icon(
                      Icons.image,
                      color: SecondaryColor,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Align(
                          alignment: Alignment.center,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: SecondaryColor, width: 5),
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                                child: ClipOval(
                                  child: pickedImage != null
                                      ? Image.file(
                                          pickedImage!,
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/images/image.jpg',
                                          width: 150,
                                          height: 150,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 5,
                                child: IconButton(
                                  onPressed: () {
                                    imagePickerOption();
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo_outlined,
                                    color: SecondaryColor,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // product type drop down
                // product search tags

                const SizedBox(height: 75),
                // default button
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
                    onPressed: () async {
                      /*i f (_key.currentState!.validate()) {
                      createUser();
                    } */
                      uploadImage();
                    },
                    color: SecondaryColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Text(
                      "Ajouter Service",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
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

    ServiceModal serviceModal = ServiceModal();

    //Writing all values
    serviceModal.intitule = _intituleController.text;
    serviceModal.description = _descriptionController.text;
    serviceModal.prix = double.parse(_priceController.text);
    serviceModal.categorie = dropdownValue;
    serviceModal.imageUrl = downloadUrl;
    serviceModal.etat = "Nouveau";

    await firebaseFirestore
        .collection("providers")
        .doc(user!.uid)
        .collection("services")
        .doc()
        .set(serviceModal.toMap());

    showSnackBar("Votre service a été ajouté avec succèes",
        const Duration(milliseconds: 600));

    /*  Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => ServiceInfo()),
        (route) => false); */
  }
}
