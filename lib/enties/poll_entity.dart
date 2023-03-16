import 'dart:convert';

import 'package:floor/floor.dart';
import 'package:mastodon_api/mastodon_api.dart';

@Entity(
  tableName: 'polls',
)
class PollEntity {
  @primaryKey
  final String id;
  final String statusId;
  final int votesCount;
  final bool isMultiple;
  final bool? isVoted;
  final bool isExpired;
  final DateTime? expiresAt;

  final String optionsData;

  List<PollOption> get options => List<PollOption>.from(
      json.decode(optionsData).map((m) => PollOption.fromJson(m)));

  final String? ownVotesData;
  List<int> get ownVotes => List<int>.from(
      json.decode(ownVotesData ?? '[]'));

  PollEntity({
    required this.id,
    required this.statusId,
    required this.votesCount,
    required this.isMultiple,
    this.isVoted,
    required this.isExpired,
    this.expiresAt,
    required this.optionsData,
    this.ownVotesData,
  });

  factory PollEntity.fromModel(String statusId, Poll model) => PollEntity(
        id: model.id,
        statusId: statusId,
        votesCount: model.votesCount,
        isMultiple: model.isMultiple,
        isVoted: model.isVoted,
        isExpired: model.isExpired,
        expiresAt: model.expiresAt,
        optionsData: jsonEncode(model.options),
        ownVotesData: jsonEncode(model.ownVotes),
      );
}
