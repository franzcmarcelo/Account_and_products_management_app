import 'package:rxdart/rxdart.dart';
import 'package:image_picker/image_picker.dart';

import 'package:form_validation/src/model/product_model.dart';
import 'package:form_validation/src/providers/products_provider.dart';

class ProductsBloc {

  final _productsController = new BehaviorSubject<List<ProductModel>>();
  final _loadingController = new BehaviorSubject<bool>();

  final _productsProvider = new ProductProvider();

  // STREAMS
  // Leer data
  Stream<List<ProductModel>> get productsStream => _productsController.stream;
  Stream<bool> get loadingStream => _loadingController.stream;

  void loadProducts() async {
    final products = await _productsProvider.readProducts();
    // Añadirmos nuestro productos al Stream
    _productsController.sink.add(products);
  }

  void addProduct( ProductModel product ) async {
    // No agregamos ninguna informacion de products, solo manejamos el loading
    // mientras se esta creando un producto
    _loadingController.sink.add(true);
    await _productsProvider.createProduct(product);
    _loadingController.sink.add(false);
  }

  Future<String> uploadPhoto( PickedFile photo ) async {
    _loadingController.sink.add(true);
    final urlPhoto = await _productsProvider.uploadImage(photo);
    _loadingController.sink.add(false);
    return urlPhoto;
  }

  void updateProduct( ProductModel product ) async {
    _loadingController.sink.add(true);
    await _productsProvider.updateProduct(product);
    _loadingController.sink.add(false);
  }

  void deleteProduct( String id ) async {
    await _productsProvider.deleteProduct(id);
  }

  dispose() {
    // Si esto existe, entoces close()
    _productsController?.close();
    _loadingController?.close();
  }

}