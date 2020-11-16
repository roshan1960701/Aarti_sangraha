class gods {
  int id;
  String name;

  gods({this.id, this.name});
  Map<String, dynamic> toMap() {
    return {"id": id, "name": name};
  }
}
