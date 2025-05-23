class CareEntry {
  String? id;
  String? userPlantId;
  String? type;
  DateTime? date;
  String? notes;
  String? photo;

  CareEntry({
    this.id,
    this.userPlantId,
    this.type,
    this.date,
    this.notes,
    this.photo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userPlantId': userPlantId,
      'type': type,
      'date': date?.toIso8601String(),
      'notes': notes,
      'photo': photo,
    };
  }

// Daraus lesen wir Daten aus dem JSON File und erstellen ein Dart Objekt
  factory CareEntry.fromJson(Map<String, dynamic> json) {
    return CareEntry(
      id: json['id'],
      userPlantId: json['userPlantId'],
      type: json['type'],
      date: DateTime.parse(json['date']),
      notes: json['notes'],
      photo: json['photo'],
    );
  }
}
