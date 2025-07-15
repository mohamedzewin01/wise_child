// lib/features/Store/presentation/pages/Store_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wise_child/core/resources/color_manager.dart';
import 'package:wise_child/core/widgets/custom_app_bar_app.dart';
import 'package:wise_child/features/Store/data/models/product_model.dart';
import 'package:wise_child/features/Store/presentation/widgets/CartScreen.dart';
import 'package:wise_child/features/Store/presentation/widgets/CategoryScreen.dart';
import 'package:wise_child/features/Store/presentation/widgets/CheckoutScreen.dart';
import 'package:wise_child/features/Store/presentation/widgets/ProductDetailsScreen.dart';
import '../../../../core/di/di.dart';
import '../bloc/Store_cubit.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  late StoreCubit viewModel;

  @override
  void initState() {
    viewModel = getIt.get<StoreCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: viewModel,
      child: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Column(
            children: [
              CustomAppBarApp(title: 'متجر ألعاب الأطفال', subtitle: 'الالعاب العلاجية والتعليمية',colorContainerStack: const Color(0xFFF5F5F5),),
              // _buildHeader(),
              SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // const SizedBox(height: 20),
                            // _buildWelcomeSection(),
                            // const SizedBox(height: 20),
                            _buildSearchSection(),

                            _buildCategoriesGrid(),
                            const SizedBox(height: 30),
                            _buildFeaturedProducts(),
                            const SizedBox(height: 30),
                            _buildSpecialOffers(),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            right: -40,
            child: Transform.rotate(
              angle: 0.7, // لتدوير الشريط
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 57, vertical: 4),
                color: Colors.redAccent,
                child: const Text(
                  'الصفحة قيد التطوير',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        gradient:  LinearGradient(
          colors: [ColorManager.primaryColor,ColorManager.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.toys,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'متجر ألعاب الأطفال',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'العلاجية والتعليمية',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () => _navigateToCart(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Stack(
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                    size: 24,
                  ),
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFF6B6B),
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
                        '3',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [ColorManager.primaryColor, Color(0xFF5A52FF)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: ColorManager.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.child_friendly,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'ألعاب تعليمية وعلاجية للأطفال',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'نقدم أفضل الألعاب المصممة خصيصاً لدعم الأطفال ذوي الاحتياجات الخاصة وتطوير مهاراتهم بطريقة ممتعة وآمنة',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF636E72),
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => _navigateToCart(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ColorManager.primaryColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Stack(
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 24,
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6B6B),
                      shape: BoxShape.circle,
                    ),
                    child: const Text(
                      '3',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 5,),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  color: ColorManager.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن المنتجات...',
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        color: Color(0xFF636E72),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: ColorManager.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.tune,
                    color: ColorManager.primaryColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoriesGrid() {
    final categories = [
      CategoryModel(
        title: 'ألعاب تنمية التركيز',
        icon: Icons.psychology,
        color: ColorManager.primaryColor,
        description: 'ألعاب تساعد على تحسين التركيز والانتباه',
        productCount: 24,
      ),
      CategoryModel(
        title: 'ألعاب المهارات اليدوية',
        icon: Icons.pan_tool,
        color: const Color(0xFF00D4AA),
        description: 'تطوير المهارات الحركية الدقيقة',
        productCount: 18,
      ),
      CategoryModel(
        title: 'ألعاب تنمية اللغة',
        icon: Icons.record_voice_over,
        color: const Color(0xFFFF6B6B),
        description: 'تحسين النطق والمهارات اللغوية',
        productCount: 15,
      ),
      CategoryModel(
        title: 'أدوات حسية',
        icon: Icons.touch_app,
        color: const Color(0xFF845EC2),
        description: 'أدوات للتحفيز الحسي والاسترخاء',
        productCount: 12,
      ),
      CategoryModel(
        title: 'ألعاب التفاعل الأسري',
        icon: Icons.family_restroom,
        color: const Color(0xFFFFC75F),
        description: 'ألعاب تعزز التفاعل مع الأسرة',
        productCount: 21,
      ),
      CategoryModel(
        title: 'باقات حسب الحالة',
        icon: Icons.medical_services,
        color: const Color(0xFF4ECDC4),
        description: 'باقات مخصصة لحالات محددة',
        productCount: 8,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'الفئات الرئيسية',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            TextButton(
              onPressed: () {},
              child:  Text(
                'عرض الكل',
                style: TextStyle(
                  color: ColorManager.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.9,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryCard(categories[index]);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(CategoryModel category) {
    return GestureDetector(
      onTap: () => _navigateToCategory(category),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: category.color.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    category.color.withOpacity(0.1),
                    category.color.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                category.icon,
                size: 32,
                color: category.color,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              category.title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '${category.productCount} منتج',
              style: TextStyle(
                fontSize: 12,
                color: category.color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedProducts() {
    final products = [
      ProductModel(
        id: '1',
        name: 'مكعبات التركيز الملونة',
        price: 120,
        originalPrice: 150,
        image: 'https://cdn.salla.sa/ePZnD/xKWDremqsW2P7CliI08OgotZSHlngIGXwZfRshdB.jpg',
        category: 'تنمية التركيز',
        ageRange: '3-7 سنوات',
        rating: 4.8,
        reviewCount: 124,
        isNew: true,
        benefits: ['تحسين التركيز', 'تنمية الذاكرة', 'تطوير المهارات البصرية'],
      ),
      ProductModel(
        id: '2',
        name: 'لعبة الأحرف التفاعلية',
        price: 85,
        originalPrice: 95,
        image: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=300',
        category: 'تنمية اللغة',
        ageRange: '4-8 سنوات',
        rating: 4.6,
        reviewCount: 89,
        benefits: ['تحسين النطق', 'تعلم الأحرف', 'تطوير المفردات'],
      ),
      ProductModel(
        id: '3',
        name: 'أدوات التحفيز الحسي',
        price: 200,
        originalPrice: 250,
        image: 'https://images.unsplash.com/photo-1515488042361-ee00e0ddd4e4?w=300',
        category: 'أدوات حسية',
        ageRange: '2-10 سنوات',
        rating: 4.9,
        reviewCount: 156,
        isBestSeller: true,
        benefits: ['تهدئة الحواس', 'تحسين التركيز', 'تقليل التوتر'],
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'المنتجات المميزة',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            TextButton(
              onPressed: () => _navigateToAllProducts(),
              child:  Text(
                'عرض الكل',
                style: TextStyle(
                  color:ColorManager.primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 320,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return _buildProductCard(products[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return GestureDetector(
      onTap: () => _navigateToProduct(product),
      child: Container(
        width: 220,
        margin: const EdgeInsets.only(left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 160,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: NetworkImage(product.image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.isNew == true
                          ? const Color(0xFF00D4AA)
                          : product.isBestSeller == true
                          ? const Color(0xFFFF6B6B)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      product.isNew == true
                          ? 'جديد'
                          : product.isBestSeller == true
                          ? 'الأكثر مبيعاً'
                          : '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child:  Icon(
                      Icons.favorite_border,
                      size: 18,
                      color: ColorManager.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 14,
                        color: Colors.amber[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF636E72),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product.price} ر.س',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00D4AA),
                            ),
                          ),
                          if (product.originalPrice != null)
                            Text(
                              '${product.originalPrice} ر.س',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF636E72),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _addToCart(product),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [ColorManager.chatUserBg,
                                ColorManager.primaryColor,],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: ColorManager.primaryColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialOffers() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [ColorManager.chatUserBg,
            ColorManager.primaryColor,],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: ColorManager.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'عروض خاصة!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'خصم يصل إلى 30% على باقات العلاج المتخصصة',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => _navigateToOffers(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: ColorManager.primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'تصفح العروض',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_offer,
              size: 40,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToCategory(CategoryModel category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryScreen(category: category),
      ),
    );
  }

  void _navigateToProduct(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsScreen(product: product),
      ),
    );
  }

  void _navigateToCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  void _navigateToAllProducts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AllProductsScreen(),
      ),
    );
  }

  void _navigateToOffers() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const OffersScreen(),
      ),
    );
  }

  void _addToCart(ProductModel product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text('تم إضافة ${product.name} إلى السلة'),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF00D4AA),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
