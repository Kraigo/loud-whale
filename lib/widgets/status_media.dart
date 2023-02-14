import 'package:flutter/material.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/utils/fade_route.dart';
import 'package:mastodon/widgets/widgets.dart';

class StatusMedia extends StatelessWidget {
  final List<AttachmentEntity> attachments;
  const StatusMedia(this.attachments, {super.key});

  _previewImage(BuildContext context, AttachmentEntity attachment) {
    Navigator.push(
      context,
      FadeRoute(
        page: MediaGallery(
          heroTag: attachment.id,
          images: attachments,
          selectedIndex: attachments.indexOf(attachment),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      // children: attachments.map(_buildImage).toList(),
      children: [
        ...attachments.map((a) => _buildImage(context, a)).toList(),
      ],
    );
  }

  Widget _buildImage(BuildContext context, AttachmentEntity attachment) {
    return GestureDetector(
      onTap: () => {_previewImage(context, attachment)},
      child: StatusMediaPlaceholder(
          child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: attachment.id,
            child: Image.network(
              attachment.previewUrl,
              alignment: const Alignment(0.5, 0.5),
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            left: 5,
            bottom: 5,
            child: _buildAttachmentLabel(attachment),
          )
        ],
      )),
    );
  }

  Widget _buildAttachmentLabel(AttachmentEntity attachment) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        ['unknown', 'image', 'gif', 'video', 'audio'][attachment.type].toUpperCase(),
        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
      ),
    );
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
