import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../services/api_service.dart';

class DetailPage extends StatefulWidget {
  final int gameId;
  const DetailPage({super.key, required this.gameId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<Map<String, dynamic>> futureGame =
      ApiService.getGameDetail(widget.gameId);
  final box = Hive.box('library');

  void addToLibrary(Map<String, dynamic> game) {
    box.put(game['id'], {
      'id': game['id'],
      'title': game['title'],
      'thumbnail': game['thumbnail'],
      'genre': game['genre'],
      'platform': game['platform'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail'), centerTitle: true),
      body: FutureBuilder<Map<String, dynamic>>(
        future: futureGame,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }

          final game = snapshot.data!;
          final screenshots = game['screenshots'] as List;

          return ListView(
            children: [
              Image.network(
                game['thumbnail'],
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        Chip(label: Text(game['genre'])),
                        Chip(label: Text(game['platform'])),
                      ],
                    ),
                    Text(
                      game['title'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Release Date: ${game['release_date']}'),
                    Text('Publisher: ${game['publisher']}'),
                    Text('Developer: ${game['developer']}'),
                    const SizedBox(height: 16),
                    ValueListenableBuilder(
                      valueListenable: box.listenable(keys: [game['id']]),
                      builder: (context, Box box, _) {
                        final owned = box.containsKey(game['id']);
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: owned ? null : () => addToLibrary(game),
                            icon: Icon(owned ? Icons.check : Icons.add),
                            label: Text(owned ? 'In Library' : 'Get'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Screenshots',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: screenshots.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Image.network(screenshots[index]['image']),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(game['description']),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}