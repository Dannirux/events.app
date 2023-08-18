class Event {
  String id;
  String name;
  String description;
  int capacity;
  DateTime startDate;
  DateTime endDate;
  DateTime date;
  String address;
  String university;
  List<String> images;
  List<String> categories;
  double latitude; // Propiedad para latitud
  double longitude; // Propiedad para longitud

  Event({
    required this.id,
    required this.name,
    required this.description,
    required this.capacity,
    required this.date,
    required this.startDate,
    required this.endDate,
    required this.address,
    required this.university,
    required this.images,
    required this.categories,
    required this.latitude, // Agregada la latitud
    required this.longitude, // Agregada la longitud
  });

  // Método factory para crear una instancia de Event desde el JSON decodificado
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      capacity: json['capacity'] ?? 0,
      date: json['_date'] != null ? DateTime.parse(json['_date']) : DateTime.now(),
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : DateTime.now(),
      address: json['address'] ?? '',
      university: json['university'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      categories: json['categories'] != null ? List<String>.from(json['categories']) : [],
      latitude: 0.0, // Valor temporal, se actualiza en el método getMyEvents
      longitude: 0.0, // Valor temporal, se actualiza en el método getMyEvents
    );
  }

  bool get isFollowedByMe => false;

  set isFollowedByMe(bool isFollowedByMe) {}
}
