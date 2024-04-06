class User {
  int? user_id;
  String? user_name;
  String? user_finish_date;
  final int user_currentpage;
  int? user_allpage;
  String? user_autodec;
  String? user_notify_date;
  String? user_status;

  User({
    this.user_id,
    this.user_name,
    this.user_finish_date,
    required this.user_currentpage,
    this.user_allpage,
    this.user_autodec,
    this.user_notify_date,
    this.user_status,
  });
  User.fromMap(Map<String, dynamic> item)
      : user_id = item["user_id"],
        user_name = item["user_name"],
        user_finish_date = item["user_finish_date"],
        user_currentpage = item["user_currentpage"],
        user_allpage = item["user_allpage"],
        user_autodec = item["user_autodec"],
        user_notify_date = item["user_notify_date"],
        user_status = item["user_status"];

  Map<String, Object?> toMap() {
    return {
      'user_id': user_id,
      'user_name': user_name,
      'user_finish_date': user_finish_date,
      'user_currentpage': user_currentpage,
      'user_allpage': user_allpage,
      'user_autodec': user_autodec,
      'user_notify_date': user_notify_date,
      'user_status': user_status,
    };
  }

  User copyWith({
    int? user_id,
    String? user_name,
    String? user_finish_date,
    int? user_currentpage,
    int? user_allpage,
    String? user_autodec,
    String? user_notify_date,
    String? user_status,
  }) {
    return User(
      user_id: user_id ?? this.user_id,
      user_name: user_name ?? this.user_name,
      user_finish_date: user_finish_date ?? this.user_finish_date,
      user_currentpage: user_currentpage ?? this.user_currentpage,
      user_allpage: user_allpage ?? this.user_allpage,
      user_autodec: user_autodec ?? this.user_autodec,
      user_notify_date: user_notify_date ?? this.user_notify_date,
      user_status: user_status ?? this.user_status,
    );
  }

  @override
  String toString() {
    return 'User{user_id: $user_id, user_name: $user_name, user_finish_date: $user_finish_date}';
  }
}
