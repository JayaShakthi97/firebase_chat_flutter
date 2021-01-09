class AppUser {
  // Attribute names
  final _dbId = 'id';
  final _dbEmail = 'email';
  final _dbDisplayName = 'display_name';
  final _dbImageURL = 'image_url';

  // Attributes
  String id;
  String email;
  String displayName;
  String imageURL;

  AppUser({this.id, this.email, this.displayName, this.imageURL});

  AppUser.fromMap(Map<String, dynamic> data) {
    this.id = data[_dbId];
    this.email = data[_dbEmail];
    this.displayName = data[_dbDisplayName];
    this.imageURL = data[_dbImageURL];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map[_dbId] = this.id;
    map[_dbEmail] = this.email;
    map[_dbDisplayName] = this.displayName;
    map[_dbImageURL] = this.imageURL;
    return map;
  }
}
