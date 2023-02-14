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
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder<bool>(
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
                Container(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PlayPauseButton(
                          _videoController,
                        ),
                        Expanded(
                          child: VideoProgressIndicator(_videoController,
                              allowScrubbing: true, padding: EdgeInsets.zero,),
                        ),
                        VolumeButton(_videoController)
                      ],
                    ))
              ],
            );
          }),
    );
  }
}

class PlayPauseButton extends StatefulWidget {
  final VideoPlayerController controller;
  const PlayPauseButton(this.controller, {super.key});

  @override
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          widget.controller.value.isPlaying
              ? await widget.controller.pause()
              : await widget.controller.play();
          setState(() {});
        },
        icon: Icon(
          widget.controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
        ));
  }
}

class VolumeButton extends StatefulWidget {
  final VideoPlayerController controller;
  const VolumeButton(this.controller, {super.key});

  @override
  State<VolumeButton> createState() => _VolumeButtonState();
}

class _VolumeButtonState extends State<VolumeButton> {
  bool get isVolumeEnabled {
    return widget.controller.value.volume > 0;
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () async {
          isVolumeEnabled
              ? await widget.controller.setVolume(0)
              : await widget.controller.setVolume(1);
          setState(() {});
        },
        icon: Icon(
          isVolumeEnabled ? Icons.volume_up : Icons.volume_off,
          color: Colors.white,
        ));
  }
}
