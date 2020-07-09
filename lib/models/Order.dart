import 'Address.dart';
import 'Product.dart';
import 'dart:core';

class Order {
  String id;
  String status;
  String custId;
  String storeId;
  String storeName;
  double deliveryCharge;
  double productsTotal;
  double totalAmount;
  DateTime orderTime;
  DateTime deliveryTime;
  Address deliveryAddress;
  var products = [];

  Order.fromJSON(Map<dynamic, dynamic> orderJSON) {
    this.id = orderJSON['_id'];
    this.status = orderJSON['status'];
    this.custId = orderJSON['custId'];
    this.storeId = orderJSON['storeId'];
    this.storeName = orderJSON['storeName'];
    this.deliveryCharge = orderJSON['deliveryCharge'] != null ? orderJSON['deliveryCharge'].toDouble() : null;
    this.productsTotal = orderJSON['productsTotal'] != null ? orderJSON['productsTotal'].toDouble() : null;
    this.totalAmount = orderJSON['totalAmount'] != null ? orderJSON['totalAmount'].toDouble() : null;
    this.orderTime = orderJSON['orderTime'] != null ? DateTime.parse(orderJSON['orderTime']).toLocal() : null;
    this.deliveryTime = orderJSON['deliveryTime'] != null ? DateTime.parse(orderJSON['deliveryTime']).toLocal() : null;
    this.deliveryAddress = Address.fromJSON(orderJSON['deliveryAddress']);
    for(Map product in orderJSON['products']) {
      products.add(Product.fromJSON(product));
    }
  }
}