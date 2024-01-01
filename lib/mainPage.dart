import 'package:barcode_scanner/product.dart';
import 'package:barcode_scanner/productEditor.dart';
import 'package:barcode_scanner/productViewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  double spacing = 20;

  void redirect(Product product, bool found){
    if(found){
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditor(isEditing: false, isNew: false, product: product)));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditor(isEditing: true, isNew: true, product: product)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Product Manager"),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MenuButton(
                label: "Scan Product",
                icon: Icons.camera_alt_outlined,
                onPressed: () async {
                  String scanResult;
                  try{
                    scanResult  = await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE);
                  } on PlatformException{
                    scanResult = '';
                  }
                  if(!mounted){print("Nothing Found!!!\n");}
                  if(scanResult != '-1'){
                    checkProduct(scanResult, redirect);
                  }
                }
            ),
            SizedBox(height: spacing,),
            MenuButton(
                label: "Add Product Manually",
                icon: Icons.add,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductEditor(isEditing: true, isNew: true, product: Product())));
                }
            ),
            SizedBox(height: spacing,),
            MenuButton(
                label: "Show Products",
                icon: Icons.paste_rounded,
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ProductViewer()));
                }
            ),
          ],
        ),
      ),
    );;
  }
}


class MenuButton extends StatelessWidget {

  MenuButton({required this.label, required this.icon, required this.onPressed, super.key});

  String label;
  IconData icon;
  Function onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: (){onPressed();},
      icon: Icon(icon, color: Colors.black,),
      label: Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
      style: TextButton.styleFrom(
          backgroundColor: Colors.yellow[800],
          foregroundColor: Colors.black,
          fixedSize: Size(250, 40),
      ),
    );
  }
}