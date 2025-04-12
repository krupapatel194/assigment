import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Repository Viewer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 10,
        ),
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const RepositoryTabs(),
    const CategoryPage(),  // Changed from Text widget to CategoryPage
    const Center(child: Text('Favorites Page', style: TextStyle(fontSize: 24))),
    const Center(child: Text('Profile Page', style: TextStyle(fontSize: 24))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepPurple,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          _buildBottomNavItem(Icons.home_outlined, Icons.home, 'Home', 0),
          _buildBottomNavItem(Icons.category_outlined, Icons.category, 'Category', 1),
          _buildBottomNavItem(Icons.favorite_outlined, Icons.favorite, 'Favorites', 2),
          _buildBottomNavItem(Icons.person_outlined, Icons.person, 'Profile', 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildBottomNavItem(
      IconData icon, IconData activeIcon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: _currentIndex == index
              ? Colors.deepPurple.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon),
      ),
      activeIcon: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.deepPurple.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(activeIcon),
      ),
      label: label,
    );
  }
}


class SafeNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;

  const SafeNetworkImage({
    required this.imageUrl,
    this.width = 50,
    this.height = 50,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    )
        : _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Icon(Icons.image_not_supported),
    );
  }
}

class RepositoryTabs extends StatefulWidget {
  const RepositoryTabs({super.key});

  @override
  State<RepositoryTabs> createState() => _RepositoryTabsState();
}

class _RepositoryTabsState extends State<RepositoryTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  TopData? topData;
  MiddleData? middleData;
  BottomData? bottomData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    loadData();
  }

  Future<void> loadData() async {
    try {
      final responses = await Future.wait([
        http.get(Uri.parse('http://app-interview.easyglue.in/top_repository.json')),
        http.get(Uri.parse('http://app-interview.easyglue.in/middle_repository.json')),
        http.get(Uri.parse('http://app-interview.easyglue.in/bottom_repository.json')),
      ]);

      if (responses.any((response) => response.statusCode != 200)) {
        throw Exception(
            'Failed to load data: ${responses.firstWhere((r) => r.statusCode != 200).statusCode}');
      }

      setState(() {
        topData = TopData.fromJson(json.decode(responses[0].body));
        middleData = MiddleData.fromJson(json.decode(responses[1].body));
        bottomData = BottomData.fromJson(json.decode(responses[2].body));
        isLoading = false;
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = e.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: ${e.toString()}')),
      );
    }
  }

  Widget buildTile(String title, String image, {String? subtitle}) {
    return ListTile(
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle) : null,
      leading: SafeNetworkImage(imageUrl: image),
    );
  }

  Widget topTab() {
    if (topData == null) {
      return const Center(child: Text('Top data not loaded'));
    }

    if (topData!.mainStickyMenu.isEmpty) {
      return const Center(child: Text('Top list is empty'));
    }

    return ListView.builder(
      itemCount: topData!.mainStickyMenu.length,
      itemBuilder: (context, index) {
        final item = topData!.mainStickyMenu[index];
        return ExpansionTile(
          title: Text(item.title),
          leading: SafeNetworkImage(imageUrl: item.image),
          children: item.sliderImages
              .map((slider) => ListTile(
            title: Text(slider.title),
            subtitle: Text(slider.cta),
            leading: SafeNetworkImage(
                imageUrl: slider.image, width: 40, height: 40),
          ))
              .toList(),
        );
      },
    );
  }

  Widget middleTab() {
    if (middleData == null) {
      return const Center(child: Text('No middle data available'));
    }
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Shop by Category",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...middleData!.shopByCategory.map((item) => buildTile(item.name, item.image)),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Shop by Fabric",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...middleData!.shopByFabric.map((item) => buildTile(item.name, item.image)),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Unstitched",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...middleData!.unstitched.map((item) => buildTile(item.name, item.image)),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Boutique Collection",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...middleData!.boutiqueCollection.map((item) => buildTile(item.name, item.image)),
      ],
    );
  }

  Widget bottomTab() {
    if (bottomData == null) {
      return const Center(child: Text('No bottom data available'));
    }
    return ListView(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Range of Pattern",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...bottomData!.rangeOfPattern.map((item) => buildTile(item.name, item.image)),
        const Divider(),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text("Design Occasion",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        ...bottomData!.designOccasion.map((item) => buildTile(
          item.name,
          item.image,
          subtitle: "${item.subName} ${item.cta}",
        )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          tabs: const [
            Tab(text: "Top"),
            Tab(text: "Middle"),
            Tab(text: "Bottom"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : TabBarView(
        controller: _tabController,
        children: [
          topTab(),
          middleTab(),
          bottomTab(),
        ],
      ),
    );
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late Future<CategoryData> _categoryData;

  @override
  void initState() {
    super.initState();
    _categoryData = _fetchCategoryData();
  }

  Future<CategoryData> _fetchCategoryData() async {
    try {
      final response = await http.get(
          Uri.parse('http://app-interview.easyglue.in/category_repository.json'));
      if (response.statusCode == 200) {
        return CategoryData.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load category data');
      }
    } catch (e) {
      throw Exception('Failed to load category data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CategoryData>(
      future: _categoryData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('No category data available'));
        }

        final categoryData = snapshot.data!;

        return Scaffold(
          body: Column(
            children: [
              if (categoryData.bannerImage.isNotEmpty)
                SafeNetworkImage(
                  imageUrl: categoryData.bannerImage,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              Expanded(
                child: ListView.builder(
                  itemCount: categoryData.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryData.categories[index];
                    return ExpansionTile(
                      title: Text(category.categoryName),
                      children: category.children.map((child) => ListTile(
                        title: Text(child.categoryName),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Selected: ${child.categoryName}')),
                          );
                        },
                      )).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
