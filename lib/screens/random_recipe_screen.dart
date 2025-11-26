import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RandomRecipeScreen extends StatefulWidget {
  const RandomRecipeScreen({super.key});

  @override
  State<RandomRecipeScreen> createState() => _RandomRecipeScreenState();
}

class _RandomRecipeScreenState extends State<RandomRecipeScreen> {
  Map data = {};

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    data = await ApiService.getRandomMeal();
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
      appBar: AppBar(title: const Text('Random Recipe')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(data['strMealThumb']),
            const SizedBox(height: 12),
            Text(
              data['strMeal'],
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(data['strInstructions']),
            const SizedBox(height: 12),
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
