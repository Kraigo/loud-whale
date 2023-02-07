import 'package:flutter/material.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/utils/fade_route.dart';
import 'package:photo_view/photo_view.dart';

class StatusMedia extends StatelessWidget {
  final List<AttachmentEntity> attachments;
  const StatusMedia(this.attachments, {super.key});

  _previewImage(BuildContext context, AttachmentEntity attachment) {
    Navigator.push(
      context,
      FadeRoute(
        page: HeroPhotoViewRouteWrapper(
          heroTag: attachment.id,
          imageProvider: NetworkImage(
            attachment.previewUrl,
          ),
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
          child: Hero(
              tag: attachment.id,
              child: Image.network(
                attachment.previewUrl,
                alignment: const Alignment(0.5, 0.5),
                fit: BoxFit.fitWidth,
              ))),
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

class HeroPhotoViewRouteWrapper extends StatelessWidget {
  final ImageProvider imageProvider;
  final BoxDecoration? backgroundDecoration;
  final String? heroTag;
  final dynamic minScale;
  final dynamic maxScale;

  const HeroPhotoViewRouteWrapper({
    required this.imageProvider,
    this.backgroundDecoration,
    this.heroTag,
    this.minScale,
    this.maxScale,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              PhotoView(
                imageProvider: imageProvider,
                backgroundDecoration: backgroundDecoration,
                minScale: PhotoViewComputedScale.contained * 1,
                maxScale: PhotoViewComputedScale.covered * 1.5,
                heroAttributes: heroTag != null
                    ? PhotoViewHeroAttributes(tag: heroTag!)
                    : null,
              ),
              Positioned(
                left: 10,
                top: 10,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: Text("Close"),
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          )),
    );
  }
}
