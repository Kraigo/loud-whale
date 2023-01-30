import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/providers/timeline_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final String accountId;
  const ProfileScreen({required this.accountId, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    Future.microtask(_loadInitial);
    super.initState();
  }

  _loadInitial() async {
    // context.read<TimelineProvider>().loadTimeline();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: StreamBuilder(
                    stream: context
                        .read<AppDatabase>()
                        .accountDao
                        .findAccountById(widget.accountId),
                    builder: (context, snapshot) {
                      final account = snapshot.data;
                      if (account == null) {
                        return Text("NO ACCOUNT!");
                      }
                      return _ProfileCard(account);
                    }))
          ],
        ));
  }
}

class _ProfileCard extends StatelessWidget {
  final AccountEntity account;
  const _ProfileCard(this.account, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Row(
          children: [
            AccountAvatar(avatar: account.avatar),
            Column(
              children: [Text(account.displayName), Text(account.username)],
            )
          ],
        ),
        Html(data: account.note)
      ],
    ));
  }
}
