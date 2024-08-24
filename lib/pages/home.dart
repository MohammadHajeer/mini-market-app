import 'package:flutter/material.dart';
import 'package:mini_market_app/pages/bill.dart';
import 'package:mini_market_app/pages/dashboard.dart';
import 'package:mini_market_app/pages/product_search.dart';
import 'package:mini_market_app/pages/products.dart';
import 'package:mini_market_app/models/tab_info.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  late final List<TabInfo> _tabs;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onBottomNavBarTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  void initState() {
    _tabs = [
      TabInfo(tab: const Dashboard(), title: "الرئيسية", icon: Icons.home),
      TabInfo(tab: const Bill(), title: "اخذ فاتورة", icon: Icons.payment),
      TabInfo(
          tab: const ProductSearch(),
          title: "ابحث عن منتج",
          icon: Icons.search),
      TabInfo(
          tab: const Products(),
          title: "المنتجات",
          icon: Icons.production_quantity_limits),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            padding: const EdgeInsets.only(left: 20),
            child:
                Icon(_tabs[_selectedIndex].icon, color: Colors.white, size: 30),
          )
        ],
        backgroundColor: Theme.of(context).primaryColor,
        title: SizedBox(
          width: double.infinity,
          child: Text(
            _tabs[_selectedIndex].title,
            style: const TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _tabs.map((tab) => tab.tab).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 16,
          unselectedFontSize: 16,
          currentIndex: _selectedIndex,
          items: _tabs
              .map((tab) => BottomNavigationBarItem(
                  label: tab.title, icon: Icon(tab.icon)))
              .toList(),
          onTap: _onBottomNavBarTapped),
    );
  }
}
