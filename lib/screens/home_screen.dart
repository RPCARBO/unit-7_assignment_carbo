import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_expanded_tile/flutter_expanded_tile.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // API limits 5 only
  Future<List<dynamic>> fetchCombatStyles() async {
    const String url = 'https://www.demonslayer-api.com/api/v1/combat-styles?page=1&limit=5';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      // Decode the response
      final data = json.decode(response.body);
      return data['content'];
    } else {
      throw Exception('Failed to load combat styles');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Demon Slayer Combat-Style Showcase",
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            fontSize: 18, 
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 214, 133, 108), 
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFD6C0B3), 
      body: FutureBuilder<List<dynamic>>(
        future: fetchCombatStyles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No combat styles available."));
          } else {
            // Display list 
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final style = snapshot.data![index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpandedTile(
                    controller: ExpandedTileController(), 
                    title: Text(
                      style['name'],
                      style: const TextStyle(
                        color: Color.fromARGB(255, 134, 70, 70),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (style['description'] != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(style['description']),
                          ),
                        if (style['img'] != null && style['img'].isNotEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                style['img'],
                                width: 500, // Set the desired width
                                height: 500, // Set the desired height
                              ),
                            ),
                          ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
