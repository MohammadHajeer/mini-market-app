import 'package:flutter/material.dart';
import 'package:mini_market_app/models/product.dart';
import 'package:mini_market_app/utils/utils.dart';
import 'package:mini_market_app/widgets/button.dart';
import 'package:mini_market_app/widgets/product.dart';
import 'package:mini_market_app/services/database_service.dart';
import 'package:mini_market_app/widgets/text_form_field.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

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
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasError) {
              return const Text("Error");
            } else {
              return ListView.builder(
                  itemCount: snapshot.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    ProductModel product = snapshot.data![index];
                    return Product(
                      product: product,
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
      backgroundColor: Colors.teal,
      onPressed: () {
        showDialog(
            context: context,
            builder: (_) {
              final double screenWidth = MediaQuery.of(context).size.width;
              final double dialogWidth = screenWidth * 0.8;
              return Directionality(
                  textDirection: TextDirection.rtl,
                  child: _showAlertDialog(context));
            }).then((value) => clearFields(setState));
      },
      child: const Icon(
        Icons.add_shopping_cart_outlined,
        color: Colors.white,
      ),
    );
  }

  Widget _showAlertDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return AlertDialog(
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
                  builder: (context) => const SimpleBarcodeScannerPage(),
                ),
              );
              setState(() {
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
                const Icon(
                  Icons.barcode_reader,
                  color: Colors.teal,
                ),
              ],
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                "اضافة منتج",
                style: TextStyle(color: Colors.teal),
              ),
              Row(
                children: [
                  Text(
                    barCode,
                    style: TextStyle(fontSize: 12),
                  ),
                  const Icon(Icons.numbers, color: Colors.teal),
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
                      icon: const Icon(
                        Icons.label,
                        color: Colors.teal,
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
                      icon: const Icon(
                        Icons.price_change_outlined,
                        color: Colors.teal,
                      ),
                      controller: _priceController,
                      type: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Button(
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
                          } else {
                            setState(() {
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
        );
      },
    );
  }
}
