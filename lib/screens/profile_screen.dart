import 'package:flutter/material.dart';
import 'package:mastodon/enties/account_entity.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/providers/profile_provider.dart';
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
            preferredSize: Size.fromHeight(1.0),
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

  _onFollow(BuildContext context) async {
    final profileProvider = context.read<ProfileProvider>();
    final timelineProvider = context.read<TimelineProvider>();
    await profileProvider.follow(account.id);
    await timelineProvider.refresh();
    await profileProvider.loadRelationship(account.id);
  }

  _onUnfollow(BuildContext context) async {
    final profileProvider = context.read<ProfileProvider>();
    final timelineProvider = context.read<TimelineProvider>();
    await profileProvider.unfollow(account.id);
    await timelineProvider.refresh();
    await profileProvider.loadRelationship(account.id);
  }

  @override
  Widget build(BuildContext context) {
    return AccountCard(
      account,
      actions: Row(children: [_buildFollowingButton(context)]),
    );
  }

  Widget _buildFollowingButton(BuildContext context) {
    if (account.relationship?.isFollowing == true) {
      return TextButton.icon(
        onPressed: () => _onUnfollow(context),
        label: const Text('Following'),
        icon: const Icon(Icons.check),
      );
    }
    return ElevatedButton(
      onPressed: () => _onFollow(context),
      child: const Text('Follow'),
    );
  }
}

class _ProfileLoading extends StatelessWidget {
  const _ProfileLoading();

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    if (profileProvider.loading) {
      return const SizedBox(height: 1, child: LinearProgressIndicator());
    }
    return Container();
  }
}
