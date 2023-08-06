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
  });

  // Método factory para crear una instancia de Event desde el JSON decodificado
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      capacity: json['capacity'],
      date: DateTime.parse(json['_date']),
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      address: json['address'],
      university: json['university'],
      images: List<String>.from(json['images']),
    );
  }

  bool get isFollowedByMe => false;

  set isFollowedByMe(bool isFollowedByMe) {}
}
