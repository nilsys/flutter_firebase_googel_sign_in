import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'home_page.dart';
import 'sign_in_page.dart';

SharedPreferences prefs;
String email;
bool isLoggedIn;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.oxygenTextTheme(
          Theme.of(context).textTheme,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: StadiumBorder(),
            side: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
      home: App(),
    );
  }
}

class App extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('snapshot.hasError');
          return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          print('ConnectionState.done');
          return SplashScreen();
        }
        print('===> ${snapshot.hasData}');
        return Loading();
      },
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Something went wrong!'),
          SizedBox(
            height: 8.0,
          ),
          OutlinedButton(
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => App(),
              ),
            ),
            child: Text('Try again!'),
          )
        ],
      ),
    );
  }
}

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() async {
    // Wait for async to complete
    await _checkPrefs();
    // Then open MainPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(
          email: email,
          isLoggedIn: isLoggedIn,
        ),
      ),
    );
  }

  Future<void> _checkPrefs() async {
    prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email') ?? '_';
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    print(email);
    print(isLoggedIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Text(
          'Demo',
          style: GoogleFonts.viga(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 32.0,
          ),
        ),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  final String email;
  final bool isLoggedIn;

  const MainPage({Key key, this.email, this.isLoggedIn}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return (email == '_' || isLoggedIn == false)
        ? SignInPage()
        : HomePage(
            email: email,
          );
  }
}
