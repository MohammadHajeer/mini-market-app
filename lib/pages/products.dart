import 'package:flutter/material.dart';
import 'package:mini_market_app/models/product.dart';
import 'package:mini_market_app/utils/utils.dart';
import 'package:mini_market_app/widgets/button.dart';
import 'package:mini_market_app/widgets/no_products_found.dart';
import 'package:mini_market_app/widgets/product.dart';
import 'package:mini_market_app/services/database_service.dart';
import 'package:mini_market_app/widgets/text_form_field.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../data/fake_products.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  State<Products> createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  String barCode = "";
  bool productAlreadyExist = false;
  bool addedNewProduct = false;
  bool _loading = true;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void clearFields(StateSetter setState) {
    _nameController.clear();
    _priceController.clear();
    setState(() {
      barCode = "";
      productAlreadyExist = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _addProductButton(),
      body: FutureBuilder(
        future: _databaseService.getProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              ignoreContainers: true,
              child: ListView.builder(
                  itemCount: fakeProducts.length,
                  itemBuilder: (context, index) {
                    ProductModel product = fakeProducts[index];
                    return ListTile(
                      title: Text(fakeProducts[index].name),
                      subtitle: Text(product.barCode),
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
                                Utils().formatPrice(product.price),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 25),
                              ),
                            ],
                          )),
                    );
                  }),
            );
          } else {
            if (snapshot.hasError) {
              return const Text("Error");
            } else {
              if (snapshot.data!.isEmpty) {
                return const NoProductsFound();
              }
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    ProductModel product = snapshot.data![index];
                    return Product(
                      product: product,
                      onDelete: () {
                        if (snapshot.data!.length == 1) {
                          setState(() {});
                        }
                      },
                    );
                  });
            }
          }
        },
      ),
    );
  }

  Widget _addProductButton() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              return Directionality(
                  textDirection: TextDirection.rtl,
                  child: _showAlertDialog(context));
            });
      },
      child: const Icon(
        Icons.add_shopping_cart_outlined,
        color: Colors.white,
      ),
    );
  }

  Widget _showAlertDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter dialogState) {
        return PopScope(
          child: AlertDialog(
            surfaceTintColor: Colors.white,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                  20), // Set your desired border radius here
            ),
            icon: IconButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(Colors.grey.withOpacity(0.3)),
              ),
              onPressed: () async {
                var res = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SimpleBarcodeScannerPage(
                      lineColor: "teal",
                      cancelButtonText: "الغاء",
                    ),
                  ),
                );
                dialogState(() {
                  if (res is String) {
                    barCode = res;
                  }
                });
              },
              icon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    productAlreadyExist
                        ? "المنتج موجود"
                        : "انقر هنا لتصوير الباركود",
                    style: TextStyle(
                        color: productAlreadyExist ? Colors.red : Colors.black),
                  ),
                  Icon(
                    Icons.barcode_reader,
                    color: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "اضافة منتج",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                Row(
                  children: [
                    Text(
                      barCode,
                      style: const TextStyle(fontSize: 12),
                    ),
                    Icon(Icons.numbers, color: Theme.of(context).primaryColor),
                  ],
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: SizedBox(
                width: 300,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FormInput(
                        label: "الاسم",
                        placeHolder: "اسم",
                        icon: Icon(
                          Icons.label,
                          color: Theme.of(context).primaryColor,
                        ),
                        controller: _nameController,
                      ),
                      Divider(
                        color: Colors.grey.withOpacity(0.5),
                        thickness: 0,
                        indent: 100,
                        endIndent: 0,
                      ),
                      FormInput(
                        label: "السعر",
                        placeHolder: "ليرة",
                        icon: Icon(
                          Icons.price_change_outlined,
                          color: Theme.of(context).primaryColor,
                        ),
                        controller: _priceController,
                        type: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Button(
                        width: double.infinity,
                        onPressed: () async {
                          if (_formKey.currentState!.validate() &&
                              barCode.isNotEmpty &&
                              Utils().isNumeric(_priceController.text)) {
                            ProductModel? product =
                                await _databaseService.getProduct(barCode);
                            if (product == null) {
                              await _databaseService.insertProduct(
                                  _nameController.text,
                                  double.parse(_priceController.text),
                                  barCode);
                              clearFields(setState);
                              dialogState(() {
                                barCode = "";
                              });
                              if (!context.mounted) return;
                              _showProductAddedNotification(context);
                            } else {
                              dialogState(() {
                                productAlreadyExist = true;
                              });
                            }
                          }
                        },
                        text: "اضافة",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          onPopInvoked: (bool pop) {
            if (pop) {
              clearFields(dialogState);
            }
          },
        );
      },
    );
  }

  void _showProductAddedNotification(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  "تمت اضافة المنتج بنجاح",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
