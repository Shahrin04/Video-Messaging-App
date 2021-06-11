

class UserModel{
  String uid;
  String email;
  String name;
  String photoUrl;
  String phoneNumber;

  UserModel({this.uid, this.email, this.name, this.photoUrl, this.phoneNumber});

  Map toMap(UserModel userModel){
    var data = Map<String, dynamic>();
    data['uid'] = userModel.uid;
    data['email'] = userModel.email;
    data['name'] = userModel.name;
    data['photoUrl'] = userModel.photoUrl;
    data['phoneNumber'] = userModel.phoneNumber;
  }

  UserModel.fromMap(Map<String, dynamic> mapData){
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.name = mapData['name'];
    this.photoUrl = mapData['photoUrl'];
    this.phoneNumber = mapData['phoneNumber'];
  }
}