import 'package:flutter/material.dart';
import 'package:skype_clone/screens/call_screen/pickup/pickup_layout.dart';
import 'package:skype_clone/screens/pages/logs/widget/floating_column.dart';
import 'package:skype_clone/screens/pages/logs/widget/log_list_container.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/skype_appbar.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold: Scaffold(
            backgroundColor: UniversalVariables.blackColor,
            appBar: SkypeAppBar(
              title: 'Calls',
              actions: [
                IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    onPressed: () =>
                        Navigator.pushNamed(context, '/search_screen')),
              ],
            ),
            floatingActionButton: FloatingColumn(),
            body: Padding(
              padding: EdgeInsets.only(left: 15),
              child: LogListContainer(),
            )));
  }
}
