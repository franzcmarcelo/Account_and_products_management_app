import 'dart:async';

class Validators {

  final validatorEmail = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = new RegExp(pattern);

      if (regExp.hasMatch(data)) {
        sink.add(data);
      } else{
        sink.addError('Email incorreto');
      }

    },
  );

  final validatorPassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      // El Sink avisa a StreamTransformer que informacion sigue fluyendo
      // o que informacion necesito notificar que hay un error y hacer algo
      if ( data.length >= 6 ) {
        // Deja fluir esa data
        sink.add(data);
      } else{
        // Notifica el error
        sink.addError('El password tiene menos de 6 carácteres');
      }
    },
  );

}