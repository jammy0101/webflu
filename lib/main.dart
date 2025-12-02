// lib/main.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const FreshValleyCloneApp());
}

/// Simple product model
class Product {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

/// Simple Cart provider
class CartModel extends ChangeNotifier {
  final Map<String, int> _items = {};

  Map<String, int> get items => Map.unmodifiable(_items);

  int get totalQuantity =>
      _items.values.fold(0, (previous, current) => previous + current);

  void add(Product p) {
    _items.update(p.id, (q) => q + 1, ifAbsent: () => 1);
    notifyListeners();
  }

  void removeOne(Product p) {
    if (!_items.containsKey(p.id)) return;
    final q = _items[p.id]!;
    if (q <= 1) {
      _items.remove(p.id);
    } else {
      _items[p.id] = q - 1;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
late PageController _pageController;
int _currentPage = 0;

/// Demo data — replace images or text to match your branding.
final List<Product> demoProducts = [
  Product(
    id: 'p1',
    title: 'Organic Honey',
    description: 'Raw farm honey — 500g jar.',
    price: 9.99,
    imageUrl:
    'https://images.unsplash.com/photo-1517685352821-92cf88aee5a5?auto=format&fit=crop&w=800&q=60',
    category: 'Pantry',
  ),
  Product(
    id: 'p2',
    title: 'Fresh Spinach',
    description: 'Local organic spinach — bunch.',
    price: 2.49,
    imageUrl:
    'https://images.unsplash.com/photo-1518976024611-0d3f7d0c2f6f?auto=format&fit=crop&w=800&q=60',
    category: 'Vegetables',
  ),
  Product(
    id: 'p3',
    title: 'Almond Milk',
    description: 'Unsweetened almond milk — 1L.',
    price: 3.99,
    imageUrl:
    'https://images.unsplash.com/photo-1582719478171-8f6b5b4f6a4f?auto=format&fit=crop&w=800&q=60',
    category: 'Dairy Alternatives',
  ),
  Product(
    id: 'p4',
    title: 'Organic Eggs (6)',
    description: 'Free-range eggs — pack of 6.',
    price: 4.25,
    imageUrl:
    'https://images.unsplash.com/photo-1514361892631-5c7a9b9d7f12?auto=format&fit=crop&w=800&q=60',
    category: 'Dairy',
  ),
  Product(
    id: 'p5',
    title: 'Multigrain Bread',
    description: 'Fresh baked daily — 400g.',
    price: 3.25,
    imageUrl:
    'https://images.unsplash.com/photo-1543536442-1859cd29d2b8?auto=format&fit=crop&w=800&q=60',
    category: 'Bakery',
  ),
  Product(
    id: 'p6',
    title: 'Avocado',
    description: 'Creamy ripe avocado — each.',
    price: 1.79,
    imageUrl:
    'https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?auto=format&fit=crop&w=800&q=60',
    category: 'Fruits',
  ),
];

class FreshValleyCloneApp extends StatelessWidget {
  const FreshValleyCloneApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Provider for cart
    return ChangeNotifierProvider(
      create: (_) => CartModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fresh Valley - Flutter Clone',
        theme: ThemeData(
          primarySwatch: Colors.green,
          textTheme: GoogleFonts.interTextTheme(),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

// ------------------- Home Page -------------------
class _HomePageState extends State<HomePage> {
  final List<String> heroImages = [
    'https://images.unsplash.com/photo-1506806732259-39c2d0268443?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1542831371-d531d36971e6?auto=format&fit=crop&w=1400&q=80',
    'https://images.unsplash.com/photo-1526318472351-c75fcf070ee9?auto=format&fit=crop&w=1400&q=80',
  ];

  String searchQuery = '';
  String selectedCategory = 'All';

  List<String> categories = [
    'All',
    'Vegetables',
    'Fruits',
    'Pantry',
    'Dairy',
    'Bakery',
    'Dairy Alternatives'
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    // autoplay
    Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % heroImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final filtered = demoProducts.where((p) {
      final matchesCategory =
      (selectedCategory == 'All' || p.category == selectedCategory);
      final matchesSearch = p.title.toLowerCase().contains(searchQuery) ||
          p.description.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // Logo area; replace with Image.asset(...) if you have a logo.
            const Icon(Icons.eco, size: 28),
            const SizedBox(width: 8),
            Text(
              'Fresh Valley',
              style: GoogleFonts.bebasNeue(
                fontSize: 22,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(width: 12),
            // small subtitle
            Expanded(
              child: Text(
                '— organic groceries delivered fresh',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Offers',
            onPressed: () {},
            icon: const Icon(Icons.local_offer_outlined),
          ),
          IconButton(
            tooltip: 'Account',
            onPressed: () {},
            icon: const Icon(Icons.person_outline),
          ),
          Consumer<CartModel>(
            builder: (context, cart, _) => Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  onPressed: () => _openCart(context),
                  icon: const Icon(Icons.shopping_cart_outlined),
                ),
                if (cart.totalQuantity > 0)
                  Positioned(
                    right: 6,
                    top: 8,
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cart.totalQuantity.toString(),
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeroCarousel(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: isWide
                    ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 2, child: _buildSearchAndCategories()),
                    const SizedBox(width: 20),
                    Expanded(flex: 3, child: _buildProductGrid(filtered)),
                  ],
                )
                    : Column(
                  children: [
                    _buildSearchAndCategories(),
                    const SizedBox(height: 12),
                    _buildProductGrid(filtered),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildFooter(),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeroCarousel() {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: heroImages.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, index) {
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(heroImages[index]),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.25),
                          BlendMode.darken,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Farm to Table\nDelivered Fresh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 34,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Organic produce, local suppliers, and fast delivery in your area.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 18),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('Shop Now'),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // --- Page Indicators ---
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(heroImages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 18 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSearchAndCategories() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search box
        TextField(
          onChanged: (v) => setState(() => searchQuery = v.toLowerCase()),
          decoration: InputDecoration(
            hintText: 'Search for products, e.g. "spinach", "almond"',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Categories
        SizedBox(
          height: 42,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final selected = cat == selectedCategory;
              return InkWell(
                onTap: () => setState(() => selectedCategory = cat),
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? Colors.green.shade700 : Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected ? Colors.green.shade700 : Colors.grey[300]!,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black87,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        // Promo strip
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green.shade100),
          ),
          child: Row(
            children: [
              const Icon(Icons.local_shipping, size: 28, color: Colors.green),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Free delivery for orders above \$50 • Same day pickup available',
                  style: TextStyle(
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Learn more'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    // Use Grid with adaptive column count
    return LayoutBuilder(builder: (context, constraints) {
      final crossAxis = constraints.maxWidth ~/ 220; // each card ~220px
      final crossAxisCount = crossAxis.clamp(1, 4);
      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemBuilder: (context, index) {
          final p = products[index];
          return ProductCard(
            product: p,
            onAdd: () => Provider.of<CartModel>(context, listen: false).add(p),
            onTap: () => _openProductDetail(context, p),
          );
        },
      );
    });
  }

  void _openCart(BuildContext context) {
    final cart = Provider.of<CartModel>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        if (cart.items.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: 200,
            child: Center(
              child: Text('Your cart is empty. Add tasty things!'),
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          height: 420,
          child: Column(
            children: [
              Row(
                children: [
                  const Text('Your Cart',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  TextButton(
                      onPressed: () => cart.clear(), child: const Text('Clear')),
                ],
              ),
              const Divider(),
              Expanded(
                child: ListView(
                  children: cart.items.entries.map((entry) {
                    final product =
                    demoProducts.firstWhere((p) => p.id == entry.key);
                    final qty = entry.value;
                    return ListTile(
                      leading: Image.network(product.imageUrl, width: 56),
                      title: Text(product.title),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                              onPressed: () =>
                                  Provider.of<CartModel>(context, listen: false)
                                      .removeOne(product),
                              icon: const Icon(Icons.remove_circle_outline)),
                          Text(qty.toString()),
                          IconButton(
                              onPressed: () =>
                                  Provider.of<CartModel>(context, listen: false)
                                      .add(product),
                              icon: const Icon(Icons.add_circle_outline)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // checkout placeholder
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Checkout flow not implemented.')));
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 18),
                  child: Text('Proceed to Checkout'),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700),
              )
            ],
          ),
        );
      },
    );
  }

  void _openProductDetail(BuildContext context, Product product) {
    showDialog(
        context: context,
        builder: (ctx) {
          return Dialog(
            insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: SizedBox(
              width: 720,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Image.network(product.imageUrl,
                                fit: BoxFit.cover, height: 220),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.title,
                                    style: const TextStyle(
                                        fontSize: 20, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Text(product.description),
                                const SizedBox(height: 12),
                                Text('\$${product.price.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        Provider.of<CartModel>(context, listen: false)
                                            .add(product);
                                        Navigator.of(ctx).pop();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text('${product.title} added to cart'),
                                          duration: const Duration(seconds: 1),
                                        ));
                                      },
                                      icon: const Icon(Icons.add_shopping_cart_outlined),
                                      label: const Text('Add to Cart'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade700,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    OutlinedButton(
                                      onPressed: () => Navigator.of(ctx).pop(),
                                      child: const Text('Close'),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      // More details placeholder
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Product details',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey.shade800)),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'This is a demo product description. Replace with real content from your backend or CMS. Add origin, weight, reviews, and shipping details as needed.',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        children: [
          // Top footer links
          LayoutBuilder(builder: (context, constraints) {
            final isWide = constraints.maxWidth > 800;
            return isWide
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fresh Valley',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Text(
                          'Local organic groceries delivered fresh to your door. Supporting local farms and sustainable practices.',
                          style: TextStyle(color: Colors.grey.shade700)),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                _footerColumn('Shop', ['Vegetables', 'Fruits', 'Pantry', 'Bakery']),
                _footerColumn('Company', ['About', 'Careers', 'Blog', 'Contact']),
                _footerColumn('Support', ['Help center', 'Delivery', 'Returns', 'Privacy']),
              ],
            )
                : Column(
              children: [
                Text('Fresh Valley',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                    'Local organic groceries delivered fresh to your door. Supporting local farms and sustainable practices.',
                    style: TextStyle(color: Colors.grey.shade700)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _footerColumn('Shop', ['Vegetables', 'Fruits'])),
                    Expanded(child: _footerColumn('Company', ['About', 'Careers'])),
                    Expanded(child: _footerColumn('Support', ['Help center', 'Delivery'])),
                  ],
                )
              ],
            );
          }),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.shade300),
          const SizedBox(height: 8),
          Text(
            '© ${DateTime.now().year} Fresh Valley — All rights reserved',
            style: TextStyle(color: Colors.grey.shade700),
          ),
        ],
      ),
    );
  }

  Widget _footerColumn(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        for (final i in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(i, style: TextStyle(color: Colors.grey.shade700)),
          ),
      ]),
    );
  }
}

// ---------------- Product Card ----------------
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onAdd;
  final VoidCallback onTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onAdd,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Card with image, category, title, price and add button
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // product image
            Expanded(
              flex: 5,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(product.imageUrl, fit: BoxFit.cover),
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          product.category,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // info area
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style:
                      const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(product.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    const Spacer(),
                    Row(
                      children: [
                        Text('\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: onAdd,
                          child: const Icon(Icons.add_shopping_cart_outlined, size: 18),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(36, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: Colors.green.shade700,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
