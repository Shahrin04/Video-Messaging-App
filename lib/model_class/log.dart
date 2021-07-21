class Log{
  int logId;
  String callerName;
  String callerPic;
  String receiverName;
  String receiverPic;
  String callStatus;
  String timeStamp;

  Log({this.logId, this.callerName, this.callerPic, this.receiverName, this.receiverPic, this.callStatus, this.timeStamp});

  Map<String, dynamic> toMap(Log log){
    Map<String, dynamic> map = Map();
    map['logId'] = log.logId;
    map['callerName'] = log.callerName;
    map['callerPic'] = log.callerPic;
    map['receiverName'] = log.receiverName;
    map['receiverPic'] = log.receiverPic;
    map['callStatus'] = log.callStatus;
    map['timeStamp'] = log.timeStamp;
    return map;
  }

  Log.fromMap(Map<String, dynamic> map){
    this.logId = map['logId'];
    this.callerName = map['callerName'];
    this.callerPic = map['callerPic'];
    this.receiverName = map['receiverName'];
    this.receiverPic = map['receiverPic'];
    this.callStatus = map['callStatus'];
    this.timeStamp = map['timeStamp'];
  }
}