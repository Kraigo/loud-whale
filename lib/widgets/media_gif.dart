import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class MediaGif extends StatefulWidget {
  final String url;
  const MediaGif(this.url, { super.key});

  @override
  State<MediaGif> createState() => _MediaGifState();
}

class _MediaGifState extends State<MediaGif> {
  late final VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.url);
    _videoController.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    _videoController.dispose();
  }

  Future<bool> started() async {
    await _videoController.initialize();
    await _videoController.play();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: started(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
              )
            ],
          );
        });
  }
}
