import 'package:flutter/material.dart';

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
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_shopping_cart,
            size: 100,
            color: Colors.grey,
          ),
          Text("لا يوجد اي منتج حاليا"),
        ],
      ),
    );
  }
}
