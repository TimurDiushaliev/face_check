import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

List<ProfileModel> profileModelFromJson2(String str) => List<ProfileModel>.from(
    json.decode(str).map((x) => ProfileModel.fromJson(x)));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    this.id,
    this.user,
    this.image,
    this.position,
    this.company,
  });

  int id;
  User user;
  ProfileImage image;
  String position;
  int company;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        id: json["id"],
        user: User.fromJson(json["user"]),
        image: json['image'] != null ?ProfileImage.fromJson(json['image']): null,
        position: json["position"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user": user.toJson(),
        'image': image.toJson(),
        "position": position,
        "company": company,
      };
}

class User {
  User({
    this.username,
    this.firstName,
    this.lastName,
  });

  String username;
  String firstName;
  String lastName;

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
        firstName: json["first_name"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "first_name": firstName,
        "last_name": lastName,
      };
}

class ProfileImage {
  ProfileImage({this.id, this.file});

  int id;
  String file;

  factory ProfileImage.fromJson(Map<String, dynamic> json) =>
      ProfileImage(id: json['id'], file: json['file']);

  Map<String, dynamic> toJson() => {'id': id, "file": file};
}
