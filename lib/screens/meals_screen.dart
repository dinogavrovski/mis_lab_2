import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'recipe_detail_screen.dart';
import 'favorite_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List meals = [];
  List filtered = [];

  // Store favorites
  List favorites = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    meals = await ApiService.getMealsByCategory(widget.category);
    // Initialize isFavorite
    meals = meals
        .map(
          (m) => {
            'idMeal': m['idMeal'],
            'strMeal': m['strMeal'],
            'strMealThumb': m['strMealThumb'],
            'isFavorite': false,
          },
        )
        .toList();
    filtered = List.from(meals);
    setState(() {});
  }

  void search(String text) async {
    if (text.isEmpty) {
      filtered = List.from(meals);
    } else {
      filtered = meals
          .where(
            (m) => m['strMeal'].toString().toLowerCase().contains(
              text.toLowerCase(),
            ),
          )
          .toList();
    }
    setState(() {});
  }

  void toggleFavorite(Map meal) {
    setState(() {
      meal['isFavorite'] = !meal['isFavorite'];
      if (meal['isFavorite']) {
        favorites.add(meal);
      } else {
        favorites.removeWhere((m) => m['idMeal'] == meal['idMeal']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FavoriteScreen(favorites: favorites),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: search,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search meals',
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final m = filtered[i];
                final isFav = m['isFavorite'] == true;

                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(id: m['idMeal']),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Image.network(m['strMealThumb'], height: 100),
                          Text(m['strMeal']),
                        ],
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => toggleFavorite(m),
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.7),
                            child: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
