import 'package:flutter/material.dart';
import 'package:mini_market_app/add_new_product.dart';
import 'package:mini_market_app/button.dart';
import 'package:mini_market_app/db_helper.dart';
import 'package:mini_market_app/product.dart';

class Products extends StatelessWidget {
  final DBHelper _dbHelper = DBHelper.instance;
  final VoidCallback function;

  Products({super.key, required this.function});

  Future<List> _fetchProducts() async {
    final products = await _dbHelper.getProducts();
    print(products.length);
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return true
        ? ListView(
            children: [
              Product(),
              ElevatedButton(onPressed: () {
                _fetchProducts();
              }, child: Text("PRESS ME"))
            ],
          )
        : NoProductsFound(
            changeIndex: function,
          );
  }
}

class NoProductsFound extends StatelessWidget {
  final VoidCallback changeIndex;

  const NoProductsFound({super.key, required this.changeIndex});

  // Future<void> _addProduct() async {
  //   await _dbHelper.insertProduct({
  //     'name': 'Apple',
  //     'price': 1.99,
  //     'bar_code': '123123123'
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.add_shopping_cart,
            size: 100,
            color: Colors.grey,
          ),
          const Text("لا يوجد اي منتج حاليا"),
          Container(
            margin: const EdgeInsets.only(right: 50, left: 50, top: 10),
            child: Button(
              onPressed: changeIndex,
              text: "اضف منتج",
            ),
          ),
        ],
      ),
    );
  }
}
