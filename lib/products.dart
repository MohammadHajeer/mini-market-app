import 'package:flutter/material.dart';
import 'package:mini_market_app/add_new_product.dart';
import 'package:mini_market_app/button.dart';
import 'package:mini_market_app/product.dart';

class Products extends StatelessWidget {
  const Products({super.key});

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
            margin: EdgeInsets.only(right: 50, left: 50, top: 10),
            child: Button(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const AddNewProduct()));
              },
              text: "اضف منتج",
            ),
          ),
        ],
      ),
    );
  }
}

// ListView(
//
// children: [
// );
// Product(),
// ],
