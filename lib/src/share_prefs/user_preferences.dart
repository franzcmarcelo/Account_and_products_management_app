import 'package:shared_preferences/shared_preferences.dart';

// FIXME: Patrón Singleton
class UserPreferences {

  static final UserPreferences _instance = new UserPreferences._internal();

  // Constructor Factory
  // En cuanto se cree una instancia, esto es lo que retornara
  factory UserPreferences(){
    return _instance;
  }

  UserPreferences._internal();

  SharedPreferences _prefs;

  initPrefs() async {
  // FIXME: Share Preferences (La data se guarda en el archivo SharedPreferences)
  // Permite lograr Persitencia de Datos para guardar las preferencias de usuaio
  // Para usarlo, declaramos una instancia de SharedPreferences
  // SharedPreferences _prefs = await SharedPreferences.getInstance();
  // Lo cual nos permite guardar multiples datos (se guardan con el tipo, el cual es el mismo con el que lo obtendremos)
    this._prefs = await SharedPreferences.getInstance();
  }

  // FIXME: Getters & Setters

  get token{
    // FIXME: Obtenemos la data
    return _prefs.getString('token') ?? '';
  }

  set token( String value ){
    // FIXME: Guardamos la data
    _prefs.setString('token', value);
  }

}