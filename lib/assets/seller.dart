class Seller {
  final String mobileNumber;
  final String sellerName;
  final String sellerTitle;
  Seller({this.mobileNumber, this.sellerName, this.sellerTitle});

  factory Seller.fromJson(dynamic json) {
    return Seller(
        mobileNumber: json['mobile-number'] as String,
        sellerName: json['name'] as String,
        sellerTitle: json['title'] as String);
  }
}
