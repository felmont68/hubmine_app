import 'dart:convert';

List<Product> productFromJson(String str) =>
    List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  Product({
    required this.pk,
    required this.productName,
    required this.shortDescription,
    required this.description,
    required this.image,
    required this.isFavorite,
    required this.category,
    required this.unity,
    required this.technicalFeatures,
    required this.price,
  });

  int pk;
  String productName;
  String shortDescription;
  String description;
  String image;
  bool isFavorite;
  Category category;
  Unity unity;
  TechnicalFeatures technicalFeatures;
  Price price;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        pk: json["pk"],
        productName: json["product_name"],
        shortDescription: json["short_description"],
        description: json["description"],
        image: json["image"],
        isFavorite: json["is_favorite"],
        category: Category.fromJson(json["category"]),
        unity: Unity.fromJson(json["unity"]),
        technicalFeatures:
            TechnicalFeatures.fromJson(json["technical_features"]),
        price: Price.fromJson(json["price"]),
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "product_name": productName,
        "short_description": shortDescription,
        "description": description,
        "image": image,
        "is_favorite": isFavorite,
        "category": category.toJson(),
        "unity": unity.toJson(),
        "technical_features": technicalFeatures.toJson(),
        "price": price.toJson(),
      };
}

class Category {
  Category({
    required this.categoryId,
    required this.categoryName,
    required this.categorySlug,
    required this.categoryIcon,
  });

  int categoryId;
  String categoryName;
  String categorySlug;
  String categoryIcon;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["category_id"],
        categoryName: json["category_name"],
        categorySlug: json["category_slug"],
        categoryIcon: json["category_icon"],
      );

  Map<String, dynamic> toJson() => {
        "category_id": categoryId,
        "category_name": categoryName,
        "category_slug": categorySlug,
        "category_icon": categoryIcon,
      };
}

class Price {
  Price({
    required this.total,
    required this.symbol,
    required this.name,
    required this.badge,
  });

  int total;
  String symbol;
  String name;
  String badge;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
        total: json["total"],
        symbol: json["symbol"],
        name: json["name"],
        badge: json["badge"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "symbol": symbol,
        "name": name,
        "badge": badge,
      };
}

class TechnicalFeatures {
  TechnicalFeatures({
    required this.measures,
    required this.minimumValue,
    required this.maximumValue,
    required this.volumetricWeight,
    required this.increase,
  });

  String measures;
  double minimumValue;
  int maximumValue;
  double volumetricWeight;
  double increase;

  factory TechnicalFeatures.fromJson(Map<String, dynamic> json) =>
      TechnicalFeatures(
        measures: json["measures"],
        minimumValue: json["minimum_value"].toDouble(),
        maximumValue: json["maximum_value"],
        volumetricWeight: json["volumetric_weight"].toDouble(),
        increase: json["increase"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "measures": measures,
        "minimum_value": minimumValue,
        "maximum_value": maximumValue,
        "volumetric_weight": volumetricWeight,
        "increase": increase,
      };
}

class Unity {
  Unity({
    required this.unity,
    required this.unityDescription,
  });

  String unity;
  String unityDescription;

  factory Unity.fromJson(Map<String, dynamic> json) => Unity(
        unity: json["unity"],
        unityDescription: json["unity_description"],
      );

  Map<String, dynamic> toJson() => {
        "unity": unity,
        "unity_description": unityDescription,
      };
}
