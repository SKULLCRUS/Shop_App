import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final url = Uri.parse(
        'https://shop-app-83115-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token');
    final oldstatus = isFavorite;

    isFavorite = !isFavorite;
    notifyListeners();
    try {
      await http.put(url,
          body: json.encode(
            isFavorite,
          ));
    } catch (error) {
      isFavorite = oldstatus;
      notifyListeners();
    }
  }
}
