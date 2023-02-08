import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/providers/authorization_provider.dart';
import 'package:mastodon/providers/profile_provider.dart';
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
    final profileProvider = context.read<ProfileProvider>();
    await profileProvider.loadRelationship(widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Profile'),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(3.0),
          child: _ProfileLoading(),
        ),),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: StreamBuilder(
                    stream: context
                        .read<AppDatabase>()
                        .accountDao
                        .findAccountByIdStream(widget.accountId),
                    builder: (context, snapshot) {
                      final account = snapshot.data;
                      if (account == null) {
                        return const Text("NO ACCOUNT!");
                      }

                      return ProfileHeader(account);
                    }))
          ],
        ));
  }
}

class ProfileHeader extends StatelessWidget {
  final AccountEntity account;
  const ProfileHeader(this.account, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  account.headerStatic,
                  fit: BoxFit.cover,
                )),
          ],
        ),
        MiddleContainer(
          Column(
            children: [
              Row(
                children: [
                  AccountAvatar(avatar: account.avatar),
                  Column(
                    children: [
                      Text(account.displayName),
                      Text(account.username)
                    ],
                  ),
                  Spacer(),
                  ElevatedButton(onPressed: () {}, child: Text('Follow'))
                ],
              ),
              Html(data: account.note),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: '${account.statusesCount}'),
                        TextSpan(
                            text: ' Posts',
                            style: Theme.of(context).textTheme.caption)
                      ]),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: '${account.followingCount}'),
                        TextSpan(
                            text: ' Following',
                            style: Theme.of(context).textTheme.caption)
                      ]),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text.rich(
                      TextSpan(children: [
                        TextSpan(text: '${account.followersCount}'),
                        TextSpan(
                            text: ' Followers',
                            style: Theme.of(context).textTheme.caption)
                      ]),
                    ),
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    if (profileProvider.loading) {
      return const LinearProgressIndicator();
    }
    return Container();
  }
}
