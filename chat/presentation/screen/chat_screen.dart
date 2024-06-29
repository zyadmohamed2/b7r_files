import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:ba7r/Core/function/log.dart' as log;
import 'package:ba7r/Core/utils/colors.dart';
import 'package:ba7r/Core/utils/images.dart';
import 'package:ba7r/Core/widgets/custom_appBar.dart';
import 'package:ba7r/Core/widgets/custom_cached_network_image.dart';
import 'package:ba7r/Features/view/ProfileSession/data/model/user_information_model.dart';
import 'package:ba7r/Features/view_model/profile/profile_bloc.dart';
import 'package:ba7r/id.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'dart:ui' as ui;

class ChatScreen extends StatefulWidget {
  ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController chatController = TextEditingController();
  UserInformationModel? user;
  ScrollController controller = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.animateTo(10,
        duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
    BlocProvider.of<ProfileBloc>(context).add(GetUserInformation());
  }

  CollectionReference massage = FirebaseFirestore.instance
      .collection("chatDashBoard")
      .doc(Id.UserIdString)
      .collection("massage");
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
          appBar: customAppBar(title: "Chat Room".tr(), context: context),
          body: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is SuccessGetProfileInformation) {
                user = state.userInformationModel;
              }
            },
            builder: (context, state) {
              // log(massage..toString());
              if (user != null) {
                log.log(user!.email);
                return Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream:
                          massage.orderBy("date", descending: true).snapshots(),
                      builder: (context, snapshot) {
                        // log(snapshot.data!.docs.toString());
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 80),
                            child: ListView(
                              reverse: true,
                              controller: controller,
                              children: [
                                ...List.generate(snapshot.data!.docs.length,
                                    (index) {
                                  return ChatContent(
                                    adminMassage: true,
                                    type: "text",
                                    isSeen: false,
                                    image: snapshot
                                                .data!.docs[index]["senderId"]
                                                .toString() ==
                                            Id.UserIdString
                                        ? user!.photoPath!
                                        : AppImage.logo!,
                                    massage: snapshot.data!.docs[index]
                                        ['massage'],
                                    myMassage: snapshot
                                            .data!.docs[index]["senderId"]
                                            .toString() ==
                                        Id.UserIdString,
                                  );
                                }),
                                // Gap(80)
                              ],
                            ),
                          );
                        } else {
                          // log('messooooooooage');
                          return Container();
                        }
                      },
                    ),
                    TextFieldChat(
                      onTap: sendMassage,
                      //  () async {
                      //   massage.add({
                      //     "massage": chatController.text,
                      //     "user_id": await CachData.getData(key: 'id'),
                      //     "image": user!.photoPath,
                      //     "name": user!.firstName,
                      //     "email": user!.email,
                      //     "createAt": DateTime.now(),
                      //     "phone": user!.phoneNumber,
                      //   });
                      //   chatController.clear();
                      //   controller.animateTo(controller.position.minScrollExtent,
                      //       duration: Duration(milliseconds: 500),
                      //       curve: Curves.ease);
                      // },
                      controller: controller,
                      // massage: massage,
                      chatController: chatController,
                      // image: user!.photoPath!,
                      // name: user!.firstName!,
                      // email: user!.email!,
                      // phone: user!.phoneNumber!,
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColor.primaryColor,
                  ),
                );
              }
            },
          )
          // Stack(
          //   children: [
          //     Expanded(
          //       child:
          //     ),
          //     TextFieldChat()
          //   ],
          // )
          ),
    );
  }

  sendMassage() {
    FirebaseFirestore.instance
        .collection(
          "chatDashBoard",
        )
        .doc(Id.UserIdString)
        .collection("massage")
        .add(
      {
        "massage": chatController.text,
        "senderId": Id.UserIdInt,
        "date": DateTime.now().toString(),
      },
    );

    FirebaseFirestore.instance
        .collection("Information")
        .doc(Id.UserIdString)
        .set({
      "massage": chatController.text,
      "userId": Id.UserIdInt,
      "Image": user!.photoPath,
      "name": "${user!.firstName} ${user!.lastName}",
      "date": DateTime.now().toString(),
      "role": "user",
    });
    log.log(chatController.text.toString());

// {
    //   "name": "${user!.firstName} ${user!.lastName}",
    //   "image": user!.photoPath,
    //   "lastMassage": chatController.text,
    //   "date": "${DateTime.now().toUtc().hour}: ${DateTime.now().minute}"
    // }

    chatController.clear();
    // FirebaseFirestore.instance
    //     .collection(
    //       "users",
    //     )
    //     .doc("receiverId")
    //     .collection("chat")
    //     .doc("My Id")
    //     .collection("massage")
    //     .add(
    //   {
    //     "massage": chatController.text,
    //     "senderId": 1,
    //     "receiverId": 'receiverId',
    //     "image": "user!.photoPath",
    //     "name": "user!.firstName",
    //     "email": "user!.email",
    //     "date": DateTime.now().toString(),
    //     "phone": "user!.phoneNumber",
    //   },
    // );
  }
}

class ChatContent extends StatelessWidget {
  const ChatContent(
      {super.key,
      required this.image,
      required this.massage,
      required this.myMassage,
      required this.isSeen,
      required this.type,
      this.adminMassage = false});
  final String image;
  final String massage;
  final bool myMassage;
  final bool isSeen;
  final bool adminMassage;
  final String type;
  @override
  Widget build(BuildContext context) {
    // log(myMassage.toString());
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerRight,
      child: SingleChildScrollView(
        child: massageType(),
        // myMassage
        //     ? type == "text"
        //         ? TextMassage(isSeen: isSeen, massage: massage, image: image)
        //         : VideoMassage(
        //             image: image,
        //             url: massage,
        //             isSeen: isSeen,
        //           )
        //     : Row(
        //         crossAxisAlignment: CrossAxisAlignment.end,
        //         children: [
        //           Container(
        //             margin: EdgeInsets.only(bottom: 10),
        //             child: CircleAvatar(
        //               backgroundImage: NetworkImage(image),
        //             ),
        //           ),
        //           Expanded(
        //             child: Align(
        //               alignment: Alignment.centerLeft,
        //               child: Container(
        //                 // height: 200,
        //                 padding: EdgeInsets.symmetric(
        //                   vertical: 10,
        //                   horizontal: 10,
        //                 ),
        //                 margin:
        //                     EdgeInsets.only(left: 15, bottom: 30, right: 10),
        //                 // width: MediaQuery.of(context).size.width*0.55,
        //                 decoration: BoxDecoration(
        //                     color: myMassage
        //                         ? AppColor.primaryColor
        //                         : Colors.grey[300],
        //                     borderRadius: BorderRadius.only(
        //                         topLeft: Radius.circular(30),
        //                         topRight: Radius.circular(30),
        //                         bottomRight: Radius.circular(30),
        //                         bottomLeft: Radius.circular(0))),
        //                 child: Text(
        //                   massage,
        //                   style: TextStyle(
        //                       color: myMassage ? Colors.white : Colors.black),
        //                 ),
        //               ),
        //             ),
        //           ),
        //         ],
        //       )
      ),
    );
  }

  massageType() {
    if (type == "text") {
      return TextMassage(
        adminMassage: adminMassage,
        isSeen: isSeen,
        massage: massage,
        image: image,
        myMassage: myMassage,
      );
    } else if (type == "video") {
      return VideoMassage(
        myMassage: myMassage,
        image: image,
        url: massage,
        isSeen: isSeen,
      );
    } else if (type == "image") {
      return ImageMassage(
        myMassage: myMassage,
        isSeen: isSeen,
        image: image,
        massage: massage,
      );
    } else if (type == "sound") {
      return AudioMassage(
          isSeen: isSeen, massage: massage, image: image, myMassage: myMassage);
    }
  }
}

class TextFieldChat extends StatefulWidget {
  TextFieldChat({
    super.key,
    this.onTapMedia,
    required this.chatController,
    // required this.image,
    // required this.name,
    // required this.email,
    // required this.phone,
    this.isThereMedia = false,
    // required this.massage,
    required this.controller,
    this.onTap,
    this.prefixIcon,
  });
  final bool isThereMedia;

  TextEditingController chatController;
  // final String image;
  // final String name;
  // final String email;
  // final String phone;
  // final CollectionReference massage;
  final ScrollController controller;
  final void Function()? onTap;
  final void Function()? onTapMedia;
  final Widget? prefixIcon;
  @override
  State<TextFieldChat> createState() => _TextFieldChatState();
}

class _TextFieldChatState extends State<TextFieldChat> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        height: 65,
        padding: EdgeInsets.symmetric(horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.90,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Color(0xff00569F).withOpacity(0.13), blurRadius: 10)
            ],
            borderRadius: BorderRadius.circular(30)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: SizedBox(
                // width: 200,
                child: TextField(
                  controller: widget.chatController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write your message".tr(),
                    hintStyle: TextStyle(
                      color: Color(0xFFA1A1A1),
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: widget.prefixIcon,
                  ),
                ),
              ),
            ),
            Flexible(
              flex: 1,
              child: Row(
                children: [
                  // SvgPicture.asset(AppImage.emoji),
                  // Gap(5),
                  IconButton(
                      onPressed: widget.onTapMedia,
                      icon: Icon(
                        Icons.attach_file,
                        color: Color(0xffB4D9E8),
                      )),
                  // Gap(5),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: SvgPicture.asset(AppImage.sendIcon),
                  ),
                  // Gap(3)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TextMassage extends StatelessWidget {
  const TextMassage(
      {super.key,
      required this.isSeen,
      required this.massage,
      required this.image,
      required this.myMassage,
      this.adminMassage = false});
  final bool isSeen;
  final String massage;
  final String image;
  final bool myMassage;
  final bool adminMassage;
  @override
  Widget build(BuildContext context) {
    return myMassage
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      // height: 200,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      margin: EdgeInsets.only(left: 15, bottom: 30, right: 10),
                      // width: MediaQuery.of(context).size.width*0.55,
                      decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(30))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              massage,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Gap(5),
                          Icon(
                            isSeen ? Icons.done_all : Icons.done,
                            color: Colors.white,
                            size: 15,
                          )
                        ],
                      )),
                ),
              ),
              CustomCachedNetworkImage(
                placeholder: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                ),
              ),
            imageUrl: image,
            imageBuilder: (context, imageProvider) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundImage: imageProvider,
                ),
              );
            },
          ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: CircleAvatar(
              //     backgroundImage: NetworkImage(image),
              //   ),
              // ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 10),
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    // color: Colors.red,
                    shape: BoxShape.circle),
                child: ClipRRect(
                  child: adminMassage
                      ? SvgPicture.asset(image)
                      : 
                      CustomCachedNetworkImage(
                        placeholder: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
              ),
            imageUrl: image,
            imageBuilder: (context, imageProvider) {
              return Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fill,
                  ),
                ),
              );
            },
          ),
          //  Image.network(image),
                ),
                // child: CircleAvatar(
                //   backgroundImage: ,
                // ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      // height: 200,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      margin: EdgeInsets.only(left: 15, bottom: 30, right: 10),
                      // width: MediaQuery.of(context).size.width*0.55,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(0))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Text(
                              massage,
                              style: TextStyle(color: Color(0xff505050)),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          );
  }
}

class VideoMassage extends StatefulWidget {
  const VideoMassage(
      {super.key,
      required this.image,
      required this.url,
      required this.isSeen,
      required this.myMassage});
  final String image;
  final String url;
  final bool isSeen;
  final bool myMassage;
  @override
  State<VideoMassage> createState() => _VideoMassageState();
}

class _VideoMassageState extends State<VideoMassage> {
  late VideoPlayerController _controller;
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        _chewieController = ChewieController(
          allowFullScreen: true,
          showOptions: true,
          autoInitialize: true,
          videoPlayerController: _controller,
          aspectRatio: _controller.value.aspectRatio,
          autoPlay: true, // Optionally set to auto-play
          looping: true, // Optionally set to loop the video
          // Add the following line to make Chewie fill the available space
          // autoResize: true,
          // Add the following line to make Chewie fill the available space
          // fit: BoxFit.contain,
        );
        setState(() {});
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
    _chewieController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.myMassage
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      // height: 200,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      margin: EdgeInsets.only(left: 15, bottom: 30, right: 10),
                      // width: MediaQuery.of(context).size.width*0.55,
                      decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(30))),
                      child: Stack(
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _controller.value.isInitialized
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: AspectRatio(
                                    aspectRatio: _chewieController.aspectRatio!,
                                    child: Chewie(
                                      controller: _chewieController,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                          Gap(5),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Icon(
                              widget.isSeen ? Icons.done_all : Icons.done,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              CustomCachedNetworkImage(
                placeholder: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                ),
              ),
            imageUrl: widget.image,
            imageBuilder: (context, imageProvider) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundImage: imageProvider,
                ),
              );
            },
          ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: CircleAvatar(
              //     backgroundImage: NetworkImage(widget.image),
              //   ),
              // ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomCachedNetworkImage(
                placeholder: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                ),
              ),
            imageUrl: widget.image,
            imageBuilder: (context, imageProvider) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundImage: imageProvider,
                ),
              );
            },
          ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: CircleAvatar(
              //     backgroundImage: NetworkImage(widget.image),
              //   ),
              // ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      // height: 200,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      margin: EdgeInsets.only(left: 15, bottom: 30, right: 10),
                      // width: MediaQuery.of(context).size.width*0.55,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(0))),
                      child: Stack(
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _controller.value.isInitialized
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: AspectRatio(
                                    aspectRatio: _chewieController.aspectRatio!,
                                    child: Chewie(
                                      controller: _chewieController,
                                    ),
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),
                          Gap(5),
                          // Positioned(
                          //   bottom: 5,
                          //   right: 5,
                          //   child: Icon(
                          //     widget.isSeen ? Icons.done_all : Icons.done,
                          //     color: Colors.white,
                          //     size: 15,
                          //   ),
                          // ),
                        ],
                      )),
                ),
              ),
            ],
          );
  }
}

class ImageMassage extends StatelessWidget {
  const ImageMassage(
      {super.key,
      required this.image,
      required this.massage,
      required this.isSeen,
      required this.myMassage});
  final String image;
  final String massage;
  final bool isSeen;
  final bool myMassage;
  @override
  Widget build(BuildContext context) {
    return myMassage
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                      // height: 200,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      margin: EdgeInsets.only(left: 15, bottom: 30, right: 10),
                      // width: MediaQuery.of(context).size.width*0.55,
                      decoration: BoxDecoration(
                          color: AppColor.primaryColor,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(0),
                              bottomLeft: Radius.circular(30))),
                      child: Stack(
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: 5,
                            child: CustomCachedNetworkImage(
                              placeholder: Container(
                              height: 300,
                              width: 280,
                              decoration: BoxDecoration(
                                  color: AppColor.blue500,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                            ),
            imageUrl: massage,
            imageBuilder: (context, imageProvider) {
              return Container(
                              height: 300,
                              width: 280,
                              decoration: BoxDecoration(
                                  color: AppColor.blue500,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover)),
                            );
            },
          ),
                            // Container(
                            //   height: 300,
                            //   width: 280,
                            //   decoration: BoxDecoration(
                            //       color: AppColor.blue500,
                            //       borderRadius: BorderRadius.circular(20),
                            //       image: DecorationImage(
                            //           image: NetworkImage(massage),
                            //           fit: BoxFit.cover)),
                            // ),
                          ),
                          Gap(5),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: Icon(
                              isSeen ? Icons.done_all : Icons.done,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ],
                      )),
                ),
              ),
              CustomCachedNetworkImage(
                placeholder: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                ),
              ),
            imageUrl: image,
            imageBuilder: (context, imageProvider) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundImage: imageProvider,
                ),
              );
            },
          ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: CircleAvatar(
              //     backgroundImage: NetworkImage(image),
              //   ),
              // ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomCachedNetworkImage(
                placeholder: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                ),
              ),
            imageUrl: image,
            imageBuilder: (context, imageProvider) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
                child: CircleAvatar(
                  backgroundImage: imageProvider,
                ),
              );
            },
          ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 10),
              //   child: CircleAvatar(
              //     backgroundImage: NetworkImage(image),
              //   ),
              // ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                      // height: 200,
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      margin: EdgeInsets.only(left: 15, bottom: 30, right: 10),
                      // width: MediaQuery.of(context).size.width*0.55,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                              bottomLeft: Radius.circular(0))),
                      child: Stack(
                        // mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            flex: 5,
                            child: CustomCachedNetworkImage(
                              placeholder: Container(
                              height: 300,
                              width: 280,
                              decoration: BoxDecoration(
                                  color: AppColor.blue500,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                            ),
            imageUrl: image,
            imageBuilder: (context, imageProvider) {
              return Container(
                              height: 300,
                              width: 280,
                              decoration: BoxDecoration(
                                  color: AppColor.blue500,
                                  borderRadius: BorderRadius.circular(20),
                                  image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover)),
                            );
            },
          ),
                            // Container(
                            //   height: 300,
                            //   width: 280,
                            //   decoration: BoxDecoration(
                            //       color: AppColor.blue500,
                            //       borderRadius: BorderRadius.circular(20),
                            //       image: DecorationImage(
                            //           image: NetworkImage(massage),
                            //           fit: BoxFit.cover)),
                            // ),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          );
  }
}

class AudioMassage extends StatefulWidget {
  const AudioMassage(
      {super.key,
      required this.isSeen,
      required this.massage,
      required this.image,
      required this.myMassage});
  final bool isSeen;
  final String massage;
  final String image;
  final bool myMassage;

  @override
  State<AudioMassage> createState() => _AudioMassageState();
}

class _AudioMassageState extends State<AudioMassage> {
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // تهيئة مشغل الصوت هنا
    _initAudioPlayer();
  }

  AudioPlayer _audioPlayer = AudioPlayer();

  Duration _duration = Duration();

  Duration _position = Duration();

  bool _isPlaying = false;

  void _initAudioPlayer() {
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _playPause() {
    // log(_isPlaying.toString());
    if (_isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(widget.massage));
    }
  }

  // RecorderController controller = RecorderController();
  @override
  Widget build(BuildContext context) {
    return widget.myMassage
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Flexible(
                      //   flex: 5,
                      //   child: Container(
                      //     height: 30,
                      //     width: 280,
                      //     decoration: BoxDecoration(
                      //         color: AppColor.blue500,
                      //         borderRadius: BorderRadius.circular(20),
                      //                               )
                      //        ),
                      // ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: BubbleNormalAudio(
                          color: AppColor.blue500,
                          duration: _duration.inSeconds.toDouble(),
                          position: min(_position.inSeconds.toDouble(),
                              _duration.inSeconds.toDouble()),
                          isPlaying: _isPlaying,
                          isLoading: false,
                          onSeekChanged: (value) {
                            // log(value.toString());
                          },
                          onPlayPauseButtonClick: _playPause,
                        ),
                      ),

                      Gap(5),
                      Positioned(
                        bottom: 15,
                        right: 20,
                        child: Icon(
                          widget.isSeen ? Icons.done_all : Icons.done,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              CustomCachedNetworkImage(
                placeholder: Container(
                margin: EdgeInsets.only(bottom: 2),
                child: CircleAvatar(
                ),
              ),
            imageUrl: widget.image,
            imageBuilder: (context, imageProvider) {
              return Container(
                margin: EdgeInsets.only(bottom: 2),
                child: CircleAvatar(
                  backgroundImage: imageProvider,
                ),
              );
            },
          ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 2),
              //   child: CircleAvatar(
              //     backgroundImage: NetworkImage(widget.image),
              //   ),
              // ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomCachedNetworkImage(
                placeholder: Container(
                margin: EdgeInsets.only(bottom: 0),
                child: CircleAvatar(
                ),
              ),
            imageUrl: widget.image,
            imageBuilder: (context, imageProvider) {
              return Container(
                margin: EdgeInsets.only(bottom: 0),
                child: CircleAvatar(
                  backgroundImage: imageProvider,
                ),
              );
            },
          ),
              // Container(
              //   margin: EdgeInsets.only(bottom: 0),
              //   child: CircleAvatar(
              //     backgroundImage: NetworkImage(widget.image),
              //   ),
              // ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Stack(
                    // mainAxisSize: MainAxisSize.min,
                    // crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Flexible(
                      //   flex: 5,
                      //   child: Container(
                      //     height: 30,
                      //     width: 280,
                      //     decoration: BoxDecoration(
                      //         color: AppColor.blue500,
                      //         borderRadius: BorderRadius.circular(20),
                      //                               )
                      //        ),
                      // ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        child: BubbleNormalAudio(
                          color: Colors.grey[300]!,
                          duration: _duration.inSeconds.toDouble(),
                          position: min(_position.inSeconds.toDouble(),
                              _duration.inSeconds.toDouble()),
                          isPlaying: _isPlaying,
                          isLoading: false,
                          isSender: false,
                          onSeekChanged: (value) {
                            // log(value.toString());
                          },
                          onPlayPauseButtonClick: _playPause,
                          // seen: widget.isSeen,
                        ),
                      ),

                      // Gap(5),
                      // Positioned(
                      //   bottom: 15,
                      //   right: 20,
                      //   child: Icon(
                      //     widget.isSeen ? Icons.done_all : Icons.done,
                      //     color: Colors.white,
                      //     size: 15,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }
}
