class Call {
  String callerId;
  String callerName;
  String callerPhoto;
  String receiverId;
  String receiverName;
  String receiverPhoto;
  String channelId;
  bool hasDialed;

  Call({this.callerId,
    this.callerName,
    this.callerPhoto,
    this.receiverId,
    this.receiverName,
    this.receiverPhoto,
    this.channelId,
    this.hasDialed});

  Map<String, dynamic> toMap(Call call) {
    Map<String, dynamic> map = Map();

    map['caller_id'] = call.callerId;
    map['caller_name'] = call.callerName;
    map['caller_photo'] = call.callerPhoto;
    map['receiver_id'] = call.receiverId;
    map['receiver_name'] = call.receiverName;
    map['receiver_photo'] = call.callerPhoto;
    map['channel_id'] = call.channelId;
    map['has_dialed'] = call.hasDialed;

    return map;
  }

  Call.fromMap(Map<String, dynamic> map) {
    this.callerId = map['caller_id'];
    this.callerName = map['caller_name'];
    this.callerPhoto = map['caller_photo'];
    this.receiverId = map['receiver_id'];
    this.receiverName = map['receiver_name'];
    this.channelId = map['channel_id'];
    this.hasDialed = map['has_dialed'];
  }
}
