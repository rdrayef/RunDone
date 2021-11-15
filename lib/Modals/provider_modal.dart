class ProviderModel {
  String? uid;
  String? email;
  String? nom;
  String? prenom;
  String? cin;
  String? gsm;
  String? adresse;

  ProviderModel(
      {this.uid,
      this.email,
      this.nom,
      this.prenom,
      this.cin,
      this.gsm,
      this.adresse});

  //receiving data from server
  factory ProviderModel.fromMap(map) {
    return ProviderModel(
        uid: map['uid'],
        email: map['email'],
        nom: map['nom'],
        prenom: map['prenom'],
        cin: map['cin'],
        gsm: map['gsm'],
        adresse: map['adresse']);
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'nom': nom,
      'prenom': prenom,
      'cin': cin,
      'gsm': gsm,
      'adresse': adresse
    };
  }
}
