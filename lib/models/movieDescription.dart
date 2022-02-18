class Movie {
  final int? budget;
  final int? duration;
  final String? description;
  final bool? adult;

  const Movie({
    required this.budget,
    required this.duration,
    required this.description,
    required this.adult,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      budget: json['budget'],
      duration: json['runtime'],
      description: json['overview'],
      adult: json['adult'],
    );
  }
}
