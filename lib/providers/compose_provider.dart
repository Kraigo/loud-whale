import 'package:flutter/material.dart';
import 'package:mastodon/dao/status_dao.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon/helpers/mastodon_helper.dart';
import 'package:mastodon_api/mastodon_api.dart';

class ComposeProvider extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;
  StatusDao statusDao;

  ComposeProvider({
    required this.statusDao,
  });

  Future<void> publishStatus(String text, {String? replyId}) async {
    _loading = true;
    notifyListeners();

    try {
      final resp = await MastodonHelper.api?.v1.statuses.createStatus(
        text: text,
        inReplyToStatusId: replyId,
      );
      if (resp != null) {
        await _saveStatus(resp.data);
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  _saveStatus(Status status) async {
    await statusDao.insertStatus(StatusEntity.fromModel(status));
  }
}
