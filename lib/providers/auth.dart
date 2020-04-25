import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  String _userId;
  DateTime _expiryDate;

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
