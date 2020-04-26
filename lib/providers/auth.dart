import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyCfR8UunEm97s3t-V2_0tKD0ZsZ64u4av0';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      // {error: {code: 400, message: EMAIL_EXISTS,
      //    errors: [{message: EMAIL_EXISTS, domain: global, reason: invalid}]}}
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        // throw error message
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseData['expiresIn']),
        ),
      );

      // getInstance() return future so we need to add await
      // so we can save real access in "preference" instead of Future value.
      // we can also use json.encode so save data into "SharedPreferences".
      final preference = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': _token,
          'userId': _userId,
          'expireDate': _expiryDate.toIso8601String(),
        },
      );
      preference.setString('userData', userData);
      // set auto logout here show we can logout automatically after timer expire.
      _autoLogout();
      notifyListeners();
    } catch (error) {
      throw error;
      //return Future.error(error);
    }
  }

  Future<void> signup(String email, String password) async {
    // we need to add return as __authenticate will return Future
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoLogin() async {
    final preference = await SharedPreferences.getInstance();
    if (!preference.containsKey('userData')) {
      return false;
    }
    // Here "preference.getString('userData')" return string so we need to convert that into MAP.
    final extractUserData =
        json.decode(preference.getString('userData')) as Map<String, Object>;
    // - Need to parse expireDate to compare date using DateTime.parse as we are store
    //   date using _expiryDate.toIso8601String();
    final expiryDate = DateTime.parse(extractUserData['expireDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractUserData['token'];
    _userId = extractUserData['userId'];
    _expiryDate = expiryDate;
    _autoLogout();
    notifyListeners();
    return true;
  }

  // we convert this function to async so we can clear shared preference
  Future<void> logout() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final preference = await SharedPreferences.getInstance();
    preference.clear();
    notifyListeners();
  }

  void _autoLogout() {
    // Remaining time calculation.
    // Here we need to handle if any ongoing timer running and user logout. in this we need to clear the timer first.
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}

//  1) {kind: identitytoolkit#SignupNewUserResponse,
//        idToken: eyJhbGciOiJSUzI1NiIsImtpZCI6IjVlOWVlOTdjODQwZjk3ZTAyNTM2ODhhM2I3ZTk0NDczZTUyOGE3YjUiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vZmlyLXByb2R1Y3QtZTUyYjgiLCJhdWQiOiJmaXItcHJvZHVjdC1lNTJiOCIsImF1dGhfdGltZSI6MTU4Nzc5OTQwOSwidXNlcl9pZCI6IlFtcDdRZEd0QUZYRTJBT1Y2anB2U2VBWDZRbzIiLCJzdWIiOiJRbXA3UWRHdEFGWEUyQU9WNmpwdlNlQVg2UW8yIiwiaWF0IjoxNTg3Nzk5NDA5LCJleHAiOjE1ODc4MDMwMDksImVtYWlsIjoidGVzdEBnbWFpbC5jb20iLCJlbWFpbF92ZXJpZmllZCI6ZmFsc2UsImZpcmViYXNlIjp7ImlkZW50aXRpZXMiOnsiZW1haWwiOlsidGVzdEBnbWFpbC5jb20iXX0sInNpZ25faW5fcHJvdmlkZXIiOiJwYXNzd29yZCJ9fQ.UbVg8stfnAobb6PJS3m1RbDtPfbv-avy5ycg9WHlUgH16GE9ActAvVne5UvO_1bYXgtKCUZZD94hOCyaLpPVfSqIfl2jEmeGo6jk0sewKZJ-MMk2CafO3gLLV2jHqE4ubMQTYU8hkdyB57LsSngH49iN2qHeL5sys1BXM_I1EL8qlCZ3ShZ30nxGiwA6WY9WEemgfYQ0gtDUBhCUsPdDVBNtKJmryRen2U7hH7Y3j5uLxDxxwJ
//        -llJKgIb65Yo-vhJXDpFzM8YAali0a30R217CwX57pkVq1xIj4OsETpzImIfaqqbtMLxFN3a93OuFOGVcHYuNEUb_oI9ZbaeZ7oQ,
//        email: test@gmail.com, refreshToken: AE0u-Ndd7eso8

//  2) - When we are using same email to register again response.
//        I/flutter (16773): {error: {code: 400, message: EMAIL_EXISTS,
//        errors: [{message: EMAIL_EXISTS, domain: global, reason: invalid}]}}

// signup - https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[API_KEY]
// signin - https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[API_KEY]
// here we get API_KEY from firebase project setting screen
// Web API Key: AIzaSyCfR8UunEm97s3t-V2_0tKD0ZsZ64u4av0
