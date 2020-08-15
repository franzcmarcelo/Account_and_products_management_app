import 'package:form_validation/src/share_prefs/user_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

  // Correo de prueba: test@test.com / 123456

class UserProvider {

  final String _firebaseKey ='AIzaSyDHhwXdhGjM8iJWeIWgRvXRObw-XwkhXgY' ;

  final _prefs = new UserPreferences();

  Future<Map<String, dynamic>> newUser( String email, String password ) async {
    // body
    final authData = {
      'email'   : email,
      'password': password,
      'returnSecureToken': true
    };

    // Petición
    final res = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseKey',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedRes = json.decode(res.body);
    // print(decodedRes);
    // SUCCES > {kind, idToken, email, refreshToken}
    // ERORR > {error: {code: 400, message: EMAIL_EXISTS, errors: [{message: EMAIL_EXISTS, domain: global, reason: invalid}]}}

    if (decodedRes.containsKey('idToken')) {
      print('REGISTER SUCCESS idToken: ${decodedRes['idToken'].toString().substring(0, 11)}...');
      return { 'ok': true, 'idToken': decodedRes['idToken'] };
    } else {
      print('REGISTER ERROR:  message: ${decodedRes['error']['message']}');
      return { 'ok': false, 'message': decodedRes['error']['message'] };
    }
  }

  Future<Map<String, dynamic>> login( String email, String password ) async {

    // body
    final authData = {
      'email'   : email,
      'password': password,
      'returnSecureToken': true
    };

    // Petición
    final res = await http.post(
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseKey',
      body: json.encode(authData)
    );

    Map<String, dynamic> decodedRes = json.decode(res.body);
    // print(decodedRes);
    // SUCCESS: {kind, localId, email, idToken, ....}
    // ERROR: {error: {code: 400, message: EMAIL_EXISTS, errors: [{message: EMAIL_EXISTS, domain: global, reason: invalid}]}}

    if (decodedRes.containsKey('idToken')) {
      // Correo valido
      // FIXME: Salvamos el token en el storage
      _prefs.token = decodedRes['idToken'];

      print('LOGIN SUCCESS idToken: ${decodedRes['idToken'].toString().substring(0, 11)}...');
      return { 'ok': true, 'idToken': decodedRes['idToken'] };
    } else {
      print('LOGIN ERROR:  message: ${decodedRes['error']['message']}');
      return { 'ok': false, 'message': decodedRes['error']['message'] };
    }
  }


}