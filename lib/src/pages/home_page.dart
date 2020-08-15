import 'package:flutter/material.dart';

// import 'package:form_validation/src/bloc/provider.dart';
import 'package:form_validation/src/model/product_model.dart';
import 'package:form_validation/src/providers/products_provider.dart';

class HomePage extends StatelessWidget {

  final productProvider = new ProductProvider();

  @override
  Widget build(BuildContext context) {

    // final bloc = Provider.of(context);
    // bloc.email & bloc.password

    return Scaffold(
      appBar: AppBar(
        title: Text('Home')
      ),
      body: _listProducts(),
      floatingActionButton: _button(context),
    );
  }

  Widget _button( BuildContext context ) {
    return FloatingActionButton(
      backgroundColor: Colors.indigoAccent,
      child: Icon(Icons.add),
      onPressed: () => Navigator.pushNamed(context, 'product')
    );
  }

  Widget _listProducts() {
    return FutureBuilder(
      future: productProvider.readProducts(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot) {
        if (snapshot.hasData) {
          final products = snapshot.data;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index){
              return _item(context, products[index]);
            },
          );
        } else{
          return Center( child: CircularProgressIndicator() );
        }
      },
    );
  }

  Widget _item( BuildContext context, ProductModel product ) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: ( swipeDirection ){
        productProvider.deleteProduct(product.id);
      },
      child: Column(
        children: [
          Card(
            child: Column(
              children: [
                ( product.urlPhoto == null )
                  ? Image(image: AssetImage('assets/no-image.png'))
                  : FadeInImage(
                      image: NetworkImage(product.urlPhoto),
                      placeholder: AssetImage('assets/jar-loading.gif'),
                      height: 300.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),

                  ListTile(
                    title: Text('${product.title} - S/.${product.value}'),
                    subtitle: Text(product.id),
                    onTap: () => Navigator.pushNamed(context, 'product', arguments: product),
                  ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }



}