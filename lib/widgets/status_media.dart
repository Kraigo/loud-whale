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
    const height = 250;
    const double space = 6;
    double halfHeight = (height - space) / 2;

    if (attachments.isEmpty) {
      return Container();
    }

    switch (attachments.length) {
      case 1:
        return Column(
          children: [
            _buildImage(context, attachments[0]),
          ],
        );

      // default: return Text("MEDIA ${attachments.length}");
      case 2:
        return Row(
          children: [
            Flexible(child: _buildImage(context, attachments[0])),
            const SizedBox(
              width: space,
            ),
            Flexible(child: _buildImage(context, attachments[1]))
          ],
        );
      case 3:
        return Row(
          children: [
            Flexible(
              child: _buildImage(context, attachments[0]),
            ),
            const SizedBox(
              width: space,
            ),
            Flexible(
              child: Column(
                children: [
                  _buildImage(context, attachments[1], height: halfHeight),
                  const SizedBox(
                    height: space,
                  ),
                  _buildImage(context, attachments[2], height: halfHeight)
                ],
              ),
            )
          ],
        );
      case 4:
      default:
        return Row(
          children: [
            Flexible(
              child: Column(
                children: [
                  _buildImage(context, attachments[0], height: halfHeight),
                  const SizedBox(height: space),
                  _buildImage(context, attachments[2], height: halfHeight)
                ],
              ),
            ),
            const SizedBox(width: space),
            Flexible(
              child: Column(
                children: [
                  _buildImage(context, attachments[1], height: halfHeight),
                  const SizedBox(height: space),
                  _buildImage(context, attachments[3], height: halfHeight)
                ],
              ),
            )
          ],
        );
    }
  }

  Widget _buildImage(BuildContext context, AttachmentEntity attachment,
      {double? height}) {
    return GestureDetector(
      onTap: () => {_previewImage(context, attachment)},
      child: StatusMediaPlaceholder(
          height: height,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: attachment.id,
                child: Image.network(
                  attachment.previewUrl,
                  alignment: const Alignment(0.5, 0.5),
                  fit: BoxFit.cover,
                ),
              ),
              if (attachment.isVideo)
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_circle,
                      size: 60,
                      color: Theme.of(context).primaryColor.withOpacity(0.6),
                    ),
                  ),
                ),
              Positioned(
                left: 5,
                bottom: 5,
                child: AttachmentLabel(attachment),
              )
            ],
          )),
    );
  }
}

class StatusMediaPlaceholder extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double borderRadius;
  const StatusMediaPlaceholder({
    height,
    this.child,
    this.borderRadius = 16,
    super.key,
  }) : height = height ?? 250;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 0.3,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).hintColor,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

class AttachmentLabel extends StatelessWidget {
  final AttachmentEntity attachment;
  final labels = const ['unknown', 'image', 'gif', 'video', 'audio'];
  const AttachmentLabel(this.attachment, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Tooltip(
          message: attachment.description ?? '',
          child: Text(
            labels[attachment.type].toUpperCase(),
            style:
                TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
          )),
    );
  }
}
