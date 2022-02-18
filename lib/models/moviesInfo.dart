class Movies {
  final bool? adult;
  final String? posterImage;
  final String? title;
  final String? description;
  final String? date;
  final double? rating;
  final int? id;
  final String? backgroundPoster;
  final String? overview;

  const Movies({
    required this.adult,
    required this.posterImage,
    required this.title,
    required this.description,
    required this.date,
    required this.rating,
    required this.id,
    required this.backgroundPoster,
    required this.overview,
  });

  factory Movies.fromJson(Map<String, dynamic> json) {
    return Movies(
      adult: json['adult'],
      posterImage: json['backdrop_path'],
      title: json['original_title'],
      description: json['overview'],
      date: json['release_date'],
      rating: json['vote_average']!.toDouble(),
      id: json['id'],
      backgroundPoster: json['backdrop_path'],
      overview: json['overview'],
    );
  }
}
