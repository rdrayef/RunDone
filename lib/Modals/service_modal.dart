class ServiceModal {
  String? intitule;
  String? description;
  double? prix;
  String? categorie;
  String? etat;
  String? imageUrl;

  ServiceModal(
      {this.intitule,
      this.description,
      this.prix,
      this.categorie,
      this.etat,
      this.imageUrl});

  //receiving data from server
  factory ServiceModal.fromMap(map) {
    return ServiceModal(
      intitule: map['intitule'],
      description: map['description'],
      prix: map['prix'],
      categorie: map['categorie'],
      etat: map['etat'],
      imageUrl: map['imageUrl'],
    );
  }

  //sending data to server
  Map<String, dynamic> toMap() {
    return {
      'intitule': intitule,
      'description': description,
      'prix': prix,
      'categorie': categorie,
      'etat': etat,
      'imageUrl': imageUrl,
    };
  }
}
