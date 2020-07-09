import 'package:flutter/material.dart';
import 'package:pizonfe_store/models/Order.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pizonfe_store/models/Product.dart';
import 'package:pizonfe_store/res/values/EndPoints.dart';
import 'package:flutter_user_auth/flutter_user_auth.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  OrderDetailsScreen({this.orderId});

  @override
  State<StatefulWidget> createState() => _OrderDetailsScreen();
}

class _OrderDetailsScreen extends State<OrderDetailsScreen> {
  bool isLoading = true;
  Order order;

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  void fetchData() async {
    String authToken = await UserAuth.getAuthToken();
    var response = await http.get(
        EndPoints.orderDetails + widget.orderId,
        headers: {
          "authorizationtoken": authToken
        });
    var responseBody = jsonDecode(response.body);
    order = Order.fromJSON(responseBody);
    setState(() {
      isLoading = false;
    });
  }

  Widget _productsCard(Product product) {
    return Row(
      children: <Widget>[
        Container(
          height: 60,
          width: 60,
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Image.network(
            product.imageUri,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                product.title,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                product.options,
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        SizedBox(width: 10),
        Container(
            width: 35,
            child: Center(child: Text("x " + product.quantity.toString()))),
        SizedBox(width: 20),
        Container(
          width: 50,
          child: Center(
            child: Text(
                "\u{20B9} " + (product.price * product.quantity).toString()),
          ),
        ),
      ],
    );
  }

  Widget _productsList() {
    var productCards = <Widget>[];
    order.products.forEach((product) {
      productCards.add(_productsCard(product));
    });
    return Column(
      children: productCards,
    );
  }

  Widget _billingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _pricingDetailsRow(false, "Items Total", order.productsTotal),
        SizedBox(height: 10),
        _pricingDetailsRow(false, "Delivery Charges", order.deliveryCharge),
        SizedBox(
          height: 10,
        ),
        _pricingDetailsRow(true, "To Pay", order.totalAmount),
      ],
    );
  }

  Widget _pricingDetailsRow(bool boldTitle, String title, double price) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              fontWeight: boldTitle ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        SizedBox(width: 20),
        Text(
          "\u{20B9} " + (price).toString(),
          style: TextStyle(
            fontWeight: boldTitle ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _loadedScreen() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Order Id : " + order.id,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Divider(),
            Text(
              "ITEMS",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            SizedBox(
              height: 5,
            ),
            _productsList(),
            Divider(),
            Text(
              "BILLING DETAILS",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
            SizedBox(
              height: 10,
            ),
            _billingDetails(),
          ],
        ),
      ),
    );
  }

  Container _bottomAppBar() {
    return Container(
      decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)]),
      child: BottomAppBar(
        child: Container(
          height: 60,
          child: Row(
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    //TODO: Reject Order Function
                  },
                  child: Center(
                    child: Text(
                      "Reject Order",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: RaisedButton(
                  color: Color(0xfff7892b),
                  onPressed: () {
                    //TODO: Accept Order Function
                  },
                  child: Center(
                    child: Text(
                      "Accept Order",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Order Details"),
      ),
      bottomNavigationBar: isLoading ? null : _bottomAppBar(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(backgroundColor: Color(0xfff7892b),),
            )
          : _loadedScreen(),
    );
  }
}
