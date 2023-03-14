import 'package:flutter_test/flutter_test.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon/helpers/sort_statuses.dart';

void main() {
  test('sort statuses', () {
    final statuses = [
      createStatus('4', '3'),
      createStatus('3', '1'),
      createStatus('2', null),
      createStatus('1', null)
    ];
    final sortedStatuses = [
      createStatus('1', null),
      createStatus('3', '1'),
      createStatus('4', '3'),
      createStatus('2', null),
    ];

    sortStatusesByReply(statuses);


    expect(statuses.map((e) => e.id), sortedStatuses.map((e) => e.id));
  });
}

StatusEntity createStatus(String id, String? replyId) {
  return StatusEntity(
    id: id,
    uri: '',
    content: '',
    spoilerText: '',
    visibility: '',
    favouritesCount: 0,
    repliesCount: 0,
    reblogsCount: 0,
    createdAt: DateTime.now(),
    accountId: '',
    inReplyToId: replyId,
    hasContent: true,
  );
}
