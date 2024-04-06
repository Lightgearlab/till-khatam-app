class Read {
  final int? id;
  final int pages_read;
  final String reading_date;

  const Read({required this.pages_read, required this.reading_date, this.id});

  factory Read.fromJson(Map<String, dynamic> json) => Read(
        pages_read: json['pages_read'],
        reading_date: json['reading_date'],
        id: json['id'],
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'pages_read': pages_read,
        'reading_date': reading_date,
      };

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'pages_read': pages_read,
      'reading_date': reading_date,
    };
  }
}
