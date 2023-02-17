import 'package:flutter/material.dart';
import 'package:mastodon/base/constants.dart';
import 'package:mastodon/enties/status_entity.dart';
import 'package:mastodon/providers/compose_provider.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'compose_screen.dart';

class ReplyScreen extends StatelessWidget {
  final StatusEntity status;
  const ReplyScreen({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.3),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Card(
            elevation: 40,
            child: ReplyView(
              status: status,
            )),
      ),
    );
  }
}

class ReplyDialog extends StatelessWidget {
  final StatusEntity status;
  const ReplyDialog({
    required this.status,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Constants.padding),
        ),
        child: ReplyView(status: status));
  }
}

class ReplyView extends StatefulWidget {
  final StatusEntity status;
  const ReplyView({required this.status, super.key});

  @override
  State<ReplyView> createState() => _ReplyViewState();
}

class _ReplyViewState extends State<ReplyView> {
  void _onBack() {
    Navigator.pop(context);
  }

  void _onCompose(String text) async {
    final actualStatus = widget.status.reblog ?? widget.status;
    final replyId = actualStatus.id;
    final composeProvider = context.read<ComposeProvider>();

    try {
      await composeProvider.publishStatus(text, replyId: replyId);
      _onBack();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MiddleContainer(
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: StatusCardContent(widget.status),
          ),
        ),
        MiddleContainer(ComposeInput(
          onPublish: _onCompose,
          initialText: replyMention,
        ))
      ],
    );
  }

  String get replyMention {
    final mentions = [
      widget.status.reblog?.account?.acct,
      widget.status.account?.acct,
    ];

    return mentions.where((m) => m != null).map((m) => '@$m ').join();
  }
}
