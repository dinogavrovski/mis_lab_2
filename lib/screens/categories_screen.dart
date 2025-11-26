import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'meals_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  List categories = [];
  List filtered = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    categories = await ApiService.getCategories();
    filtered = categories;
    setState(() {});
  }

  void search(String text) {
    filtered = categories
        .where(
          (c) => c['strCategory'].toLowerCase().contains(text.toLowerCase()),
        )
        .toList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/random'),
            icon: const Icon(Icons.casino),
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
                hintText: 'Search categories',
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final c = filtered[i];
                return ListTile(
                  leading: Image.network(c['strCategoryThumb']),
                  title: Text(c['strCategory']),
                  subtitle: Text(c['strCategoryDescription']),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MealsScreen(category: c['strCategory']),
                    ),
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
