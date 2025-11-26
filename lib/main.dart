import 'package:flutter/material.dart';
import 'screens/categories_screen.dart';
import 'screens/random_recipe_screen.dart';

void main() {
  runApp(const MealApp());
}

class MealApp extends StatelessWidget {
  const MealApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const CategoriesScreen(),
      routes: {'/random': (_) => const RandomRecipeScreen()},
    );
  }
}
