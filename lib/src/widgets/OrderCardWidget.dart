import 'package:flutter/material.dart';
import 'package:pizonfe_store/models/Order.dart';
import 'package:pizonfe_store/screens/OrderDetailsScreen.dart';

class OrderCardWidget extends StatelessWidget {
  final Order order;
  OrderCardWidget({this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: RaisedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => OrderDetailsScreen(orderId: order.id,)));
        },
        color: Colors.white,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Order Id : " + order.id, style: TextStyle(fontWeight: FontWeight.bold),),
            Divider(),
            Text("ORDERED AT", style: TextStyle(color: Colors.grey, fontSize: 11),),
            Text(order.orderTime.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text("ORDER TOTAL", style: TextStyle(color: Colors.grey, fontSize: 11),),
            Text("\u{20B9} " + order.productsTotal.toString(), style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text("ORDER STATUS", style: TextStyle(color: Colors.grey, fontSize: 11),),
            Text(order.status, style: TextStyle(fontWeight: FontWeight.bold),),
          ],
        ),
      ),
    );
  }
}