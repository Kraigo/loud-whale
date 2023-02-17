import 'package:flutter/material.dart';
import 'package:mastodon/enties/entries.dart';
import 'package:mastodon/widgets/widgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MediaGallery extends StatefulWidget {
  final BoxDecoration? backgroundDecoration;
  final String? heroTag;
  final dynamic minScale;
  final dynamic maxScale;
  final List<AttachmentEntity> images;
  final int selectedIndex;

  const MediaGallery({
    required this.selectedIndex,
    this.backgroundDecoration,
    this.heroTag,
    this.minScale,
    this.maxScale,
    this.images = const [],
    super.key,
  });

  @override
  State<MediaGallery> createState() => _MediaGalleryState();
}

class _MediaGalleryState extends State<MediaGallery> {
  int currentIndex = 0;
  late final PageController pageController;

  @override
  void initState() {
    currentIndex = widget.selectedIndex;
    pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  bool get _isCurrentFirst {
    return currentIndex == 0;
  }

  bool get _isCurrentLast {
    return currentIndex == widget.images.length - 1;
  }

  bool get _isSingle {
    return widget.images.length == 1;
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    final attachment = widget.images[index];

    switch (attachment.type) {
      // image
      case 1:
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(attachment.url),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.covered * 1.5,
          heroAttributes: PhotoViewHeroAttributes(tag: attachment.id),
        );

      // gifv
      case 2:
        return PhotoViewGalleryPageOptions.customChild(
          child: MediaGif(attachment.url),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.covered * 1.5,
          heroAttributes: PhotoViewHeroAttributes(tag: attachment.id),
        );

      // video
      case 3:
        return PhotoViewGalleryPageOptions.customChild(
          child: MediaVideo(attachment.url),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.covered * 1.5,
          heroAttributes: PhotoViewHeroAttributes(tag: attachment.id),
        );

      // audio
      case 4:
      default:
        return PhotoViewGalleryPageOptions(
          imageProvider: NetworkImage(attachment.previewUrl),
          initialScale: PhotoViewComputedScale.contained,
          minScale: PhotoViewComputedScale.contained * 1,
          maxScale: PhotoViewComputedScale.covered * 1.5,
          heroAttributes: PhotoViewHeroAttributes(tag: attachment.id),
        );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: Stack(
            children: [
              PhotoViewGallery.builder(
                builder: _buildItem,
                itemCount: widget.images.length,
                scrollPhysics: const BouncingScrollPhysics(),
                pageController: pageController,
                onPageChanged: _onPageChanged,
              ),
              Positioned(
                left: 10,
                top: 10,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  label: const Text("Close"),
                  icon: const Icon(Icons.close),
                ),
              ),
              if (!_isSingle)
                Positioned(
                    left: 10,
                    bottom: 10,
                    child: TextButton.icon(
                      onPressed: _isCurrentFirst
                          ? null
                          : () {
                              pageController.previousPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            },
                      icon: const Icon(Icons.chevron_left),
                      label: const Text("Prev"),
                    )),
              if (!_isSingle)
                Positioned(
                    right: 10,
                    bottom: 10,
                    child: TextButton.icon(
                      onPressed: _isCurrentLast
                          ? null
                          : () {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeIn);
                            },
                      icon: const Icon(Icons.chevron_right),
                      label: const Text("Next"),
                    )),
            ],
          )),
    );
  }
}
