import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_user_input_screen.dart';

import '../widgets/app_drawer.dart';
import '../providers/products.dart';
import '../widgets/user_items.dart';

class UserProductsScreen extends StatelessWidget {
  // const UserProductsScreen({super.key});
  static const routeName = '/user_products';

  Future<void> _refresh_user_products(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchandstoreproducts(true)
        .catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: Icon(Icons.add))
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
          future: _refresh_user_products(context),
          builder: ((ctx, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _refresh_user_products(context),
                  child: Consumer<Products>(
                      builder: ((ctx, productData, _) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemBuilder: (_, index) {
                                return UserItems(
                                  id: productData.items[index].id,
                                  title: productData.items[index].title,
                                  imageurl: productData.items[index].imageUrl,
                                );
                              },
                              itemCount: productData.items.length,
                            ),
                          ))),
                ))),
    );
  }
}
