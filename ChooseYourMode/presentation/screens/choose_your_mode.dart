import 'package:ba7r/Core/utils/text_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:ba7r/Core/utils/colors.dart';
import 'package:ba7r/Core/utils/custom_sized.dart';
import 'package:ba7r/Core/utils/images.dart';
import 'package:ba7r/Core/utils/routes.dart';
import 'package:ba7r/Core/utils/text_style.dart';
import 'package:ba7r/Features/view/ChooseYourMode/presentation/widgets/video_card_chose_your_mode.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
// class CardChoseYourMode extends StatefulWidget {
//   const CardChoseYourMode(
//       {super.key,
//       required this.containerWidth,
//       this.onTap,
//       required this.color,
//       required this.text,
//       required this.isSlected,
//       required this.video});
//   final double containerWidth;
//   final void Function()? onTap;
//   final Color color;
//   final String text;
//   final bool isSlected;
//   final String video;

//   @override
//   State<CardChoseYourMode> createState() => _CardChoseYourModeState();
// }

// class _CardChoseYourModeState extends State<CardChoseYourMode> {
//   late VideoPlayerController videoController;

//   @override
//   void initState() {
//     super.initState();
//     videoController = VideoPlayerController.asset(widget.video,
//         videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true))
//       ..initialize().then(
//         (value) {
//           setState(() {});
//         },
//       );
//     videoController.play();
//     videoController.setVolume(0.0);
//     videoController.setLooping(true);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     videoController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: AnimatedContainer(
//         duration:
//             const Duration(milliseconds: 500), // Adjust animation speed here
//         width: MediaQuery.of(context).size.width,
//         height: widget.containerWidth * MediaQuery.of(context).size.height,
//         child: Container(
//           alignment: Alignment.centerLeft,
//           child: Stack(
//             children: [
//               SizedBox(
//                 width: double.infinity,
//                 height: double.infinity,
//                 child: AspectRatio(
//                   aspectRatio: videoController.value.aspectRatio,
//                   child: VideoPlayer(videoController),
//                 ),
//               ),
//               Container(
//                 margin: widget.isSlected
//                     ? EdgeInsets.only(right: 18.w)
//                     : EdgeInsets.only(left: 18.w),
//                 alignment: Alignment.centerLeft,
//                 child: Stack(
//                   children: [
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 900),
//                       margin: EdgeInsets.only(top: widget.isSlected ? 0 : 5),
//                       alignment: Alignment.centerLeft,
//                       width: widget.isSlected ? 370.w : 230.w,
//                       height: widget.isSlected ? 120.h : 58.h,
//                       decoration: BoxDecoration(color: widget.color),
//                     ),
//                     AnimatedDefaultTextStyle(
//                       style: style32.copyWith(
//                           fontSize: widget.isSlected ? 60 : 28),
//                       duration: const Duration(milliseconds: 900),
//                       child: Text(widget.text),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }



class ChooseYourMode extends StatefulWidget {
  const ChooseYourMode({super.key});

  @override
  State<ChooseYourMode> createState() => _ChooseYourModeState();
}

class _ChooseYourModeState extends State<ChooseYourMode>
    with SingleTickerProviderStateMixin {
  late VideoPlayerController landVideo;
  late VideoPlayerController seaVideo;
  late AnimationController controller;
  late Animation<double> sea;
  late Animation<double> land;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    sea = Tween<double>(begin: 400, end: 700).animate(controller);
  }

  double _redContainerWidth = 0.5;
  double _blueContainerWidth = 0.5;
  bool isSlected = false;

  @override
  void dispose() {
    super.dispose();
    seaVideo.dispose();
    landVideo.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CardChoseYourMode(
            containerWidth: _redContainerWidth,
            color: AppColor.primaryColor,
            onTap: _onhomeScreenSeaTap,
            text: "Sea Services".tr(),
            isSlected: isSlected,
            video: AppImage.seaVideo,
          ),
          CardChoseYourMode(
            containerWidth: _blueContainerWidth,
            color: AppColor.orange,
            onTap: _onhomeScreenLandTap,
            text: "Land Services".tr(),
            isSlected: isSlected,
            video: AppImage.landVideo,
          ),
        ],
      ),
    );
  }

  void _onhomeScreenSeaTap() {
    setState(() {
      isSlected = !isSlected;
      _redContainerWidth = 1.0;
      _blueContainerWidth = 0.0;
    });
    Future.delayed(
      Duration(seconds: 2),
      () {
        context.pushNamed(AppRouter.customBottomNavigationBarSea);
      },
    );
  }

  void _onhomeScreenLandTap() {
    setState(() {
      isSlected = !isSlected;
      _redContainerWidth = 0.0;
      _blueContainerWidth = 1.0;
    });
    Future.delayed(
      Duration(seconds: 2),
      () {
        context.pushNamed(AppRouter.customBottomNavigationBarLand);
      },
    );
  }
}
