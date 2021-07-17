

class UserModel{
  String uid;
  String email;
  String name;
  String photoUrl;
  String phoneNumber;
  int state;

  UserModel({this.uid, this.email, this.name, this.photoUrl, this.phoneNumber, this.state});

  Map toMap(UserModel userModel){
    var data = Map<String, dynamic>();
    data['uid'] = userModel.uid;
    data['email'] = userModel.email;
    data['name'] = userModel.name;
    data['photoUrl'] = userModel.photoUrl;
    data['phoneNumber'] = userModel.phoneNumber;
    data['state'] = userModel.state;
  }

  UserModel.fromMap(Map<String, dynamic> mapData){
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.name = mapData['name'];
    this.photoUrl = mapData['photoUrl'];
    this.phoneNumber = mapData['phoneNumber'];
    this.state = mapData['state'];
  }
}