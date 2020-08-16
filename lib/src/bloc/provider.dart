import 'package:flutter/material.dart';

import 'package:form_validation/src/bloc/login_bloc.dart';
export 'package:form_validation/src/bloc/login_bloc.dart';

import 'package:form_validation/src/bloc/products_bloc.dart';
export 'package:form_validation/src/bloc/products_bloc.dart';

class Provider extends InheritedWidget{

  // FIXME:
  // InheritedWidget: un widget que almacena informacion
  // Provider: Gracias a que este es el padre de toda nuestra app (/main), sus hijos
  // van a poder buscarlo y asu vez extraer la informacion que se encuentra alamacenada en el

  // Cada vez que se quiere redibujar el widget (hot reload), el widget llama
  // al constructor del provider (que inicializo el bloc) y si ya se tiene una instancia la retorna

  // Implementación del Patrón Singleton para solucionar el problema de volver a inicializar
  // una instancia de LoginBloc cada vez que hacemos hot reload

  // Blocs
  final loginBloc = new LoginBloc();
  final _productsBloc = new ProductsBloc();

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

  @override
  // Al actualizarse debe notificar a sus hijos?
  bool updateShouldNotify( InheritedWidget oldWidget ) => true;

  // FIXME:
  // Instrucciones para buscar el Provider en el arbol de widgets
  // Toma el contexto (arbol de widgets) y
  // busca un Widget con exactamente el mismo tipo de Provider

  // Regresa un LoginBloc
  static LoginBloc of( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>().loginBloc;
  }

  // Rergesa un ProductsBloc
  static ProductsBloc productsBloc( BuildContext context ){
    return context.dependOnInheritedWidgetOfExactType<Provider>()._productsBloc;
  }

}