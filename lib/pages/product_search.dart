import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mini_market_app/models/product.dart';
import 'package:mini_market_app/services/database_service.dart';
import 'package:mini_market_app/utils/utils.dart';
import 'package:mini_market_app/widgets/button.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class ProductSearch extends StatefulWidget {
  const ProductSearch({super.key});

  @override
  State<ProductSearch> createState() => _ProductSearchState();
}

class _ProductSearchState extends State<ProductSearch> {
  String barCode = "";
  final DatabaseService _databaseService = DatabaseService.instance;
  final player = AudioPlayer();

  void openBarCodeReader() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(
          lineColor: "teal",
          cancelButtonText: "الغاء",
        ),
      ),
    );

    if (res is String) {
      await player.play(AssetSource("beep.mp3"));
      setState(() {
        if (res.length < 5) {
          barCode = "";
          return;
        }
        barCode = res;
      });
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance
  //       .addPostFrameCallback((_) async => openBarCodeReader());
  // }

  Widget _foundProduct(ProductModel product) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.content_paste_search,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          Text(
            product.name,
            style: const TextStyle(fontSize: 40),
          ),
          Text(
            Utils().formatPrice(product.price),
            style:
                TextStyle(fontSize: 50, color: Theme.of(context).primaryColor),
          ),
          Text(
            product.barCode,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Button(
            onPressed: () => openBarCodeReader(),
            text: "ابحث عن منتج اخر",
            width: double.infinity,
          )
        ],
      ),
    );
  }

  Widget _productNotFound() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 100,
            color: Theme.of(context).primaryColor,
          ),
          const Text(
            "لم يتم العثور على المنتج",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            barCode,
            style:
                TextStyle(fontSize: 30, color: Theme.of(context).primaryColor),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Button(
            onPressed: () => openBarCodeReader(),
            text: "ابحث عن منتج اخر",
            width: double.infinity,
          )
        ],
      ),
    );
  }

  Widget _searchForProduct() {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.barcode_reader,
            size: 150,
            color: Colors.grey,
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Button(
            onPressed: () => openBarCodeReader(),
            text: "اضغط هنا للبحث عن منتج",
            width: double.infinity,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return barCode.isNotEmpty
        ? FutureBuilder<ProductModel?>(
            future: _databaseService.getProduct(barCode),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return const Text("حدث خطأ أثناء البحث عن المنتج");
              } else if (snapshot.hasData && snapshot.data != null) {
                ProductModel product = snapshot.data!;
                return _foundProduct(product);
              } else {
                return _productNotFound();
              }
            },
          )
        : _searchForProduct();
  }
}
