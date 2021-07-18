import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/enum/user_state.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/provider/user_provider.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/screens/call_screen/pickup/pickup_layout.dart';
import 'package:skype_clone/screens/pages/chat_list_screen.dart';
import 'package:skype_clone/utils/universal_variables.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with WidgetsBindingObserver {
  double _titleFontSize = 10;
  int _page = 0;
  PageController pageController;

  final FirebaseRepository _firebaseRepository = FirebaseRepository();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _firebaseRepository.setUserState(
          uid: _auth.currentUser.uid, userState: UserState.online);
    });

    WidgetsBinding.instance.addObserver(this);

    pageController = PageController();

  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final user = Provider.of<UserModel>(context);

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
        user.uid != null
            ? _firebaseRepository.setUserState(
                uid: user.uid, userState: UserState.offline)
            : print('detached state');
        break;
      case AppLifecycleState.inactive:
        user.uid != null
            ? _firebaseRepository.setUserState(
                uid: user.uid, userState: UserState.offline)
            : print('inactive state');
        break;
      case AppLifecycleState.paused:
        user.uid != null
            ? _firebaseRepository.setUserState(
                uid: user.uid, userState: UserState.waiting)
            : print('paused state');
        break;
      case AppLifecycleState.resumed:
        user.uid != null
            ? _firebaseRepository.setUserState(
                uid: user.uid, userState: UserState.online)
            : print('resumed state');
        break;

    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
    return PickupLayout(
      scaffold: Scaffold(
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
      ),
    );
  }
}
