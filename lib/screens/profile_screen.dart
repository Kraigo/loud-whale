import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/enties/entries.dart';
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
    await profileProvider.refresh(widget.accountId);
    await profileProvider.loadProfile(widget.accountId);
    await profileProvider.loadRelationship(widget.accountId);
  }

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<ProfileProvider>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(3.0),
            child: _ProfileLoading(),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            if (accountProvider.profile != null)
              SliverToBoxAdapter(child: ProfileHeader(accountProvider.profile!))
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
                  _buildFollowingButton()
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

  Widget _buildFollowingButton() {
    if (account.relationship?.isFollowing == true) {
      return TextButton.icon(
        onPressed: () {},
        label: Text('Following'),
        icon: Icon(Icons.check),
      );
    }
    return ElevatedButton(onPressed: () {}, child: Text('Follow'));
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
