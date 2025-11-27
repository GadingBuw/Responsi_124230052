class DetailRestaurants {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String rating;
  final String address;
  final String categories;
  final String menus;
  final String drinks;
  final String foods;
  final String customerReviews;

  DetailRestaurants({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.address,
    required this.categories,
    required this.menus,
    required this.drinks,
    required this.foods,
    required this.customerReviews,
  });

  factory DetailRestaurants.fromJson(Map<String, dynamic> json) {
    return DetailRestaurants(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'].toDouble(),
      address: json['address'],
      categories: json['categories'],
      menus: json['menus'],
      drinks: json['drinks'],
      foods: json['foods'],
      customerReviews: json['customerReviews'],
    );
  }
}