class Contact {
  String name;
  String number;
  Contact({required this.name, required this.number});

  Map<String, dynamic> toJson() {
    return {'name': name, 'number': number};
  }

  static fromJson(contact) {}
}
