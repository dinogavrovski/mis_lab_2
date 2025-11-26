import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'recipe_detail_screen.dart';

class MealsScreen extends StatefulWidget {
  final String category;
  const MealsScreen({super.key, required this.category});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen> {
  List meals = [];
  List filtered = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    meals = await ApiService.getMealsByCategory(widget.category);
    filtered = meals;
    setState(() {});
  }

  void search(String text) async {
    if (text.isEmpty) {
      filtered = meals;
    } else {
      filtered = await ApiService.searchMeals(text);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
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
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(id: m['idMeal']),
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.network(m['strMealThumb'], height: 100),
                      Text(m['strMeal']),
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
