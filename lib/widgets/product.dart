import 'package:flutter/material.dart';
import 'package:mini_market_app/models/product.dart';
import 'package:mini_market_app/services/database_service.dart';
import 'package:mini_market_app/utils/utils.dart';
import 'package:mini_market_app/widgets/button.dart';

class Product extends StatefulWidget {
  const Product({super.key, required this.product, required this.onDelete});

  final VoidCallback onDelete;

  final ProductModel product;

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(widget.product.barCode),
      direction: DismissDirection.horizontal,
      onDismissed: (direction) async {
        if (direction == DismissDirection.endToStart) {
          ScaffoldMessenger.of(context).clearSnackBars();
          await _databaseService.deleteProduct(widget.product.id);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تم حذف المنتج")),
          );
          widget.onDelete();
        } else if (direction == DismissDirection.startToEnd) {}
      },
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          print("END TO START");
        } else if (direction == DismissDirection.startToEnd) {
          print("START TO END");
        }
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  surfaceTintColor: Colors.white,
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: Text(
                    "تأكيد الحذف",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Divider(),
                      const Text(
                        "هل أنت متأكد من حذف هذا المنتج؟",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Button(
                            onPressed: () => Navigator.of(context).pop(false),
                            text: "إلغاء",
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Button(
                            onPressed: () => Navigator.of(context).pop(true),
                            text: "حذف",
                            width: MediaQuery.of(context).size.width * 0.3,
                          ),
                        ],
                      )
                    ],
                  ),
                  // actions: [
                  //
                  // ],
                ));
          },
        );
      },
      background: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.4),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.edit,
          color: Colors.white,
          size: 40,
        ),
      ),
      secondaryBackground: Container(
        color: Theme.of(context).primaryColor.withOpacity(0.4),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      child: Column(
        children: [
          TextButton(
              style: ButtonStyle(
                padding: MaterialStateProperty.all(EdgeInsets.zero),
                backgroundColor: MaterialStateProperty.all(Colors.white),
                overlayColor: MaterialStateProperty.all(
                    Theme.of(context).primaryColor.withOpacity(0.2)),
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
                  title: Text(widget.product.name),
                  subtitle: Text(
                    widget.product.barCode,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  leading: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
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
                          Text(
                            "ل.ل",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 14,
                                fontFamily: ""),
                          ),
                          Text(
                            Utils().formatPrice(widget.product.price),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                                fontFamily: ''),
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
      ), // Your custom product card widget
    );
  }
}
