import 'package:bonfire/bonfire.dart';
import 'package:message_quest/player/player_beared_dude.dart';

import '../model/game_item.dart';


class BearedDudeController extends StateController<PlayerBeardedDude> {
  Map<GameItem, int> itemCounts = {}; // 持っているアイテムの数
  Map<Type, Set<int>> itemObtained = {}; // マップごとの取得済みアイテム

  @override
  void update(dt, component) {}
}
