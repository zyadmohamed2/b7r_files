import 'package:ba7r/Core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';

class CardChoseYourMode extends StatefulWidget {
  const CardChoseYourMode(
      {super.key,
      required this.containerWidth,
      this.onTap,
      required this.color,
      required this.text,
      required this.isSlected,
      required this.video});
  final double containerWidth;
  final void Function()? onTap;
  final Color color;
  final String text;
  final bool isSlected;
  final String video;

  @override
  State<CardChoseYourMode> createState() => _CardChoseYourModeState();
}

class _CardChoseYourModeState extends State<CardChoseYourMode> {
  late VideoPlayerController videoController;
  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset(widget.video,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
      ..initialize().then(
        (value) {
          setState(() {});
        },
      );
    videoController.play();
    videoController.setVolume(0.0);
    videoController.setLooping(true);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
          duration:
              const Duration(milliseconds: 500), // Adjus animation speed here
          // color: widget.color,
          width: MediaQuery.of(context).size.width,
          height: widget.containerWidth * MediaQuery.of(context).size.height,
          child: Container(
            alignment: Alignment.centerLeft,
            child: Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: AspectRatio(
                    aspectRatio: videoController.value.aspectRatio,
                    child: VideoPlayer(videoController),
                  ),
                ),
                Container(
                  margin: widget.isSlected
                      ? EdgeInsets.only(right: 18.w)
                      : EdgeInsets.only(left: 18.w),
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 900),
                        margin: EdgeInsets.only(top: widget.isSlected ? 0 : 5),
                        alignment: Alignment.centerLeft,
                        width: widget.isSlected ? 370.w : 230.w,
                        height: widget.isSlected ? 120.h : 58.h,
                        decoration: BoxDecoration(color: widget.color),
                      ),
                      AnimatedDefaultTextStyle(
                          style: style32.copyWith(
                              fontSize: widget.isSlected ? 60 : 28),
                          duration: const Duration(milliseconds: 900),
                          child: Text(widget.text))
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
