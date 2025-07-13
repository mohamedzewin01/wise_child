// lib/features/Store/data/models/product_model.dart

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProductModel {
  final String id;
  final String name;
  final double price;
  final double? originalPrice;
  final String image;
  final List<String> images;
  final String category;
  final String ageRange;
  final double rating;
  final int reviewCount;
  final List<String> benefits;
  final bool? isNew;
  final bool? isBestSeller;
  final String description;
  final Map<String, String> specifications;
  final bool inStock;
  final int stockQuantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.image,
    List<String>? images,
    required this.category,
    required this.ageRange,
    required this.rating,
    required this.reviewCount,
    required this.benefits,
    this.isNew,
    this.isBestSeller,
    String? description,
    Map<String, String>? specifications,
    this.inStock = true,
    this.stockQuantity = 10,
  }) : images = images ?? [image],
        description = description ?? 'منتج تعليمي عالي الجودة مصمم خصيصاً لتطوير مهارات الأطفال.',
        specifications = specifications ?? {};

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      originalPrice: json['originalPrice']?.toDouble(),
      image: json['image'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      ageRange: json['ageRange'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      benefits: List<String>.from(json['benefits'] ?? []),
      isNew: json['isNew'],
      isBestSeller: json['isBestSeller'],
      description: json['description'],
      specifications: Map<String, String>.from(json['specifications'] ?? {}),
      inStock: json['inStock'] ?? true,
      stockQuantity: json['stockQuantity'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'image': image,
      'images': images,
      'category': category,
      'ageRange': ageRange,
      'rating': rating,
      'reviewCount': reviewCount,
      'benefits': benefits,
      'isNew': isNew,
      'isBestSeller': isBestSeller,
      'description': description,
      'specifications': specifications,
      'inStock': inStock,
      'stockQuantity': stockQuantity,
    };
  }

  double get discountPercentage {
    if (originalPrice != null && originalPrice! > price) {
      return ((originalPrice! - price) / originalPrice!) * 100;
    }
    return 0;
  }

  bool get hasDiscount => originalPrice != null && originalPrice! > price;
}

// lib/features/Store/data/models/category_model.dart

class CategoryModel {
  final String id;
  final String title;
  final IconData icon;
  final Color color;
  final String description;
  final int productCount;
  final String image;
  final List<String> subCategories;

  CategoryModel({
    String? id,
    required this.title,
    required this.icon,
    required this.color,
    required this.description,
    required this.productCount,
    String? image,
    List<String>? subCategories,
  }) : id = id ?? title.toLowerCase().replaceAll(' ', '_'),
        image = image ?? 'https://images.unsplash.com/photo-1558618047-3c8c76ca7d13?w=300',
        subCategories = subCategories ?? [];

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'] ?? '',
      icon: _iconFromString(json['icon']),
      color: Color(json['color'] ?? 0xFF6C63FF),
      description: json['description'] ?? '',
      productCount: json['productCount'] ?? 0,
      image: json['image'],
      subCategories: List<String>.from(json['subCategories'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon.codePoint,
      'color': color.value,
      'description': description,
      'productCount': productCount,
      'image': image,
      'subCategories': subCategories,
    };
  }

  static IconData _iconFromString(String? iconName) {
    // This would map icon names to actual IconData
    // For now, returning a default icon
    return Icons.category;
  }
}

// lib/features/Store/data/models/cart_model.dart

class CartItem {
  final ProductModel product;
  int quantity;
  final DateTime addedAt;
  String? selectedVariant;

  CartItem({
    required this.product,
    this.quantity = 1,
    DateTime? addedAt,
    this.selectedVariant,
  }) : addedAt = addedAt ?? DateTime.now();

  double get totalPrice => product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: ProductModel.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
      addedAt: DateTime.parse(json['addedAt'] ?? DateTime.now().toIso8601String()),
      selectedVariant: json['selectedVariant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
      'addedAt': addedAt.toIso8601String(),
      'selectedVariant': selectedVariant,
    };
  }
}

class Cart {
  List<CartItem> items;
  String? promoCode;
  double promoDiscount;
  DateTime lastUpdated;

  Cart({
    List<CartItem>? items,
    this.promoCode,
    this.promoDiscount = 0,
    DateTime? lastUpdated,
  }) : items = items ?? [],
        lastUpdated = lastUpdated ?? DateTime.now();

  double get subtotal => items.fold(0, (sum, item) => sum + item.totalPrice);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  bool get isEmpty => items.isEmpty;

  bool get isNotEmpty => items.isNotEmpty;

  void addItem(ProductModel product, {int quantity = 1}) {
    final existingIndex = items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      items[existingIndex].quantity += quantity;
    } else {
      items.add(CartItem(product: product, quantity: quantity));
    }

    lastUpdated = DateTime.now();
  }

  void removeItem(String productId) {
    items.removeWhere((item) => item.product.id == productId);
    lastUpdated = DateTime.now();
  }

  void updateQuantity(String productId, int quantity) {
    final index = items.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        removeItem(productId);
      } else {
        items[index].quantity = quantity;
        lastUpdated = DateTime.now();
      }
    }
  }

  void clear() {
    items.clear();
    promoCode = null;
    promoDiscount = 0;
    lastUpdated = DateTime.now();
  }

  void applyPromoCode(String code, double discount) {
    promoCode = code;
    promoDiscount = discount;
    lastUpdated = DateTime.now();
  }

  void removePromoCode() {
    promoCode = null;
    promoDiscount = 0;
    lastUpdated = DateTime.now();
  }

  factory Cart.fromJson(Map<String, dynamic> json) {
    return Cart(
      items: (json['items'] as List?)?.map((item) => CartItem.fromJson(item)).toList(),
      promoCode: json['promoCode'],
      promoDiscount: (json['promoDiscount'] ?? 0).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'promoCode': promoCode,
      'promoDiscount': promoDiscount,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

// lib/features/Store/data/models/order_model.dart

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

enum PaymentMethod {
  creditCard,
  applePay,
  stcPay,
  cashOnDelivery,
}

enum DeliveryOption {
  standard,
  express,
  free,
}

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final DeliveryOption deliveryOption;
  final Address shippingAddress;
  final DateTime createdAt;
  final DateTime? estimatedDelivery;
  final String? trackingNumber;
  final String? notes;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.paymentMethod,
    required this.deliveryOption,
    required this.shippingAddress,
    required this.createdAt,
    this.estimatedDelivery,
    this.trackingNumber,
    this.notes,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      status: OrderStatus.values[json['status'] ?? 0],
      paymentMethod: PaymentMethod.values[json['paymentMethod'] ?? 0],
      deliveryOption: DeliveryOption.values[json['deliveryOption'] ?? 0],
      shippingAddress: Address.fromJson(json['shippingAddress']),
      createdAt: DateTime.parse(json['createdAt']),
      estimatedDelivery: json['estimatedDelivery'] != null
          ? DateTime.parse(json['estimatedDelivery'])
          : null,
      trackingNumber: json['trackingNumber'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'status': status.index,
      'paymentMethod': paymentMethod.index,
      'deliveryOption': deliveryOption.index,
      'shippingAddress': shippingAddress.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'estimatedDelivery': estimatedDelivery?.toIso8601String(),
      'trackingNumber': trackingNumber,
      'notes': notes,
    };
  }

  String get statusText {
    switch (status) {
      case OrderStatus.pending:
        return 'في انتظار التأكيد';
      case OrderStatus.confirmed:
        return 'تم التأكيد';
      case OrderStatus.processing:
        return 'قيد التحضير';
      case OrderStatus.shipped:
        return 'تم الشحن';
      case OrderStatus.delivered:
        return 'تم التسليم';
      case OrderStatus.cancelled:
        return 'ملغي';
    }
  }

  Color get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFFFC107);
      case OrderStatus.confirmed:
        return const Color(0xFF2196F3);
      case OrderStatus.processing:
        return const Color(0xFF6C63FF);
      case OrderStatus.shipped:
        return const Color(0xFF00BCD4);
      case OrderStatus.delivered:
        return const Color(0xFF4CAF50);
      case OrderStatus.cancelled:
        return const Color(0xFFF44336);
    }
  }
}

class Address {
  final String fullName;
  final String phone;
  final String email;
  final String street;
  final String city;
  final String? state;
  final String? zipCode;
  final String? country;
  final bool isDefault;

  Address({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.street,
    required this.city,
    this.state,
    this.zipCode,
    this.country = 'السعودية',
    this.isDefault = false,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      fullName: json['fullName'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      street: json['street'] ?? '',
      city: json['city'] ?? '',
      state: json['state'],
      zipCode: json['zipCode'],
      country: json['country'] ?? 'السعودية',
      isDefault: json['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'phone': phone,
      'email': email,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'country': country,
      'isDefault': isDefault,
    };
  }

  String get formattedAddress {
    return '$street, $city${state != null ? ', $state' : ''}${zipCode != null ? ', $zipCode' : ''}, $country';
  }
}

// lib/features/Store/data/models/review_model.dart

class Review {
  final String id;
  final String productId;
  final String userName;
  final String? userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final bool isVerifiedPurchase;
  final List<String> images;
  final int helpfulCount;

  Review({
    required this.id,
    required this.productId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.isVerifiedPurchase = false,
    List<String>? images,
    this.helpfulCount = 0,
  }) : images = images ?? [];

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'],
      productId: json['productId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      rating: (json['rating'] ?? 0).toDouble(),
      comment: json['comment'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      isVerifiedPurchase: json['isVerifiedPurchase'] ?? false,
      images: List<String>.from(json['images'] ?? []),
      helpfulCount: json['helpfulCount'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'userName': userName,
      'userAvatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'createdAt': createdAt.toIso8601String(),
      'isVerifiedPurchase': isVerifiedPurchase,
      'images': images,
      'helpfulCount': helpfulCount,
    };
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return 'منذ ${years} ${years == 1 ? 'سنة' : 'سنوات'}';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return 'منذ ${months} ${months == 1 ? 'شهر' : 'أشهر'}';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} ${difference.inDays == 1 ? 'يوم' : 'أيام'}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ${difference.inHours == 1 ? 'ساعة' : 'ساعات'}';
    } else {
      return 'منذ قليل';
    }
  }
}

// lib/features/Store/data/models/filter_model.dart

class ProductFilter {
  final RangeValues? priceRange;
  final String? category;
  final String? ageRange;
  final double? minRating;
  final String? sortBy;
  final bool? isNew;
  final bool? isBestSeller;
  final bool? hasDiscount;
  final bool? inStock;

  ProductFilter({
    this.priceRange,
    this.category,
    this.ageRange,
    this.minRating,
    this.sortBy,
    this.isNew,
    this.isBestSeller,
    this.hasDiscount,
    this.inStock,
  });

  ProductFilter copyWith({
    RangeValues? priceRange,
    String? category,
    String? ageRange,
    double? minRating,
    String? sortBy,
    bool? isNew,
    bool? isBestSeller,
    bool? hasDiscount,
    bool? inStock,
  }) {
    return ProductFilter(
      priceRange: priceRange ?? this.priceRange,
      category: category ?? this.category,
      ageRange: ageRange ?? this.ageRange,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
      isNew: isNew ?? this.isNew,
      isBestSeller: isBestSeller ?? this.isBestSeller,
      hasDiscount: hasDiscount ?? this.hasDiscount,
      inStock: inStock ?? this.inStock,
    );
  }

  bool get hasActiveFilters {
    return priceRange != null ||
        category != null ||
        ageRange != null ||
        minRating != null ||
        isNew == true ||
        isBestSeller == true ||
        hasDiscount == true ||
        inStock == true;
  }

  Map<String, dynamic> toJson() {
    return {
      'priceRange': priceRange != null
          ? {'start': priceRange!.start, 'end': priceRange!.end}
          : null,
      'category': category,
      'ageRange': ageRange,
      'minRating': minRating,
      'sortBy': sortBy,
      'isNew': isNew,
      'isBestSeller': isBestSeller,
      'hasDiscount': hasDiscount,
      'inStock': inStock,
    };
  }

  factory ProductFilter.fromJson(Map<String, dynamic> json) {
    return ProductFilter(
      priceRange: json['priceRange'] != null
          ? RangeValues(
        json['priceRange']['start'].toDouble(),
        json['priceRange']['end'].toDouble(),
      )
          : null,
      category: json['category'],
      ageRange: json['ageRange'],
      minRating: json['minRating']?.toDouble(),
      sortBy: json['sortBy'],
      isNew: json['isNew'],
      isBestSeller: json['isBestSeller'],
      hasDiscount: json['hasDiscount'],
      inStock: json['inStock'],
    );
  }
}

// lib/features/Store/data/models/wishlist_model.dart

class WishlistItem {
  final String productId;
  final DateTime addedAt;

  WishlistItem({
    required this.productId,
    DateTime? addedAt,
  }) : addedAt = addedAt ?? DateTime.now();

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      productId: json['productId'],
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'addedAt': addedAt.toIso8601String(),
    };
  }
}

class Wishlist {
  List<WishlistItem> items;
  DateTime lastUpdated;

  Wishlist({
    List<WishlistItem>? items,
    DateTime? lastUpdated,
  }) : items = items ?? [],
        lastUpdated = lastUpdated ?? DateTime.now();

  bool contains(String productId) {
    return items.any((item) => item.productId == productId);
  }

  void add(String productId) {
    if (!contains(productId)) {
      items.add(WishlistItem(productId: productId));
      lastUpdated = DateTime.now();
    }
  }

  void remove(String productId) {
    items.removeWhere((item) => item.productId == productId);
    lastUpdated = DateTime.now();
  }

  void toggle(String productId) {
    if (contains(productId)) {
      remove(productId);
    } else {
      add(productId);
    }
  }

  void clear() {
    items.clear();
    lastUpdated = DateTime.now();
  }

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  int get length => items.length;

  factory Wishlist.fromJson(Map<String, dynamic> json) {
    return Wishlist(
      items: (json['items'] as List?)
          ?.map((item) => WishlistItem.fromJson(item))
          .toList(),
      lastUpdated: DateTime.parse(
        json['lastUpdated'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}

// lib/features/Store/utils/constants.dart

class StoreConstants {
  // Colors
  static const primaryColor = Color(0xFF6C63FF);
  static const secondaryColor = Color(0xFF5A52FF);
  static const successColor = Color(0xFF00D4AA);
  static const warningColor = Color(0xFFFFC107);
  static const errorColor = Color(0xFFFF6B6B);
  static const backgroundColor = Color(0xFFF8FAFF);
  static const cardColor = Color(0xFFFFFFFF);
  static const textPrimaryColor = Color(0xFF2D3436);
  static const textSecondaryColor = Color(0xFF636E72);

  // Gradients
  static const primaryGradient = LinearGradient(
    colors: [primaryColor, secondaryColor],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFF8FAFF),
      Color(0xFFE8F2FF),
    ],
  );

  // Dimensions
  static const double borderRadius = 15.0;
  static const double cardElevation = 8.0;
  static const double iconSize = 24.0;
  static const double buttonHeight = 50.0;

  // Animation Durations
  static const Duration shortDuration = Duration(milliseconds: 300);
  static const Duration mediumDuration = Duration(milliseconds: 600);
  static const Duration longDuration = Duration(milliseconds: 1000);

  // Age Ranges
  static const List<String> ageRanges = [
    'الكل',
    '0-2 سنة',
    '3-5 سنوات',
    '6-8 سنوات',
    '9-12 سنة',
    '13+ سنة',
  ];

  // Sort Options
  static const List<String> sortOptions = [
    'الأحدث',
    'الأعلى تقييماً',
    'الأقل سعراً',
    'الأعلى سعراً',
    'الأكثر مبيعاً',
    'الاسم (أ-ي)',
  ];

  // Payment Methods
  static const List<Map<String, dynamic>> paymentMethods = [
    {
      'id': 'credit_card',
      'title': 'بطاقة ائتمانية',
      'subtitle': 'فيزا، ماستركارد، أمريكان إكسبريس',
      'icon': 'credit_card',
    },
    {
      'id': 'apple_pay',
      'title': 'Apple Pay',
      'subtitle': 'ادفع بسهولة وأمان',
      'icon': 'phone_iphone',
    },
    {
      'id': 'stc_pay',
      'title': 'STC Pay',
      'subtitle': 'محفظة إلكترونية آمنة',
      'icon': 'account_balance_wallet',
    },
    {
      'id': 'cash_on_delivery',
      'title': 'الدفع عند الاستلام',
      'subtitle': 'ادفع نقداً عند وصول المنتج',
      'icon': 'money',
    },
  ];

  // Delivery Options
  static const List<Map<String, dynamic>> deliveryOptions = [
    {
      'id': 'standard',
      'title': 'التوصيل العادي',
      'subtitle': '3-5 أيام عمل',
      'price': 15.0,
      'icon': 'local_shipping',
    },
    {
      'id': 'express',
      'title': 'التوصيل السريع',
      'subtitle': '24-48 ساعة',
      'price': 25.0,
      'icon': 'flash_on',
    },
    {
      'id': 'free',
      'title': 'التوصيل المجاني',
      'subtitle': '7-10 أيام عمل',
      'price': 0.0,
      'icon': 'card_giftcard',
    },
  ];

  // Error Messages
  static const String networkError = 'خطأ في الاتصال بالإنترنت';
  static const String serverError = 'خطأ في الخادم، يرجى المحاولة لاحقاً';
  static const String unknownError = 'حدث خطأ غير متوقع';
  static const String validationError = 'يرجى التحقق من البيانات المدخلة';
  static const String emptyCartError = 'السلة فارغة';
  static const String outOfStockError = 'المنتج غير متوفر حالياً';

  // Success Messages
  static const String addToCartSuccess = 'تم إضافة المنتج إلى السلة';
  static const String removeFromCartSuccess = 'تم حذف المنتج من السلة';
  static const String orderPlacedSuccess = 'تم تأكيد طلبك بنجاح';
  static const String promoAppliedSuccess = 'تم تطبيق كوبون الخصم';
  static const String wishlistAddedSuccess = 'تم إضافة المنتج إلى المفضلة';
  static const String wishlistRemovedSuccess = 'تم حذف المنتج من المفضلة';
}

// lib/features/Store/utils/helpers.dart

class StoreHelpers {
  // Format price with currency
  static String formatPrice(double price) {
    return '${price.toStringAsFixed(0)} ر.س';
  }

  // Format discount percentage
  static String formatDiscount(double percentage) {
    return '${percentage.toStringAsFixed(0)}% خصم';
  }

  // Generate order number
  static String generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORD-$timestamp';
  }

// Validate email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

// Validate phone number (Saudi format)
  static bool isValidPhone(String phone) {
    return RegExp(r'^(05|5)(5|0|3|6|4|9|1|8|7)[0-9]{7}$').hasMatch(phone);
  }


  // Calculate delivery date
  static DateTime calculateDeliveryDate(DeliveryOption option) {
    final now = DateTime.now();
    switch (option) {
      case DeliveryOption.express:
        return now.add(const Duration(days: 2));
      case DeliveryOption.standard:
        return now.add(const Duration(days: 4));
      case DeliveryOption.free:
        return now.add(const Duration(days: 8));
    }
  }

  // Get rating stars
  static List<bool> getRatingStars(double rating) {
    List<bool> stars = [];
    for (int i = 1; i <= 5; i++) {
      stars.add(i <= rating);
    }
    return stars;
  }

  // Calculate savings
  static double calculateSavings(double originalPrice, double currentPrice) {
    return originalPrice - currentPrice;
  }

  // Get age range color
  static Color getAgeRangeColor(String ageRange) {
    switch (ageRange) {
      case '0-2 سنة':
        return const Color(0xFFFF9999);
      case '3-5 سنوات':
        return const Color(0xFF99CCFF);
      case '6-8 سنوات':
        return const Color(0xFF99FF99);
      case '9-12 سنة':
        return const Color(0xFFFFCC99);
      case '13+ سنة':
        return const Color(0xFFCC99FF);
      default:
        return StoreConstants.primaryColor;
    }
  }

  // Sort products
  static List<ProductModel> sortProducts(List<ProductModel> products, String sortBy) {
    List<ProductModel> sorted = List.from(products);

    switch (sortBy) {
      case 'الأعلى تقييماً':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'الأقل سعراً':
        sorted.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'الأعلى سعراً':
        sorted.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'الاسم (أ-ي)':
        sorted.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'الأكثر مبيعاً':
        sorted.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'الأحدث':
      default:
      // Keep original order for newest
        break;
    }

    return sorted;
  }

  // Filter products
  static List<ProductModel> filterProducts(
      List<ProductModel> products,
      ProductFilter filter,
      ) {
    return products.where((product) {
      // Price range filter
      if (filter.priceRange != null) {
        if (product.price < filter.priceRange!.start ||
            product.price > filter.priceRange!.end) {
          return false;
        }
      }

      // Category filter
      if (filter.category != null && filter.category != 'الكل') {
        if (product.category != filter.category) {
          return false;
        }
      }

      // Age range filter
      if (filter.ageRange != null && filter.ageRange != 'الكل') {
        if (product.ageRange != filter.ageRange) {
          return false;
        }
      }

      // Rating filter
      if (filter.minRating != null) {
        if (product.rating < filter.minRating!) {
          return false;
        }
      }

      // New products filter
      if (filter.isNew == true && product.isNew != true) {
        return false;
      }

      // Best seller filter
      if (filter.isBestSeller == true && product.isBestSeller != true) {
        return false;
      }

      // Discount filter
      if (filter.hasDiscount == true && !product.hasDiscount) {
        return false;
      }

      // Stock filter
      if (filter.inStock == true && !product.inStock) {
        return false;
      }

      return true;
    }).toList();
  }

  // Search products
  static List<ProductModel> searchProducts(
      List<ProductModel> products,
      String query,
      ) {
    if (query.isEmpty) return products;

    final lowercaseQuery = query.toLowerCase();

    return products.where((product) {
      return product.name.toLowerCase().contains(lowercaseQuery) ||
          product.category.toLowerCase().contains(lowercaseQuery) ||
          product.benefits.any((benefit) =>
              benefit.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Get random products
  static List<ProductModel> getRandomProducts(
      List<ProductModel> products,
      int count,
      ) {
    if (products.length <= count) return products;

    final shuffled = List<ProductModel>.from(products)..shuffle();
    return shuffled.take(count).toList();
  }

  // Calculate estimated delivery time
  static String getEstimatedDeliveryText(DeliveryOption option) {
    final deliveryDate = calculateDeliveryDate(option);
    final formatter = DateFormat('dd/MM/yyyy', 'ar');
    return 'التسليم المتوقع: ${formatter.format(deliveryDate)}';
  }

  // Get shipping cost text
  static String getShippingCostText(double cost) {
    return cost == 0 ? 'مجاني' : formatPrice(cost);
  }

  // Validate form fields
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!isValidEmail(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم الجوال';
    }
    if (!isValidPhone(value)) {
      return 'يرجى إدخال رقم جوال صحيح';
    }
    return null;
  }
}