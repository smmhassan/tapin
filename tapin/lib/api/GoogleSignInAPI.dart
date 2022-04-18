import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInAPI {
  static final _clientIDWeb =
      '4063444522-cni1r4l0fg7mhnclr35vrnrr2j2f67lc.apps.googleusercontent.com';
  static final _googleSignIn = GoogleSignIn(/*clientId: _clientIDWeb*/);
  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();
  static Future logout() => _googleSignIn.disconnect();
}
