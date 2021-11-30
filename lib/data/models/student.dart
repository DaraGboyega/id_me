class Student {
  String? name;
  String? matricNumber;

  Student({this.name, this.matricNumber});

  Map<String, String> toMap() {
    return {"name": name ?? "", "matric number": matricNumber ?? ""};
  }

  Student fromMap(dynamic map) {
    return Student(name: map["name"], matricNumber: map["matric number"]);
  }

  void toLowerCase() {
    this.name = this.name?.toLowerCase();
    this.matricNumber = this.matricNumber?.toLowerCase();
  }
}
