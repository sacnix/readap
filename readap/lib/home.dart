import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'detail.dart';
import 'global_state.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late TextEditingController searchController;
  int _selectedIndex = 0;
  String selectedCategory = 'Todas';

  List<Map<String, dynamic>> stories = [];
  List<Map<String, dynamic>> filteredStories = [];
  List<Map<String, dynamic>> carouselItems = [];
  Set<String> categories = {};

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    fetchStories();
    fetchCarouselItems();
  }

  Future<void> fetchStories() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('stories').get();
    final List<Map<String, dynamic>> fetchedStories = snapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    setState(() {
      stories = fetchedStories;
      filteredStories = fetchedStories;
      categories =
          fetchedStories.map((story) => story['category'] as String).toSet();
    });
  }

  Future<void> fetchCarouselItems() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('carousel').get();
    final List<Map<String, dynamic>> fetchedCarouselItems =
        snapshot.docs.map((doc) {
      return doc.data() as Map<String, dynamic>;
    }).toList();

    setState(() {
      carouselItems = fetchedCarouselItems;
    });
  }

  void filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStories = stories;
      } else {
        filteredStories = stories
            .where((story) =>
                story['title'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      _updateCategories(filteredStories);
    });
  }

  void showFilterDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Filtros por Categoría'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _buildCategoryOption('Todas'),
              ...categories.map((category) {
                return _buildCategoryOption(category);
              }).toList(),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryOption(String category) {
    return RadioListTile<String>(
      title: Text(category),
      value: category,
      groupValue: selectedCategory,
      onChanged: (String? value) {
        setState(() {
          selectedCategory = value!;
          _applyCategoryFilter();
          Navigator.of(context).pop();
        });
      },
    );
  }

  void _applyCategoryFilter() {
    setState(() {
      if (selectedCategory == 'Todas') {
        filteredStories = stories;
      } else {
        filteredStories = stories
            .where((story) => story['category'] == selectedCategory)
            .toList();
      }
      _updateCategories(filteredStories);
    });
  }

  void _updateCategories(List<Map<String, dynamic>> currentStories) {
    setState(() {
      categories = currentStories.map((story) => story['category'] as String).toSet();
    });
  }

  void _onItemTapped(int index) {
    if (index == 1 &&
        GlobalState.lastDetailTitle != null &&
        GlobalState.lastDetailContent != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detail(
            title: GlobalState.lastDetailTitle!,
            content: GlobalState.lastDetailContent!,
          ),
        ),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(),
        ),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  void _navigateToDetail(Map<String, dynamic> item) async {
    GlobalState.lastDetailTitle = item['title'];
    GlobalState.lastDetailContent = item['body'];

    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('history').add({
        'userId': user.uid,
        'title': item['title'],
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Detail(
            title: item['title'],
            content: item['body'],
          ),
        ),
      ).then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            _buildSearchBar(),
            SizedBox(height: 20),
            _buildCarousel(),
            SizedBox(height: 20),
            ...categories.map((category) {
              final categoryStories = filteredStories
                  .where((story) => story['category'] == category)
                  .toList();
              return _buildSection(category, categoryStories);
            }).toList(),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Leer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
        selectedItemColor: Color(0xFF8D5EB2),
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: searchController,
              onChanged: filterSearch,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.tune),
            onPressed: showFilterDialog,
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return CarouselSlider(
      items: carouselItems.map((item) {
        return _buildCarouselItem(
          imagePath: item['image'],
          title: item['title'],
          description: item['description'],
        );
      }).toList(),
      options: CarouselOptions(
        height: 180.0,
        enlargeCenterPage: true,
        autoPlay: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }

  Widget _buildSection(String title, List<Map<String, dynamic>> items) {
    return Column(
      children: [
        _buildSectionTitle(title),
        _buildHorizontalList(items),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalList(List<Map<String, dynamic>> items) {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildListItem(items[index]);
        },
      ),
    );
  }

  Widget _buildListItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        _navigateToDetail(item);
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(item['url_image']),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.black.withOpacity(0.0),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                item['title'],
                style: GoogleFonts.lato(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselItem(
      {required String imagePath,
      required String title,
      required String description}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(imagePath, fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.0),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}