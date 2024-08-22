import 'package:flutter/material.dart';
import 'package:mini_market_app/models/product.dart';
import 'package:mini_market_app/utils/utils.dart';

class Product extends StatelessWidget {
  final ProductModel product;

  const Product({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
            style: ButtonStyle(
              padding: MaterialStateProperty.all(EdgeInsets.zero),
              backgroundColor: MaterialStateProperty.all(Colors.white),
              overlayColor:
                  MaterialStateProperty.all(Colors.teal.withOpacity(0.2)),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
            ),
            onPressed: () {},
            child: Container(
              margin: const EdgeInsets.only(bottom: 15),
              decoration: const BoxDecoration(color: Colors.transparent),
              child: ListTile(
                title: Text(product.name),
                subtitle: Text(product.barCode),
                leading: Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Icon(
                          Icons.edit_note,
                          color: Colors.white,
                        ),
                      ),
                    )),
                titleAlignment: ListTileTitleAlignment.center,
                trailing: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(5),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("ل.ل", style: TextStyle(color: Colors.teal, fontSize: 14),),
                        Text(
                          Utils().formatPrice(product.price),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ],
                    )),
              ),
            )),
        Divider(
          color: Colors.grey.withOpacity(0.3),
          thickness: 0,
          height: 1,
        )
      ],
    );
  }
}
