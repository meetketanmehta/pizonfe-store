import 'package:flutter/material.dart';
import 'package:pizonfe_store/res/values/EndPoints.dart';
import 'package:pizonfe_store/res/values/Strings.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'dart:convert';
import 'package:pizonfe_store/models/Product.dart';
import 'dart:core';

typedef void OnChangedType(String value);

Product defaultProduct = Product.fromJSON(
    {"proId": Strings.defaultProduct, "title": Strings.defaultProduct});
Product loadingProduct = Product.fromJSON(
    {"proId": Strings.loadingProduct, "title": Strings.loadingProduct});

class SellNewProductBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SellNewProductBodyState();
}

class _SellNewProductBodyState extends State<SellNewProductBody> {
  String _selectedCategory = Strings.defaultCategory;
  String _selectedSubCategory = Strings.defaultSubCategory;
  Product _selectedProduct = defaultProduct;
  String _selectedOptions = Strings.defaultOptions;
  var _categories = [Strings.defaultCategory];
  var _subCategories = [Strings.defaultSubCategory];
  var _products = [defaultProduct];
  var _options = [Strings.defaultOptions];
  TextEditingController _priceFieldController;
  FocusNode _priceFieldNode;
  String _errorMessage = "";

  bool isLoading = false;

  @override
  void initState() {
    fetchCategories();
    _priceFieldController = TextEditingController();
    _priceFieldNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _priceFieldController.dispose();
    _priceFieldNode.dispose();
    super.dispose();
  }

  void setAllDefaults() {
    setDefaults(category: true, subCategory: true, product: true, options: true);
    _errorMessage = "";
    _priceFieldController.clear();
  }

  void setDefaults(
      {category: false, subCategory: false, product: false, options: false}) {
    if (category) setCategoryDefault();
    if (subCategory) setSubCategoryDefault();
    if (product) setProductDefault();
    if (options) setOptionsDefault();
  }

  void setCategoryDefault() {
    _selectedCategory = Strings.defaultCategory;
    _categories = [Strings.defaultCategory];
  }

  void setSubCategoryDefault() {
    _selectedSubCategory = Strings.defaultSubCategory;
    _subCategories = [Strings.defaultSubCategory];
  }

  void setProductDefault() {
    _selectedProduct = defaultProduct;
    _products = [defaultProduct];
  }

  void setOptionsDefault() {
    _selectedOptions = Strings.defaultOptions;
    _options = [Strings.defaultOptions];
  }

  void setCategoriesLoading() {
    _selectedCategory = Strings.loadingCategory;
    _categories = [Strings.loadingCategory];
  }

  void setSubCategoriesLoading() {
    _selectedSubCategory = Strings.loadingSubCategory;
    _subCategories = [Strings.loadingSubCategory];
  }

  void setProductsLoading() {
    _selectedProduct = loadingProduct;
    _products = [loadingProduct];
  }

  void setOptionsLoading() {
    _selectedOptions = Strings.loadingOptions;
    _options = [Strings.loadingOptions];
  }

  void fetchCategories() async {
    debugPrint("=> Fetching categories");
    setState(() {
      setDefaults(subCategory: true, product: true, options: true);
      setCategoriesLoading();
    });
    var response = await http.get(EndPoints.categories);
    if (response.statusCode != 200) {
      Toast.show("Internal Error, Please try again later", context);
      return;
    }
    var responseBody = jsonDecode(response.body);
    setState(() {
      setCategoryDefault();
      for (Map responseCategory in responseBody) {
        _categories.add(responseCategory['category']);
      }
    });
  }

  void fetchSubCategories() async {
    debugPrint("=> Fetching subCategories");
    setState(() {
      setDefaults(product: true, options: true);
      setSubCategoriesLoading();
    });
    var url = Uri.https("9z7rj2idm7.execute-api.us-east-1.amazonaws.com",
        "/dev/subCategories", {"category": _selectedCategory});
    var response = await http.get(url);
    if (response.statusCode != 200) {
      Toast.show("Internal Error, Please try again later", context);
      return;
    }
    var responseBody = jsonDecode(response.body);
    Map responseCategory = responseBody[0];
    setState(() {
      setSubCategoryDefault();
      for (Map subCategory in responseCategory['subCat']) {
        _subCategories.add(subCategory['subCategory']);
      }
    });
  }

  void fetchProducts() async {
    debugPrint("=> Fetching Products");
    setState(() {
      setDefaults(options: true);
      setProductsLoading();
    });
    var url = Uri.https("9z7rj2idm7.execute-api.us-east-1.amazonaws.com",
        "/dev/products/" + _selectedCategory + "/" + _selectedSubCategory);
    var response = await http.get(url);
    if (response.statusCode != 200) {
      Toast.show("Internal Error, Please try again later", context);
      return;
    }
    var responseBody = jsonDecode(response.body);
    if (responseBody.length == 0) {
      setState(() {
        setProductDefault();
      });
      Toast.show("No products found, please request product addition", context);
      return;
    }
    setState(() {
      setProductDefault();
      for (Map responseProduct in responseBody) {
        responseProduct["proId"] = responseProduct["_id"];
        _products.add(Product.fromJSON(responseProduct));
      }
    });
  }

  void fetchOptions() async {
    debugPrint("=> Fetching options");
    setState(() {
      setOptionsLoading();
    });
    var response =
        await http.get(EndPoints.productOptions + _selectedProduct.id);
    if (response.statusCode != 200) {
      Toast.show("Internal Error, Please try again later", context);
      return;
    }
    List<dynamic> responseBody = jsonDecode(response.body);
    setState(() {
      setOptionsDefault();
      _options += List<String>.from(responseBody);
    });
  }

  void categorySelected(selectedCategory) {
    if (selectedCategory == Strings.loadingCategory) return;
    setState(() {
      _selectedCategory = selectedCategory;
    });
    if (selectedCategory == Strings.defaultCategory) {
      setState(() {
        setDefaults(subCategory: true, product: true, options: true);
      });
      return;
    }
    fetchSubCategories();
  }

  void subCategorySelected(String subCategory) {
    if (subCategory == Strings.loadingSubCategory) return;
    setState(() {
      _selectedSubCategory = subCategory;
    });
    if (subCategory == Strings.defaultSubCategory) {
      setState(() {
        setDefaults(product: true, options: true);
      });
      return;
    }
    fetchProducts();
  }

  void productSelected(String productId) {
    if (productId == loadingProduct.id) return;
    setState(() {
      for (Product product in _products) {
        if (product.id == productId) {
          _selectedProduct = product;
          break;
        }
      }
    });
    if (productId == defaultProduct.id) {
      setState(() {
        setDefaults(options: true);
      });
      return;
    }
    fetchOptions();
  }

  void optionSelected(String option) {
    if (option == Strings.loadingOptions) return;
    setState(() {
      _selectedOptions = option;
    });
  }

  bool validateSelectedParams() {
    return _selectedProduct != defaultProduct &&
        _selectedProduct != loadingProduct &&
        _selectedCategory != Strings.defaultCategory &&
        _selectedCategory != Strings.loadingCategory &&
        _selectedSubCategory != Strings.defaultSubCategory &&
        _selectedSubCategory != Strings.loadingSubCategory &&
        _selectedOptions != Strings.defaultOptions &&
        _selectedOptions != Strings.loadingOptions;
  }

  bool validatePrice() {
    String price = _priceFieldController.text;
    debugPrint(price);
    if (price == null || price == "") return false;
    double dPrice = double.tryParse(price);
    if (dPrice == null) return false;
    return true;
  }

  void onSubmit() {
    _priceFieldNode.unfocus();
    setState(() {
      isLoading = true;
    });
    debugPrint(validateSelectedParams().toString());
    debugPrint(validatePrice().toString());
    if (validatePrice() && validateSelectedParams()) {
      //TODO: API Call to change DB
      Toast.show("Added Successfully to database", context);
      setState(() {
        isLoading = false;
        setAllDefaults();
      });
      fetchCategories();
      return;
    }
    debugPrint("Reached here");
    debugPrint("Error Message => " + _errorMessage);
    setState(() {
      isLoading = false;
      setAllDefaults();
      _errorMessage = "Please select valid Input";
    });
    fetchCategories();
  }

  Widget customisedDropButton(
      {String selectedValue,
      List<String> values,
      List<String> texts,
      OnChangedType onChanged}) {
    if (values == null) values = texts;
    if (texts == null) texts = values;
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff3f3f4),
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      width: MediaQuery.of(context).size.width,
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue,
          dropdownColor: Color(0xfff3f3f4),
          isExpanded: true,
          items: List.generate(values.length, (index) {
            return DropdownMenuItem<String>(
              child: Text(texts[index]),
              value: values[index],
            );
          }),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        width: MediaQuery.of(context).size.width,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.shade200,
                offset: Offset(2, 4),
                blurRadius: 5,
                spreadRadius: 2)
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xfffbb448), Color(0xfff7892b)],
          ),
        ),
        child: InkWell(
          onTap: onSubmit,
          child: Center(
            child: Text(
              "Submit",
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
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
        : SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  customisedDropButton(
                      selectedValue: _selectedCategory,
                      values: _categories,
                      onChanged: categorySelected),
                  SizedBox(height: 20),
                  customisedDropButton(
                      selectedValue: _selectedSubCategory,
                      values: _subCategories,
                      onChanged: subCategorySelected),
                  SizedBox(height: 20),
                  customisedDropButton(
                      selectedValue: _selectedProduct.id,
                      values: _products.map((product) => product.id).toList(),
                      texts: _products.map((product) => product.title).toList(),
                      onChanged: productSelected),
                  SizedBox(height: 20),
                  customisedDropButton(
                      selectedValue: _selectedOptions,
                      values: _options,
                      onChanged: optionSelected),
                  SizedBox(height: 20),
                  Theme(
                    data: ThemeData(primaryColor: Colors.blue),
                    child: TextFormField(
                      controller: _priceFieldController,
                      focusNode: _priceFieldNode,
                      decoration: InputDecoration(
                        labelText: "Enter Price",
                        border: InputBorder.none,
                        errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xfff3f3f4))),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue)),
                        fillColor: Color(0xfff3f3f4),
                        filled: true,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                      height: 40,
                      child: Center(
                          child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ))),
                  _submitButton(),
                ],
              ),
            ),
          );
  }
}
