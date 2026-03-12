import 'package:flutter/material.dart';
import 'package:app_loja_cha_ta/database/database_helper.dart';
import 'package:app_loja_cha_ta/models/product_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final data = await DatabaseHelper.instance.getProducts();
    setState(() {
      products = data;
    });
  }

  Future<void> insertProduct() async {
    final product = Product(
      name: "Vestido",
      price: 99.90,
      quantity: 5,
    );

    await DatabaseHelper.instance.insertProduct(product);
    await loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final p = products[index];
          return ListTile(
            title: Text(p.name),
            subtitle: Text("Price: ${p.price} | Qty: ${p.quantity}"),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await DatabaseHelper.instance.deleteProduct(p.id!);
                await loadProducts();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: insertProduct,
        child: const Icon(Icons.add),
      ),
    );
  }
}
