import 'package:mastodon_api/mastodon_api.dart';

enum SearchType {
  all(null),
  accounts(SearchContentType.accounts),
  statuses(SearchContentType.statuses),
  hashtags(SearchContentType.hashtags);

  final SearchContentType? type;
  const SearchType(this.type);
}
