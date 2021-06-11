import 'package:flutter/material.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/resource/firebase_repository.dart';
import 'package:skype_clone/screens/chat_screens/chat_screens.dart';
import 'package:skype_clone/utils/Utils.dart';
import 'package:skype_clone/utils/universal_variables.dart';
import 'package:skype_clone/widgets/customTile.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  List<UserModel> userList;
  String query = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _repository.getCurrentUser().then((UserModel userModel) {
      _repository.fetchAllUsers(userModel).then((List<UserModel> list) {
        setState(() {
          userList = list;
          print(userList.length);
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          UniversalVariables.gradientColorStart,
          UniversalVariables.gradientColorEnd
        ])),
      ),
      leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context)),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight + 20),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            autofocus: true,
            cursorColor: UniversalVariables.blackColor,
            controller: searchController,
            onChanged: (value) {
              setState(() {
                query = value;
              });
            },
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 35,
            ),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search',
                hintStyle: TextStyle(
                    color: Color(0x88ffffff),
                    fontSize: 35,
                    fontWeight: FontWeight.bold),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                  onPressed: () => searchController.clear(),
                )),
          ),
        ),
      ),
    );
  }

  buildSuggestion(String query) {
    List<UserModel> suggestionList = query.isEmpty
        ? []
        : userList.where((UserModel user) {
            String _getUserName = Utils.getUserName(user.email)
                .toLowerCase(); //to create userName
            String _getName = user.name.toLowerCase();
            String _query = query.toLowerCase();

            bool matchesUserName = _getUserName.contains(_query);
            bool matchesName = _getName.contains(_query);

            return (matchesUserName || matchesName);
          }).toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          UserModel searchedUser = UserModel(
              uid: suggestionList[index].uid,
              name: suggestionList[index].name,
              email: Utils.getUserName(suggestionList[index].email),
              //to create userName
              photoUrl: suggestionList[index].photoUrl);

          return CustomTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChatScreen(searchedUser)));
              },
              mini: false,
              leading: CircleAvatar(
                backgroundColor: UniversalVariables.greyColor,
                backgroundImage: NetworkImage(searchedUser.photoUrl),
              ),
              title: Text(
                searchedUser.email,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(searchedUser.name,
                  style: TextStyle(color: UniversalVariables.greyColor)));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      appBar: searchAppBar(context),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: buildSuggestion(query),
      ),
    );
  }
}
