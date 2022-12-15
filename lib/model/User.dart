class User {
  int? id;
  String? name;
  String? contact;
  String? description;
  String? image;

  userMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name!;
    mapping['contact'] = contact!;
    mapping['description'] = description!;
    mapping['image'] = image!;
    return mapping;
  }
}
