// This service encapsulates all API communication logic.
// By keeping it separate, we can easily mock it for testing or switch to a different API.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:shopping_catalog_app/Models/product_model.dart';
import 'package:shopping_catalog_app/Services/api_exception.dart';

class ApiService {
  static const String _baseUrl = 'https://fakestoreapi.com';

  // Fetches all products from the API.
  Future<List<Product>> getProducts() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products'));
      if (response.statusCode == 200) {
        final List<dynamic> productJson = json.decode(response.body);
        return productJson.map((json) => Product.fromJson(json)).toList();
      } else {
        throw ApiException('Failed to load products. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No Internet connection. Please check your connection and try again.');
    } catch (e) {
      throw ApiException('An unexpected error occurred. Please try again later.');
    }
  }

  // Fetches all available product categories from the API.
  Future<List<String>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/products/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> categoryJson = json.decode(response.body);
        return categoryJson.map((category) => category.toString()).toList();
      } else {
        throw ApiException('Failed to load categories. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('No Internet connection. Please check your connection and try again.');
    } catch (e) {
      throw ApiException('An unexpected error occurred. Please try again later.');
    }
  }
}
