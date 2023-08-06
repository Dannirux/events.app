class ModelClient {
  String id;
  String names;
  String surnames;
  String email;
  String phone;
  List<String> interests;

  ModelClient({
    required this.id,
    required this.names,
    required this.surnames,
    required this.email,
    required this.phone,
    required this.interests,
  });

  // Método factory para crear una instancia de Event desde el JSON decodificado
  factory ModelClient.fromJson(Map<String, dynamic> json) {
    return ModelClient(
      id: json['_id'],
      names: json['names'],
      surnames: json['surnames'],
      email: json['email'],
      phone: json['phone'],
      interests: List<String>.from(json['interests']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'names': names,
      'surnames': surnames,
      'email': email,
      'phone': phone,
      'interests': interests,
    };
  }
}