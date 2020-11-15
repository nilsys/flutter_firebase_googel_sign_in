import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart';

class SignInPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
    return Scaffold(
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
            _Title(screenWidth: screenWidth),
            SizedBox(
              height: 24.0,
            ),
            _Subtitle(screenWidth: screenWidth),
            SizedBox(
              height: 42.0,
            ),
            _SignInButtons(screenWidth: screenWidth),
          ],
        ),
      ),
    );
  }
}

class _SignInButtons extends StatefulWidget {
  final double screenWidth;

  const _SignInButtons({Key key, this.screenWidth}) : super(key: key);

  @override
  __SignInButtonsState createState() => __SignInButtonsState();
}

class __SignInButtonsState extends State<_SignInButtons> {
  @override
  Widget build(BuildContext context) {
    return _buildGoogleSignButton(widget.screenWidth, context);
  }

  Widget _buildGoogleSignButton(double screenWidth, BuildContext context) {
    return SizedBox(
      width: (screenWidth <= 262) ? (screenWidth) : (screenWidth / 1.1),
      child: Card(
        //color: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            8.0,
          ),
          side: BorderSide(
            color: Colors.grey,
            width: 1.0,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _handleSignIn(context),
          // onTap: () async {
          //   final auth = Provider.of<Authintication>(context, listen: false);
          //   await auth.signInWithGoogle(context);
          // },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: (screenWidth <= 264)
                ? Wrap(
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png',
                        height: 24.0,
                        width: 24.0,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png',
                        height: 24.0,
                        width: 24.0,
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  void _handleSignIn(BuildContext context) {
    setState(() {
       _signInWithGoogle(context);
    });
   
  }

  Future<UserCredential> _signInWithGoogle(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((value) {
      
        prefs.setBool("isLoggedIn", true);
        prefs.setString('email', value.user.email);
      return Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(email: value.user.email),
        ),
      );
    });
  }
}

class _Subtitle extends StatelessWidget {
  final double screenWidth;

  const _Subtitle({Key key, this.screenWidth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _buildSubtitle(screenWidth, context);
  }

  Widget _buildSubtitle(double screenWidth, [BuildContext context]) {
    return SizedBox(
      width: (screenWidth <= 262) ? (screenWidth) : (screenWidth / 1.1),
      child: Container(
        child: Center(
          child: Padding(
            padding: (screenWidth <= 260)
                ? EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                  )
                : EdgeInsets.only(
                    left: 4.0,
                    right: 4.0,
                  ),
            child: Text(
              'Please to continue using demo set up your account.',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final double screenWidth;

  const _Title({Key key, this.screenWidth}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return _buildTitle(screenWidth, context);
  }

  Widget _buildTitle(double screenWidth, [BuildContext context]) {
    return SizedBox(
      width: (screenWidth <= 262) ? (screenWidth) : (screenWidth / 1.1),
      child: Container(
        child: Center(
          child: Padding(
            padding: (screenWidth <= 260)
                ? EdgeInsets.only(
                    left: 24.0,
                    right: 24.0,
                  )
                : EdgeInsets.only(
                    left: 4.0,
                    right: 4.0,
                  ),
            child: Text(
              'Sign up / Sign in',
              style: GoogleFonts.viga(
                fontSize: 32.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
