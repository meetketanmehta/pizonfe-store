import 'package:flutter/material.dart';
import '../widgets/OrderCardWidget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pizonfe_store/models/Order.dart';
import 'package:pizonfe_store/res/values/EndPoints.dart';
import 'package:flutter_user_auth/flutter_user_auth.dart';

class OrdersBody extends StatefulWidget {
  final String ordersType;
  OrdersBody({this.ordersType});

  @override
  State<StatefulWidget> createState() => _OrdersBody();
}

class _OrdersBody extends State<OrdersBody> {
  var orders = [];
  bool isLoading = true;

  _OrdersBody() {
    isLoading = true;
    fetchOrders();
  }

  @override
  void didUpdateWidget(oldWidget) {
    isLoading = true;
    fetchOrders();
    super.didUpdateWidget(oldWidget);
  }

  fetchOrders() async {
    debugPrint("Loading Data");
    String authToken = await UserAuth.getAuthToken();
    var response = await http.get(
        EndPoints.orders + "?ordersType=" + widget.ordersType,
        headers: {
          "authorizationtoken": authToken
        });
    var responseBody = jsonDecode(response.body);
    orders.clear();
    for (Map responseOrder in responseBody) {
      var order = Order.fromJSON(responseOrder);
      orders.add(order);
    }
    setState(() {
      isLoading = false;
    });
  }

  Widget _ordersList() {
    List<Widget> orderCards = [];

    orders.forEach((order) {
      orderCards.add(OrderCardWidget(order: order));
    });

    return Container(
      child: ListView(
        children: orderCards,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
            backgroundColor: Color(0xfff7892b),
          ))
        : (orders.isEmpty)
            ? Center(
                child: (widget.ordersType == "Pending")
                    ? Text("No Pending Orders")
                    : Text("No Completed Orders"),
              )
            : _ordersList();
  }
}
