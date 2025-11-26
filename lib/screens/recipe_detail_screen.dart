import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RecipeDetailScreen extends StatefulWidget {
  final String id;
  const RecipeDetailScreen({super.key, required this.id});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  Map data = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    data = await ApiService.getMealDetails(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ing = data['strIngredient$i'];
      final meas = data['strMeasure$i'];
      if (ing != null && ing.toString().trim().isNotEmpty) {
        ingredients.add('$ing - $meas');
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text(data['strMeal'])),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(data['strMealThumb']),
            const SizedBox(height: 12),
            const Text(
              'Instructions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(data['strInstructions']),
            const SizedBox(height: 12),
            const Text(
              'Ingredients',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            for (var ing in ingredients) Text(ing),
            if (data['strYoutube'] != null &&
                data['strYoutube'].toString().isNotEmpty) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: () {}, child: Text(data['strYoutube'])),
            ],
          ],
        ),
      ),
    );
  }
}
