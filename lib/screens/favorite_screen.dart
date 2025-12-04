import 'package:flutter/material.dart';
import 'recipe_detail_screen.dart';

class FavoriteScreen extends StatelessWidget {
  final List favorites;
  const FavoriteScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Meals')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorite meals yet'))
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, i) {
                final meal = favorites[i];
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RecipeDetailScreen(id: meal['idMeal']),
                    ),
                  ),
                  child: Column(
                    children: [
                      Image.network(meal['strMealThumb'], height: 100),
                      Text(meal['strMeal']),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
