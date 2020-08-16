import 'package:flutter/material.dart';
import 'package:form_validation/src/bloc/products_bloc.dart';
import 'package:form_validation/src/bloc/provider.dart';

import 'package:form_validation/src/model/product_model.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final productsBloc = Provider.productsBloc(context);
    productsBloc.loadProducts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home')
      ),
      body: _listProducts(productsBloc),
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

  Widget _listProducts( ProductsBloc productsBloc ) {
    return StreamBuilder(
      stream: productsBloc.productsStream ,
      builder: (BuildContext context, AsyncSnapshot<List<ProductModel>> snapshot){

        if (snapshot.hasData) {

          final products = snapshot.data;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index){
              return _item(context, productsBloc, products[index]);
            },
          );

        } else{
          return Center( child: CircularProgressIndicator() );
        }
      },
    );
  }

  Widget _item( BuildContext context, ProductsBloc productsBloc, ProductModel product ) {
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color: Colors.red,
      ),
      onDismissed: ( swipeDirection ) => productsBloc.deleteProduct(product.id),
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