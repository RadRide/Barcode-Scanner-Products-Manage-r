import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'product.dart';

class ProductEditor extends StatefulWidget {
  ProductEditor({required this.isEditing, required this.isNew, required this.product, super.key});

  Product product;
  bool isEditing, isNew;

  @override
  State<ProductEditor> createState() => _ProductEditorState();
}

class _ProductEditorState extends State<ProductEditor> {

  double spacing = 20;

  void update(bool success, String message){

    if(success){
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? widget.product.code == null ? 'Add Product' : 'Edit Product' : 'View Product'),
      ),
      backgroundColor: Colors.grey[800],
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          child: widget.isEditing ? initializeEditor(widget.product) : initializeViewer(widget.product, spacing),
          ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){setState(() {
        if(widget.product.isEmpty()){
          showDialog(context: context, builder: (BuildContext context){
            return AlertDialog(
              title: Text('All Fields Must Be Filled', style: TextStyle(color: Colors.white),),
              backgroundColor: Colors.black,
              shape: Border.all(color: Colors.yellow, width: 3),
              icon: Icon(Icons.info_outline_rounded),
              iconColor: Colors.yellow,
            );
          });
        }else{
          if(widget.isNew){
            insertProduct(widget.product, update);
          }else{
            if(widget.isEditing){
              updateProduct(widget.product, update);
            }else{
              widget.isEditing = true;
            }
          }
        }
      });},
        backgroundColor: Colors.yellow[800],
        child: Text(widget.isEditing ? 'Save' : 'Edit'),
      ),
    );
  }
}

Widget initializeEditor(Product product){
  double spacing = 20;
  return Column(
    children: [
      SizedBox(height: spacing,),
      initializeCodeField(product),
      SizedBox(height: spacing,),
      TextField(
        controller: TextEditingController(text: product.name ?? ''),
        decoration: InputDecoration(labelText: "Enter Name",),
        style: TextStyle(color: Colors.white),
        onChanged: (name){
          product.name = name;
        },
      ),
      SizedBox(height: spacing,),
      TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))],
        controller: TextEditingController(text: product.price == null ? '' : product.price.toString()),
        decoration: InputDecoration(labelText: "Enter Price",),
        style: TextStyle(color: Colors.white),
        onChanged: (price){
          product.price = price == '' ? 0: double.parse(price);
        },
      ),
      SizedBox(height: spacing,),
      TextField(
        keyboardType: TextInputType.multiline,
        maxLines: 6,
        controller: TextEditingController(text: product.description == null ? '' : product.description),
        decoration: InputDecoration(labelText: "Enter Description",),
        style: TextStyle(color: Colors.white),
        onChanged: (description){
          product.description = description;
        },
      ),
      SizedBox(height: spacing,),
      TextField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: TextEditingController(text: product.quantity == null ? '' : product.quantity.toString()),
        decoration: InputDecoration(labelText: "Enter Quantity",),
        style: TextStyle(color: Colors.white),
        onChanged: (quantity){
          product.quantity = quantity == '' ? 0 : int.parse(quantity);
        },
      )
    ],
  );
}

Widget initializeCodeField(Product product){
  return product.code != null ? Text('Product Code: ${product.code}', style: TextStyle(color: Colors.yellow[700], fontSize: 15),)
      :
    TextField(
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      controller: TextEditingController(text: product.code == null ? '' : product.code.toString()),
      decoration: InputDecoration(labelText: "Enter Code",),
      style: TextStyle(color: Colors.white),
      onChanged: (c){
        product.code = c == '' ? 0 : int.parse(c);
      },
    );
}

Widget initializeViewer(Product product, double spacing){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: spacing,),
      displayText('Code:', product.code.toString()),
      SizedBox(height: spacing,),
      displayText('Name:', product.name.toString()),
      SizedBox(height: spacing,),
      displayText('Price:', product.price.toString()),
      SizedBox(height: spacing,),
      displayText('Description:', product.description.toString()),
      SizedBox(height: spacing,),
      displayText('Quantity:', product.quantity.toString()),
    ],
  );
}

Widget displayText(String title, String data){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, decoration: TextDecoration.underline),),
      Container(
          child: Text(data, style: TextStyle(fontSize: 22, color: Colors.yellow[700]), softWrap: true,),
          padding: EdgeInsets.only(left: 20),
      ),
    ],
  );
}