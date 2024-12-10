class Movie {
  final String title;
  final String description;

  Movie({
    required this.title,
    required this.description,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }
}
