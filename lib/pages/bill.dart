import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_market_app/utils/utils.dart';
import 'package:mini_market_app/widgets/button.dart';

class Bill extends StatefulWidget {
  const Bill({super.key});

  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {
  final double _totalPrice = 2322330;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _calculateTheBill(),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 250,
            decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(color: Colors.teal, spreadRadius: 5)]),
            child: Column(
              children: [
                Container(
                  color:  Theme.of(context).primaryColor.withOpacity(0.05),
                  height: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "ل.ل",
                        style: TextStyle(
                            fontFamily: "",
                            fontSize: 30,
                            color: Theme.of(context).primaryColor),
                      ),
                      Text(
                        Utils().formatPrice(_totalPrice),
                        style: TextStyle(
                            fontSize: 75,
                            fontFamily: '',
                            color: Theme.of(context).primaryColor),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: Theme.of(context).primaryColor.withOpacity(0.4),
                  height: 40,
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                      boxShadow: [
                        BoxShadow(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.6),
                            spreadRadius: 2)
                      ]),
                  child: const Center(
                    child: Text(
                      "المجموع",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                            color: Theme.of(context).primaryColor,
                            spreadRadius: 2)
                      ]),
                  child: const Center(
                    child: Text(
                      "بالليرة اللبنانية",
                      style: TextStyle(color: Colors.white, fontSize: 30),
                    ),
                  ),
                )
              ],
            ),
          ),
          // Expanded(
          //     child: TextButton(
          //         style: ButtonStyle(
          //           backgroundColor: MaterialStateProperty.all(Colors.white),
          //           overlayColor: MaterialStateProperty.all(
          //               Theme.of(context).primaryColor.withOpacity(0.2)),
          //           shape: MaterialStateProperty.all(
          //             const RoundedRectangleBorder(
          //               borderRadius: BorderRadius.zero,
          //             ),
          //           ),
          //         ),
          //         onPressed: () {},
          //         child: SizedBox(
          //           width: double.infinity,
          //           child: Center(
          //             child: Text(
          //               "احسب الان",
          //               style: TextStyle(
          //                   fontSize: 50, color: Theme.of(context).primaryColor),
          //             ),
          //           ),
          //         )))
        ],
      ),
    );
  }

  Widget _calculateTheBill() {
    return FloatingActionButton(
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {},
      child: const Icon(
        Icons.calculate,
        color: Colors.white,
      ),
    );
  }
}
