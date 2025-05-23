class CareEntry {
  String? id;
  String? userPlantId;
  DateTime? lastWatered;
  DateTime? lastFertilized;
  DateTime? lastPruned;
  DateTime? lastRepotted;
  String? notes;
  String? photo;

  CareEntry({
    this.id,
    this.userPlantId,
    this.lastWatered,
    this.lastFertilized,
    this.lastPruned,
    this.lastRepotted,
    this.notes,
    this.photo,
  });
}
