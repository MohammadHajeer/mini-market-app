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

  void openBarCodeReader() async {
    var res = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(),
      ),
    );

    if (res is String) {
      setState(() {
        barCode = res;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) async => openBarCodeReader());
  }

  Widget _foundProduct(ProductModel product) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.content_paste_search,
            size: 100,
            color: Colors.teal,
          ),
          Text(
            product.name,
            style: const TextStyle(fontSize: 40),
          ),
          Text(
            Utils().formatPrice(product.price),
            style: const TextStyle(fontSize: 50, color: Colors.teal),
          ),
          Text(
            product.barCode,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Button(onPressed: () => openBarCodeReader(), text: "ابحث عن منتج اخر")
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
          const Icon(
            Icons.search_off,
            size: 100,
            color: Colors.teal,
          ),
          const Text(
            "لم يتم العثور على المنتج",
            style: TextStyle(fontSize: 20),
          ),
          Text(
            barCode,
            style: const TextStyle(fontSize: 30, color: Colors.teal),
          ),
          const Divider(),
          const SizedBox(
            height: 10,
          ),
          Button(onPressed: () => openBarCodeReader(), text: "ابحث عن منتج اخر")
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
        : const Text("لم يتم العثور على الباركود");
  }
}
