import 'package:barcode_scanner/productEditor.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class ProductViewer extends StatefulWidget {
  const ProductViewer({super.key});

  @override
  State<ProductViewer> createState() => _ProductViewerState();
}

class _ProductViewerState extends State<ProductViewer> {

  bool isLoaded = false;

  @override
  void initState() {
    getProducts(update);
    super.initState();
  }

  void update(bool success){
    setState(() {
      isLoaded = true;
      if(!success){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error: Check Your Internet Connection.")));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Viewer"),
      ),
      body: isLoaded ? SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: products.map((product) => Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(border: Border.symmetric(horizontal: BorderSide(color: Color(0xff757575)))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name.toString(), style: TextStyle(fontSize: 20,color: Colors.yellow[800]),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Price: \$${product.price}', style: TextStyle(color: Colors.white),),
                          SizedBox(width: 20,),
                          Text('Quantity: ${product.quantity}', style: TextStyle(color: Colors.white),),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(onPressed: (){
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ProductEditor(isEditing: false, isNew: false, product: product))
                        ).then((value){
                          setState(() {
                            getProducts(update);
                          });
                        });
                      }, icon: Icon(Icons.remove_red_eye, color: Colors.yellow[800])),
                      IconButton(onPressed: (){
                        showDialog(context: context, builder: (BuildContext){
                          return AlertDialog(
                            backgroundColor: Colors.black,
                            title: Text('WARNING', style: TextStyle(color: Colors.white),),
                            content: Text('Are You Sure You Want to Delete \'${product.name}\'', style: TextStyle(color: Colors.white),),
                            actions: [
                              TextButton(onPressed: (){
                                setState(() {
                                  deleteProduct(product, update);
                                  getProducts(update);
                                });
                                Navigator.pop(context);
                              }, child: Text('Yes'), style: TextButton.styleFrom(foregroundColor: Colors.red[400]),),
                              TextButton(onPressed: (){Navigator.pop(context);}, child: Text('Cancel'),
                                  style: TextButton.styleFrom(foregroundColor: Colors.yellow[700])),
                            ],
                          );
                        });
                      }, icon: Icon(Icons.delete_forever, color: Colors.red[400],)),
                    ],
                  )
                ],
              ),
            )).toList(),
          )
        ),
      ) : Center(child: SizedBox(width: 100, height: 100, child: CircularProgressIndicator(color: Colors.yellow[800],),)),
    );
  }
}

