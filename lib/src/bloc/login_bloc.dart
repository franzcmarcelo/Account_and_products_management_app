import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:form_validation/src/bloc/validators.dart';

class LoginBloc with Validators {

  // RXDart no trabajan con StreamControllers, sino con BehaviorSubject
  // Estos ya viene con broadcast incrustado, con lo de mas (stream, sink) siguen siendo compatibles

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();

  // Recuperar la data del Stream
  Stream<String> get emailStream => _emailController.stream.transform( validatorEmail );
  Stream<String> get passwordStream => _passwordController.stream.transform( validatorPassword );

  // e y p son los callbacks llamados al tener info de ambos streams (email y password)
  Stream<bool> get formValidStream =>
      Rx.combineLatest2(emailStream, passwordStream, (e, p) => true);

  // Insertar data al Stream
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  // Obtener el ultimo valor ingresado a los Streams
  // Esto gracias al BehaviorSubject
  String get email => _emailController.value;
  String get password => _passwordController.value;

  // Cerrar Streams
  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }

}