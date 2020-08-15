import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    ProductModel({
        this.id,
        this.title = '',
        this.value = 0.0,
        this.available = true,
        this.urlPhoto,
    });

    String id;
    String title;
    double value;
    bool available;
    String urlPhoto;

    /// Recibe un mapa y asigna cada uno de los valores a mi modelo.
    /// Regresa una instancia del modelo.
    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id        : json["id"],
        title     : json["title"],
        value     : json["value"],
        available : json["available"],
        urlPhoto  : json["urlPhoto"],
    );

    /// Toma el modelo y lo genera a un Json
    Map<String, dynamic> toJson() => {
        // "id"        : id,
        "title"     : title,
        "value"     : value,
        "available" : available,
        "urlPhoto"  : urlPhoto,
    };
}
