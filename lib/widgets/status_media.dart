import 'package:flutter/material.dart';
import 'package:mastodon/base/database.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:provider/provider.dart';

class StatusMedia extends StatelessWidget {
  final List<AttachmentEntity> attachments;
  const StatusMedia(this.attachments, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: attachments.map(_buildImage).toList(),
    );
  }

  Widget _buildImage(AttachmentEntity attachment) {
    return StatusMediaPlaceholder(
        child: Image.network(
      attachment.previewUrl,
      alignment: const Alignment(0.5, 0.5),
      fit: BoxFit.fitWidth,
    ));
  }
}

class StatusMediaStream extends StatelessWidget {
  final String statusId;
  const StatusMediaStream(this.statusId, {super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: context
            .read<AppDatabase>()
            .attachmentDao
            .findAttachemntsByStatus(statusId),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const StatusMediaPlaceholder();
          }

          return StatusMedia(snapshot.data!);
        });
  }
}

class StatusMediaPlaceholder extends StatelessWidget {
  final Widget? child;
  const StatusMediaPlaceholder({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          decoration: BoxDecoration(color: Theme.of(context).hintColor),
          child: child,
        ),
      ),
    );
  }
}
