import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sign_in_page.dart';

class HomePage extends StatefulWidget {
  final String email;

  const HomePage({Key key, this.email}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
      ),
      body: SingleChildScrollView(
        padding: (screenWidth <= 305)
            ? EdgeInsets.symmetric(
                horizontal: 4.0,
              )
            : EdgeInsets.symmetric(
                horizontal: 24.0,
              ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 70.0,
            ),
            Center(
              child: Text('Hello, ${widget.email}'),
            ),
            SizedBox(
              height: 24.0,
            ),
            OutlinedButton(
              onPressed: () => _handleSignOut(context),
              child: Text(
                'Sign out',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _handleSignOut(BuildContext context) async {
    final _auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await _auth.signOut().then((value) {
       setState(() {
      prefs.remove('email');
      prefs.setBool("isLoggedIn", false);
    });
      return Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignInPage()));
    });
  }
}
