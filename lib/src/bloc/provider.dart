import 'package:flutter/material.dart';

import 'package:form_validation/src/bloc/login_bloc.dart';
export 'package:form_validation/src/bloc/login_bloc.dart';

class Provider extends InheritedWidget{

  // Implementación del Patrón Singleton para solucionar el problema de
  // volver a inicializar una instancia de LoginBloc cada vez que
  // hacemos hot reload

  // Vamos a obtener la instancia del bloc, mediante este Provider
  // El cual es un InheritedWidget que inicialza el bloc


  // Cada vez que se quiere redibujar el widget (hot reload), el widget llama
  // al constructor del provider y si ya se tiene una instancia la retorna
  static Provider _instance;

  factory Provider({ Key key, Widget child }) {
    if ( _instance == null ) {
      // Definimos un construtor privador (_internal) para prevenir
      // que se pueda inicializar esta clase desde afuera
        _instance = new Provider._internal( key: key, child: child );
    }
    return _instance;
  }

  Provider._internal({ Key key, Widget child })
    : super(key: key, child: child);


  final loginBloc = LoginBloc();

  @override
  // Al actualizarse debe notificar a sus hijos?
  bool updateShouldNotify( InheritedWidget oldWidget ) => true;

  // Toma el contexto (arbol de widgets) y
  // busca un Widget con exactamente el mismo tipo de Provider
  static LoginBloc of( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

}