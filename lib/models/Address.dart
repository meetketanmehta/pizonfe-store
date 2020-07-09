class Address {
  String id;
  int contactNumber;
  var coordinates = [];
  String addName;
  String completeAdd;
  String landmark;
  String addType;

  Address.fromJSON(Map<dynamic, dynamic> addressJSON) {
    this.id = addressJSON['addId'];
    this.contactNumber = addressJSON['contactNumber'];
    this.coordinates = addressJSON['coordinates'];
    this.addName = addressJSON['addName'];
    this.completeAdd = addressJSON['completeAdd'];
    this.landmark = addressJSON['landmark'];
    this.addType = addressJSON['addType'];
  }
}