import 'package:flutter/material.dart';

class NoProductsFound extends StatelessWidget {

  const NoProductsFound({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.remove_shopping_cart,
            size: 100,
            color: Colors.grey,
          ),
          Text("لا يوجد اي منتج حاليا", style: TextStyle(fontSize: 25),),
        ],
      ),
    );
  }
}
