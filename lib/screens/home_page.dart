import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skype_clone/screens/pages/chat_list_screen.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  double _titleFontSize = 10;
  int _page = 0;
  PageController pageController;

  @override
  void initState() {
    super.initState();
    setState(() {
      pageController = PageController();
    });
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Center(
            child: ChatListScreen(),
          ),
          Center(
            child: Text(
              'Call Logs',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Center(
            child: Text(
              'Contact Screen',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: CupertinoTabBar(
              backgroundColor: UniversalVariables.blackColor,
              onTap: navigationTapped,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat,
                    color: (_page == 0)
                        ? UniversalVariables.blueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    'Chat',
                    style: TextStyle(
                        fontSize: _titleFontSize,
                        color: (_page == 0)
                            ? UniversalVariables.blueColor
                            : UniversalVariables.greyColor),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.call,
                    color: (_page == 1)
                        ? UniversalVariables.blueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    'Call',
                    style: TextStyle(
                        fontSize: _titleFontSize,
                        color: (_page == 1)
                            ? UniversalVariables.blueColor
                            : UniversalVariables.greyColor),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.contact_phone,
                    color: (_page == 2)
                        ? UniversalVariables.blueColor
                        : UniversalVariables.greyColor,
                  ),
                  title: Text(
                    'Contacts',
                    style: TextStyle(
                        fontSize: _titleFontSize,
                        color: (_page == 2)
                            ? UniversalVariables.blueColor
                            : UniversalVariables.greyColor),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}
