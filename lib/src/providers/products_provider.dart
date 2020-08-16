import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

import 'package:mime_type/mime_type.dart';

import 'package:form_validation/src/model/product_model.dart';
import 'package:form_validation/src/share_prefs/user_preferences.dart';

class ProductProvider {

  final String _url = 'https://flutter-my-apps.firebaseio.com';

  // Para leer el idToken, ya que ahora nuestras reglas de database (read & write) son: ej: "read: auth != null"
  // Es decir mientras no este autenticado no podra hacr read ni write
  final _prefs = new UserPreferences();

  // CREATE
  Future<bool> createProduct( ProductModel product ) async {
    final url = '$_url/products.json?auth=${_prefs.token}';
    // productModelToJson proporcionado por nuestro modelo regresa un String
    final res = await http.post( url, body: productModelToJson(product));

    final decodedData = json.decode(res.body);
    print('CREATE: $decodedData');

    return true;
  }

  // UPDATE
  Future<bool> updateProduct( ProductModel product ) async {
    final url = '$_url/products/${product.id}.json?auth=${_prefs.token}';

    final res = await http.put( url, body: productModelToJson(product));

    final decodedData = json.decode(res.body);
    print('UPDATE: $decodedData');

    return true;
  }

  // READ
  Future<List<ProductModel>> readProducts() async {
    final url = '$_url/products.json?auth=${_prefs.token}';
    final res = await http.get(url);

    final Map<String,dynamic> decodedData = json.decode(res.body);
    print('READ:');
    // print(decodedData);
    // > {-ME_yA_mhCCtS_6rNeXb: {available: true, title: reloj, value: 293.0}, {}, ...

    final List<ProductModel> products = new List();

    if ( decodedData == null ) return [];

    // FIXME:
    // Para manejar cuando expire el token
    // Si el decodede Data trae un error
    if ( decodedData['error'] != null ) {
      print('ERROR: Token Expirado!');
      return [];
    }

    decodedData.forEach((id, product) {
      print('Product: ${product['title']}');
      // > {available: true, title: reloj, value: 293.0}
      final productTemp = ProductModel.fromJson(product);
      productTemp.id = id;
      products.add(productTemp);
    });

    return products;
  }

  // DELETE
  Future<int> deleteProduct( String id) async {
    final url = '$_url/products/$id.json?auth=${_prefs.token}';
    final res = await http.delete(url);
    if ( res.statusCode == 200) {
      print('SUCCESS DELETE');
    }
    return 1;
  }

  /// FIXME: Cloudinary Service
  /// Recibe la image de tipo File
  /// Devuelve el secure_url proporcionado por cloudinary
  Future<String> uploadImage( PickedFile image ) async {
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dkhavd5n6/image/upload?upload_preset=chddwgb0');
    // Para saber el tipo de la imagen (mimeType, del package mime_type)
    final mimeType = mime(image.path).split('/');
    // mime(image.path) devuelve: //type/subtype ej:image/jpeg
    // Lo separamos en la lista mimeType mediante un split tomando el /, en una lista con [type, subtype] ej:[image, jpeg]

    // Creamos el request
    final imageUploadRequest = http.MultipartRequest(
      'POST',
      url
    );

    // Creamos el archivo (imagen) y definimos los parametros del body (como en postman)
    final file = await http.MultipartFile.fromPath(
      'file',
      image.path,
      // Tambien especificamos el contentType
      // MediaType(type, subtype) => (image, jpeg) (del package http_parser)
      contentType: MediaType(mimeType[0], mimeType[1])
    );

    // Adjuntamos nuestro archivo a nuestro Request
    imageUploadRequest.files.add(file);

    // FIXME: Ejecutamos
    // Disparamos la peticion
    final streamResponse = await imageUploadRequest.send();
    final res = await http.Response.fromStream(streamResponse);

    if ( res.statusCode != 200 && res.statusCode != 201 ) {
      print('Algo salio mal');
      print(res.body);
      return null;
    }

    final resData = json.decode(res.body);
    print('Cloudinary Service');
    print('Image Upload Successful');
    print('Secure_url: ${resData['secure_url']}');
    // > {assts_id, public_id, version, version_id, signature, width, height, format, resource_type,
    // create_at, tags, bytes, type, etag, placeholder, url, secure_url, original_filename}

    return resData['secure_url'];
  }

}