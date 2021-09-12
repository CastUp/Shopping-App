import 'package:Shopping/Parts/Admin/InnerScreen/InnerBrands/Brands.dart';
import 'package:Shopping/Parts/Admin/InnerScreen/InnerCategories/Categories.dart';
import 'package:Shopping/Parts/Admin/InnerScreen/Listproducts/ListProducts.dart';
import 'package:flutter/material.dart';

class Products extends StatefulWidget {
  static const String PRODUCTS = "/Products";

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> with SingleTickerProviderStateMixin {

  late TabController _tabController ;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 2,
      child: Column(
        children: [
          Container(
            color: Colors.orange.shade700,
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height*.07),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelColor: Colors.black,
              labelColor: Colors.white,
              labelStyle: TextStyle(fontWeight: FontWeight.w500,fontSize: 18),
              labelPadding: EdgeInsets.only(bottom: 15),
              indicatorColor: Colors.grey.shade600,
              overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
              indicatorWeight: 2,
              tabs: [
                Text("Categories"),
                Text("Brands"),
                Text("Products")
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              physics: BouncingScrollPhysics(),
              controller: _tabController,
              children: [
                Categories(),
                Brands(),
                ListProducts()
              ],
            ),
          ),
        ],
      )
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
