import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:skype_clone/model_class/user_model.dart';
import 'package:skype_clone/provider/image_upload_provider.dart';
import 'package:skype_clone/resource/firebase_methods.dart';
import 'package:skype_clone/screens/chat_screens/chat_screens.dart';
import 'package:skype_clone/screens/wrapper.dart';
import 'package:skype_clone/screens/search_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: FirebaseMethod().user,
      child: ChangeNotifierProvider<ImageUploadProvider>(
        create: (context) => ImageUploadProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          initialRoute: '/',
          routes: {
            '/search_screen': (context) => SearchScreen(),
          },
          theme: ThemeData(
            brightness: Brightness.dark
          ),
          home: Wrapper(),
        ),
      ),
    );
  }
}
