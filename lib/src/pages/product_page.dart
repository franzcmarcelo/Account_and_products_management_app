import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:form_validation/src/model/product_model.dart';
import 'package:form_validation/src/bloc/provider.dart';

import 'package:form_validation/src/utils/utils.dart' as utils;

class ProductPage extends StatefulWidget {

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool _saving = false;

  ProductsBloc productsBloc;

  ProductModel product = new ProductModel();

  PickedFile photo;

  @override
  Widget build(BuildContext context) {

    productsBloc = Provider.productsBloc(context);

    final ProductModel productArguments = ModalRoute.of(context).settings.arguments;
    if ( productArguments != null ) {
      product = productArguments;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _selectPhoto
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _takePhoto
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          // Form: Similar a un form de html
          child: Form(
            key: formKey,
            child: Column(
              children: [
                _showPhoto(),
                inputName(),
                SizedBox(height: 30.0,),
                inputPrice(),
                SizedBox(height: 50.0,),
                button(),
                SizedBox(height: 50.0,),
                available(),
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget inputName() {
    // Este TextFormField trabajara directamente con nuestro Form
    return TextFormField(
      initialValue: product.title,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Product'
      ),
      validator: (value){
        if (value.length <= 3) {
          // error
          return 'Ingrese el nombre del producto';
        } else {
          // sin problema
          return null;
        }
      },
      onSaved: (value) => product.title = value,
    );
  }

  Widget inputPrice() {
    return TextFormField(
      initialValue: product.value.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio'
      ),
      validator: (value){
        if ( !utils.isNumber(value) ) {
          // error
          return 'Solo números';
        } else{
          // sin problema
          return null;
        }
      },
      onSaved: (value) => product.value = double.parse(value),
    );
  }

  Widget button() {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      color: Colors.indigoAccent,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon(Icons.save),
      onPressed: (_saving) ?null :_submit,
    );
  }

  Widget available() {
    return SwitchListTile(
      value: product.available,
      title: Text('Disponible'),
      activeColor: Colors.indigoAccent,
      onChanged: (value){
        setState(() {
          product.available = value;
        });
      }
    );
  }

  void _submit() async {
    // Booleano que evalua si el formulario es valido
    // Si no es valido hace el return vacio
    if (!formKey.currentState.validate()) return;

    // Para ejecutar todos los metodos onSave()
    // Que guardan la data una vez sea valido el form
    formKey.currentState.save();

    setState(() { _saving = true; });

    // FIXME:
    if ( photo != null ){
      product.urlPhoto = await productsBloc.uploadPhoto(photo);
    }


    if ( product.id == null ) {
      // Mientras aún nisiquera el producto tiene un id (es nuevo)

      // FIXME: Firebase
      // Retorna un mapa que tiene un name que es id que asigna firebase
      // {name: -ME_yA_mhCCtS_6rNeXb}
      productsBloc.addProduct(product);
    } else {
      productsBloc.updateProduct(product);
    }

    // setState(() { _saving = false; });

    showSnackbar( 'Registro Guardado' );

    Navigator.pop(context);
  }

  void showSnackbar( String message ){
    final snackbar = SnackBar(
      content: Text(message),
      duration: Duration( milliseconds: 1500 ),
    );

    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  Widget _showPhoto(){
    // En cuanto se redibuja el widget
    // Consulta si la foto tiene urlPhoto, si lo tiene => lo carga
    // Sino no tiene:
    // Consulta si hay un path (por camara o galeria)
    // Si hay un path => muestra la imagen desde ese path
    // Si no hay => carga el no-image

    if ( product.urlPhoto != null ){
      return FadeInImage(
        image: NetworkImage(product.urlPhoto),
        placeholder: AssetImage('assets/jar-loading.gif'),
        fit: BoxFit.contain,
      );
    } else{
      return Image(
        // Si la foto tiene un valor, toma el path
        // Sino (si es null) toma el de assets
        image: AssetImage( photo?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );
    }
  }

  _selectPhoto() async {
    _processImage( ImageSource.gallery );
  }

  _takePhoto() async {
    _processImage( ImageSource.camera );
  }

  _processImage( ImageSource type ) async {
    final _picker = ImagePicker();

    // Esperamos a que el usuario tome una foto
    final pickedFile = await _picker.getImage(
      source: type,
      // source: ImageSource.camera,
      // source: ImageSource.gallery,
    );

    // Para manejar el error al cancelar la seleccion de una foto
    try {
      photo = PickedFile(pickedFile.path);
    } catch (e) {
      print('$e');
    }

    // Cuando el usuario selecciona una nueva foto
    if (photo != null) {
      // Borramos el url de la foto
      product.urlPhoto = null;
      // Y mediante sel setState de redibuja (ir a showPhoto => primer ejecutado al redibujarse)
    }

    setState(() {});
  }

}