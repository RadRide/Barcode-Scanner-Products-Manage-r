import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Product{
  int? code, quantity;
  double? price;
  String? name, description;
  Product({this.code, this.name, this.description, this.price, this.quantity});

  bool isEmpty(){
    return code == null || quantity == null || price == null
        || name == null || name == '' || description == null || description == '';
  }

  @override
  String toString() {
    return "Code: $code, Name: $name, Price: \$$price, Quantity: $quantity, Description: $description";
  }
}

// DB Password = barcodeScanner-410Project
// DB Name = id21659372_barcode_scanner_db
// DB Username = id21659372_assaf147

String baseURL = "410api.000webhostapp.com";

void getProducts(Function(bool success) update) async{
  try{
    final url = Uri.http(baseURL, 'barcodeScanner/getProducts.php');
    print(url);
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    products.clear();
    if(response.statusCode == 200){
      final jsonResponse = convert.jsonDecode(response.body);
      for(var row in jsonResponse){
        products.add(Product(code: int.parse(row['code']), name: row['name'],
            description: row['description'], price: double.parse(row['price']),
            quantity: int.parse(row['quantity'])));
      }
    }
    update(true);
  }catch(e){
    update(false);
  }
}

void insertProduct(Product product, Function(bool success, String message) update) async{
  try{
    final url = Uri.http(baseURL, "barcodeScanner/insertProduct.php");
    var response = await http.post(url, body: {
      "code" : product.code.toString(),
      "name" : product.name,
      "description" : product.description,
      "price" : product.price.toString(),
      "quantity" : product.quantity.toString()
    });
    print(response.body);
    var result = convert.jsonDecode(response.body);
    print(result.toString());
    if(result.toString() != "Product Already Available" || result.toString() == "Success"){
      update(true, "Product Added Successfully");
    }else if(result.toString() == "Product Already Available"){
      update(false, "Product Already Available");
    }
  }catch(e){
    print(e.toString());
    update(false, "Error Adding Product");
  }
}

void updateProduct(Product product, Function(bool success, String message) update) async {
  try {
    final url = Uri.http(baseURL, "barcodeScanner/updateProduct.php");
    var response = await http.post(url, body: {
      "code": product.code.toString(),
      "name": product.name,
      "description": product.description,
      "price": product.price.toString(),
      "quantity": product.quantity.toString()
    });
    var result = convert.jsonDecode(response.body);
    if (result.toString() == "Success") {
      update(true, "Product Updated Successfully");
    }
  } catch (e) {
    print(e.toString());
    update(true, "Error Updating Product");
  }
}

void deleteProduct(Product product, Function(bool success) update) async{
  try {
    final url = Uri.http(baseURL, "barcodeScanner/deleteProduct.php");
    var response = await http.post(url, body: {
      "code": product.code.toString(),
    });
    var result = convert.jsonDecode(response.body);
    if (result.toString() == "Success") {
      update(true);
    }
  } catch (e) {
    print(e.toString());
    update(false);
  }
}

void checkProduct(String code, Function(Product product, bool found) redirect) async{
  try {
    final url = Uri.http(baseURL, "barcodeScanner/checkProduct.php");
    var response = await http.post(url, body: {
      "code": code,
    });
    var result = convert.jsonDecode(response.body);
    if (result.toString() != "Not Found") {
      Product product = Product(
        code: int.parse(result[0]['code']),
        name: result[0]['name'],
        description: result[0]['description'],
        price: double.parse(result[0]['price']),
        quantity: int.parse(result[0]['quantity'])
      );
      redirect(product,true);
    }else{
      redirect(Product(code: int.parse(code)), false);
    }
  } catch (e) {
    print(e.toString());
    redirect(Product(), false);
  }
}

List<Product> products = [];