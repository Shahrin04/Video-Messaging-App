import 'package:flutter/material.dart';
import 'package:skype_clone/constants/strings.dart';
import 'package:skype_clone/model_class/log.dart';
import 'package:skype_clone/resource/local_db/db/hive_methods.dart';
import 'package:skype_clone/resource/local_db/repository/log_repository.dart';
import 'package:skype_clone/screens/chat_screens/widget/cached_image.dart';
import 'package:skype_clone/screens/pages/chats/widgets/quiet_box.dart';
import 'package:skype_clone/utils/Utils.dart';
import 'package:skype_clone/widgets/customTile.dart';

class LogListContainer extends StatefulWidget {
  @override
  _LogListContainerState createState() => _LogListContainerState();
}

class _LogListContainerState extends State<LogListContainer> {
  getIcon(String callStatus) {
    Icon _icon;
    double iconSize = 15;

    switch (callStatus) {
      case CALL_STATUS_MISSED:
        _icon = Icon(Icons.call_missed, color: Colors.red, size: iconSize);
        break;
      case CALL_STATUS_RECEIVED:
        _icon = Icon(Icons.call_received, color: Colors.green, size: iconSize);
        break;
      default:
        _icon = Icon(Icons.call_made, color: Colors.grey, size: iconSize);
        break;
    }

    return Container(
      margin: EdgeInsets.only(right: 5),
      child: _icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: LogRepository.getLogs(),
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          List<dynamic> logList = snapshot.data;

          if (logList.isNotEmpty) {
            return ListView.builder(
              itemCount: logList.length,
              itemBuilder: (context, i) {
                Log _log = logList[i];
                bool hasDialled = _log.callStatus == CALL_STATUS_DIALED;

                return CustomTile(
                    leading: CachedImage(
                      hasDialled ? _log.receiverPic : _log.callerPic,
                      isRound: true,
                      radius: 45,
                    ),
                    mini: false,
                    title: Text(
                      hasDialled ? _log.receiverName : _log.callerName,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                      ),
                    ),
                    icon: getIcon(_log.callStatus),
                    subtitle: Text(
                        Utils.formatDateString(dateString: _log.timeStamp),
                        style: TextStyle(fontSize: 13)),
                    onLongPress: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text('Delete this Log ?'),
                              content: Text(
                                  'Are you sure you wish to delete this log ?'),
                              actions: [
                                FlatButton(
                                    onPressed: () async {
                                      Navigator.maybePop(context);
                                      await LogRepository.deleteLogs(i);
                                      if (mounted) {
                                        setState(() {});
                                      }
                                    },
                                    child: Text('Yes')),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.maybePop(context);
                                    },
                                    child: Text('No'))
                              ],
                            )));
              },
            );
          }
          return QuietBox(
            heading: "hlw This is where all your call logs are listed",
            subtitle: "Calling people all over the world with just one click",
          );
        }

        return QuietBox(
          heading: "hi This is where all your call logs are listed",
          subtitle: "Calling people all over the world with just one click",
        );
      },
    );
  }
}
