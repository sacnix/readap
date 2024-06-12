import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'detail.dart';
import 'global_state.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, String>> popularItems = [
    {
      'title': 'La leyenda de la serpiente blanca',
      'content':
          'Había una vez un pequeño pueblo enclavado entre altas montañas y densos bosques...'
    },
    {'title': 'Otra historia', 'content': 'This is another story content...'},
    {
      'title': 'Aquí otra historia',
      'content': 'This is yet another story content...'
    },
    {'title': 'La montaña', 'content': 'This is more story content...'}
  ];

  final List<Map<String, String>> fantasyItems = [
    {
      'title': 'Fantasy Story 1',
      'image': 'assets/images/fantasy1.jpg',
      'content': 'Content of Fantasy Story 1'
    },
    {
      'title': 'Fantasy Story 2',
      'image': 'assets/images/fantasy2.jpg',
      'content': 'Content of Fantasy Story 2'
    },
    {
      'title': 'Fantasy Story 3',
      'image': 'assets/images/fantasy3.jpg',
      'content': 'Content of Fantasy Story 3'
    },
  ];

  final List<Map<String, String>> adventureItems = [
    {
      'title': 'Adventure Story 1',
      'image': 'assets/images/adventure1.jpg',
      'content': 'Content of Adventure Story 1'
    },
    {
      'title': 'Adventure Story 2',
      'image': 'assets/images/adventure2.jpg',
      'content': 'Content of Adventure Story 2'
    },
    {
      'title': 'Adventure Story 3',
      'image': 'assets/images/adventure3.jpg',
      'content': 'Content of Adventure Story 3'
    },
  ];

  late List<Map<String, String>> filteredPopularItems;
  late List<Map<String, String>> filteredFantasyItems;
  late List<Map<String, String>> filteredAdventureItems;
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 0;
  String selectedCategory = 'Todas';

  @override
  void initState() {
    super.initState();
    filteredPopularItems = popularItems;
    filteredFantasyItems = fantasyItems;
    filteredAdventureItems = adventureItems;
  }

  void filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _resetFilters();
      } else {
        filteredPopularItems = _filterItems(popularItems, query);
        filteredFantasyItems = _filterItems(fantasyItems, query);
        filteredAdventureItems = _filterItems(adventureItems, query);
      }
    });
  }

  void _resetFilters() {
    filteredPopularItems = popularItems;
    filteredFantasyItems = fantasyItems;
    filteredAdventureItems = adventureItems;
  }

  List<Map<String, String>> _filterItems(
      List<Map<String, String>> items, String query) {
    return items
        .where((item) =>
            item['title']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
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
              _buildCategoryOption('Populares'),
              _buildCategoryOption('Fantasía'),
              _buildCategoryOption('Aventura'),
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
        _resetFilters();
      } else if (selectedCategory == 'Populares') {
        filteredPopularItems = popularItems;
        filteredFantasyItems = [];
        filteredAdventureItems = [];
      } else if (selectedCategory == 'Fantasía') {
        filteredPopularItems = [];
        filteredFantasyItems = fantasyItems;
        filteredAdventureItems = [];
      } else if (selectedCategory == 'Aventura') {
        filteredPopularItems = [];
        filteredFantasyItems = [];
        filteredAdventureItems = adventureItems;
      }
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
          builder: (context) => Profile(
            username: 'John Doe',
            email: 'john.doe@example.com',
          ),
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

  void _navigateToDetail(Map<String, String> item) {
    GlobalState.lastDetailTitle = item['title'];
    GlobalState.lastDetailContent = item['content'];
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Detail(
          title: item['title']!,
          content: item['content']!,
        ),
      ),
    ).then((_) {
      setState(() {
        _selectedIndex = 0;
      });
    });
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
            if (filteredPopularItems.isNotEmpty)
              _buildSection('Populares', filteredPopularItems),
            SizedBox(height: 20),
            if (filteredFantasyItems.isNotEmpty)
              _buildSection('Fantasía', filteredFantasyItems),
            SizedBox(height: 20),
            if (filteredAdventureItems.isNotEmpty)
              _buildSection('Aventura', filteredAdventureItems),
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
      items: [
        _buildCarouselItem(
          imagePath: 'assets/images/carousel1.jpg',
          title: 'La puerta celeste',
          description: 'Otro pasaje mágico',
        ),
        _buildCarouselItem(
          imagePath: 'assets/images/carousel2.jpg',
          title: 'Cementerio Susurrante',
          description: '¿Tumbas que hablan?',
        ),
        _buildCarouselItem(
          imagePath: 'assets/images/carousel3.jpg',
          title: 'El Jinete Enmascarado',
          description: '¿Héroe o villano?',
        ),
      ],
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

  Widget _buildSection(String title, List<Map<String, String>> items) {
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

  Widget _buildHorizontalList(List<Map<String, String>> items) {
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

  Widget _buildListItem(Map<String, String> item) {
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
            image: item.containsKey('image')
                ? AssetImage(item['image']!)
                : AssetImage('assets/images/item_placeholder.jpg'),
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
                item['title']!,
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
