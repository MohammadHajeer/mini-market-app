import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mini_market_app/add_new_product.dart';
import 'package:mini_market_app/dashboard.dart';
import 'package:mini_market_app/products.dart';
import 'package:mini_market_app/tab_info.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 0;

  final List _tabs = <TabInfo>[
    TabInfo(tab: const Dashboard(), title: "الرئيسية", icon: Icons.home),
    TabInfo(
        tab: const AddNewProduct(),
        title: "اضف منتج",
        icon: Icons.barcode_reader),
    TabInfo(
        tab: const Products(),
        title: "المنتجات",
        icon: Icons.production_quantity_limits),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            child: Icon(_tabs[_pageIndex].icon, color: Colors.white, size: 30),
          )
        ],
        backgroundColor: Colors.teal,
        title: SizedBox(
          width: double.infinity,
          child: Text(
            _tabs[_pageIndex].title,
            style: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
      body: Container(
        child: _tabs[_pageIndex].tab,
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 16,
          unselectedFontSize: 16,
          currentIndex: _pageIndex,
          items: _tabs
              .map((tab) => BottomNavigationBarItem(
                  label: tab.title, icon: Icon(tab.icon)))
              .toList(),
          onTap: (index) => setState(() {
                _pageIndex = index;
              })),
    );
  }
}
