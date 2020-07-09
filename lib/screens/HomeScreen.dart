import 'package:flutter/material.dart';
import '../src/components/OrdersBody.dart';
import 'package:flutter_user_auth/screens/Login.dart';
import 'package:flutter_user_auth/flutter_user_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  var _isLogged = UserAuth.isLogged;
  var _currentIndex = 0;
  var titles = ["Pending Orders", "Completed Orders", "Sell New Product", "Request Product Addition"];

  Widget _homeScreenBody(index) {
//    debugPrint("Home Screen body called" + index.toString());
    if(index == 0) {
      return OrdersBody(ordersType: "Pending",);
    }
    if(index == 1) {
      return OrdersBody(ordersType: "Completed",);
    }
  }

  void changeLoginStatus () {
//    debugPrint("Logged in successfully");
    setState(() {
      _isLogged = UserAuth.isLogged;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLogged ? Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex]),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.format_list_bulleted), title: Text("Pending Orders")),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add_check), title: Text("Completed Orders")),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_add), title: Text("Sell New Product")),
          BottomNavigationBarItem(icon: Icon(Icons.add_to_photos), title: Text("Request Product Addition")),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xfff79c4f),
        unselectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: _homeScreenBody(_currentIndex),
    ) : Login(showSignUpButton: false, whenLoggedFunction: changeLoginStatus, showBackButton: false, popScreenAfterLogin: false,) ;
  }
}
