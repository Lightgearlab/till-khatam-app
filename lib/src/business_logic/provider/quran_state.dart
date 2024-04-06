import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:tillkhatam/src/data/model/read.dart';
import 'package:tillkhatam/src/data/model/user.dart';

@immutable
class QuranState extends Equatable {
  final List<Read>? listRead;
  final List<Read>? listReadToday;
  final User? user;

  const QuranState.initial(
      {List<Read>? listRead, User? user, List<Read>? listReadToday})
      : this(listRead: listRead, user: user, listReadToday: listReadToday);

  @override
  List<Object?> get props => [listRead, user, listReadToday];

  const QuranState(
      {required this.listRead,
      required this.user,
      required this.listReadToday});

  QuranState copyWith(
      {List<Read>? listRead, User? user, List<Read>? listReadToday}) {
    return QuranState(
        listRead: listRead ?? this.listRead,
        user: user ?? this.user,
        listReadToday: listReadToday ?? this.listReadToday);
  }
}
