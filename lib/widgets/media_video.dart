import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:video_player_macos/video_player_macos.dart';

class MediaVideo extends StatefulWidget {
  String url;
  MediaVideo(this.url, {super.key});

  @override
  State<MediaVideo> createState() => _MediaVideoState();
}

class _MediaVideoState extends State<MediaVideo> {
  late final VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.network(widget.url);
    // _videoController.addListener(() {
    //   setState(() {});
    // });
    _videoController.setLooping(false);
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
              ),
              VideoProgressIndicator(_videoController, allowScrubbing: true)
            ],
          );
        });
  }
}
