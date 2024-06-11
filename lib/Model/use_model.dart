class StudentModel {
  String? userID;
  String? name;
  String? email;
  String? role;
  String? password;
  String? photoUrl;
  String? present;
  String? leave;
  String? totalPresents;
  String? totalLeaves;

  StudentModel(
    this.userID,
    this.name,
    this.email,
    this.role,
    this.password,
    this.photoUrl,
    this.present,
    this.leave,
    this.totalPresents,
    this.totalLeaves,
  );

  Map<String, dynamic> toJson() => {
        'id': userID,
        'name': name,
        'email': email,
        'role' : role,
        'password': password,
        'photoUrl': photoUrl,
        'present': present,
        'leave': leave,
        'totalPresents': totalPresents,
        'totalLeaves': totalLeaves,
      };
}
