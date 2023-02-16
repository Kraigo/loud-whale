import 'package:mastodon/enties/status_entity.dart';

List<StatusEntity> sortStatusesByReply(List<StatusEntity> statuses) {
  for (var index = 0; index < statuses.length; index++) {
    final item = statuses.elementAt(index);

    if (item.inReplyToId == null) continue;

    for (var parentIndex = index;
        parentIndex < statuses.length;
        parentIndex++) {
      final parentItem = statuses.elementAt(parentIndex);
      if (item.inReplyToId != parentItem.id) continue;

      statuses.removeAt(parentIndex);
      statuses.insert(index, parentItem);
      index--;
      break;
    }
  }
  return statuses;
}
