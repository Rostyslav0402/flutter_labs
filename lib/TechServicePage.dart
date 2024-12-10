import 'package:flutter/material.dart';
import 'package:project/services/apiService.dart';

class TechNewsPage extends StatelessWidget {
  final ApiService apiService = ApiService();

  TechNewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tech News'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: apiService.fetchTechNews(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news found.'));
          }

          final articles = snapshot.data!
              .where((article) => article['source']?['name'] != '[Removed]')
              .toList();

          if (articles.isEmpty) {
            return const Center(child: Text('No valid news found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: articles.length,
            itemBuilder: (context, index) {
              final article = articles[index];
              return NewsCard(article: article);
            },
          );
        },
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final Map<String, dynamic> article;

  const NewsCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    final imageUrl = article['urlToImage'];
    final title = article['title'] ?? 'No Title';
    final author = article['author'];
    final publishedAt = article['publishedAt'] != null
        ? DateTime.parse(article['publishedAt']).toLocal().toString()
        : 'Unknown Date';
    final sourceName = article['source']?['name'] ?? 'Unknown Source';

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Якщо є зображення, відображаємо його
          if (imageUrl != null)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          // Текстова частина
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Назва новини
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Автор та джерело
                if (author != null)
                  Text(
                    'By $author',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                Text(
                  'Source: $sourceName',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                // Дата публікації
                Text(
                  'Published at: $publishedAt',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 12),
                // Кнопка відкриття
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      if (article['url'] != null) {
                        // TODO: Відкрити URL
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text('Read More'),
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