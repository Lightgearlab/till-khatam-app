import 'package:flutter/foundation.dart' show ChangeNotifier;
import 'package:tillkhatam/src/business_logic/provider/quran_state.dart';
import 'package:tillkhatam/src/data/model/read.dart';
import 'package:tillkhatam/src/data/model/user.dart';
import 'package:tillkhatam/src/data/repository/read_repo.dart';
import 'package:tillkhatam/src/data/repository/user_repo.dart';

class QuranProvider with ChangeNotifier {
  QuranState? _state;

  UserRepo userRepo;
  ReadRepo readRepo;

  QuranProvider(this.userRepo, this.readRepo);

  QuranState? get state => _state;
  List<Read>? get getReadList => _state?.listRead;
  List<Read>? get getReadListToday => _state?.listReadToday;
  User? get getUser => _state?.user;

  createUser(User user) async {
    var user1 = await userRepo.getUser();
    if (user1 != null) userRepo.delete(user1.user_id);
    await userRepo.create(user);
    _state = _state?.copyWith(user: await userRepo.getUser());
    notifyListeners();
  }

  addRead(Read read) async {
    await readRepo.create(read);
    int latestpage = _state!.user!.user_currentpage;
    latestpage += read.pages_read;
    User? user = _state?.user?.copyWith(user_currentpage: latestpage);
    await userRepo.update(user!);
    _state = _state?.copyWith(
        listRead: await readRepo.viewAll(),
        user: user,
        listReadToday: await readRepo.viewAllToday());
    notifyListeners();
  }

  init() async {
    List<Read> reads = await readRepo.viewAll();
    List<Read> readsToday = await readRepo.viewAllToday();
    User? user = await userRepo.getUser();
    _state = QuranState.initial(
        listRead: reads, user: user, listReadToday: readsToday);
    notifyListeners();
  }
}
