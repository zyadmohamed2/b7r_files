import 'dart:async';
import 'package:ba7r/Core/function/log.dart';
import 'dart:io';
// import 'dart:io';
import 'dart:ui' as ui;

import 'package:ba7r/Core/service/CachData.dart';
import 'package:ba7r/Core/utils/colors.dart';
import 'package:ba7r/Core/utils/images.dart';
import 'package:ba7r/Core/utils/routes.dart';
import 'package:ba7r/Core/utils/text_style.dart';
import 'package:ba7r/Features/view/BusinessAccount/presentation/widget/more_card.dart';
import 'package:ba7r/Features/view/ProfileSession/data/model/user_information_model.dart';
import 'package:ba7r/Features/view/chat/presentation/screen/chat_screen.dart';
import 'package:ba7r/Features/view/chatProduct/presentation/screen/business_chat.dart';
import 'package:ba7r/Features/view_model/profile/profile_bloc.dart';
import 'package:ba7r/id.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class ImportantChatScreen extends StatefulWidget {
  const ImportantChatScreen({super.key});

  @override
  State<ImportantChatScreen> createState() => _ImportantChatScreenState();
}

class _ImportantChatScreenState extends State<ImportantChatScreen> {
  TextEditingController chatController = TextEditingController();

  ScrollController controller = ScrollController();

  CollectionReference? massage;

  CollectionReference? online;

  int? myId;

  bool isLoding = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  bool idRecord = false;

  double secondsElapsed = 0.0;

  late Timer? timer;

  final record = AudioRecorder();

  bool isUnread = false;

  //   "ChatProduct",
  @override
  initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetUserInformation());
    myId = Id.BusinessAccountInt;
    // await CachData.getData(key: "id");
    massage = FirebaseFirestore.instance
        .collection("chatDashBoardCustomer")
        .doc(Id.BusinessAccountString)
        .collection("massage");
  }

  // SignalRHelper signalR = new SignalRHelper();
  String? lastMassage;

  String? time;

  String? userImage;

  // bool? isSeent;

  bool? isYouBlock;

  @override
  void dispose() {
    // FirebaseFirestore.instance.collection("ChatProduct").doc("MessageList").collection("3").add({"massage": lastMassage, "imageUser": userImage, "time": time, "isSeen": isSeent, "name": "zyad", "productId": widget.productId, "productName": widget.productTitle, "productPrice": widget.productPrice, "productImage": widget.productImage},);
    timer!.cancel();
    super.dispose();
  }

  UserInformationModel? userModel;

  @override
  Widget build(BuildContext context) {
    // log("online!.get().toString() ${online!.get().toString()}");
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        body: Directionality(
          textDirection: ui.TextDirection.ltr,
          child: BlocConsumer<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is SuccessGetProfileInformation) {
                userModel = state.userInformationModel;
              }
            },
            builder: (context, state) {
              if (userModel != null) {
                return Stack(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                      stream: massage!
                          .orderBy("date", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        // log(snapshot.data!.docs.toString());
                        if (snapshot.hasData &&
                            snapshot.data!.docs.isNotEmpty) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 80, top: 200),
                            child: ListView(
                              reverse: true,
                              controller: controller,
                              children: [
                                ...List.generate(snapshot.data!.docs.length,
                                    (index) {
                                  // log(widget.productId.toString());
                                  // log(widget.userId.toString());
                                  // log("snapshot.data!.docs.last['massage'] ${snapshot.data!.docs.['massage']}");
                                  // if (!isUnread) {
                                  //   FirebaseFirestore.instance
                                  //       .collection("ChatProduct")
                                  //       .doc("MessageList")
                                  //       .collection(Id.BusinessAccountString)
                                  //       .doc(widget.massageId)
                                  //       .update({
                                  //     "massage":
                                  //         snapshot.data!.docs.first['massage'],
                                  //     "imageUser":
                                  //         snapshot.data!.docs.first['imageUser'],
                                  //     "time": snapshot.data!.docs.first['date'],
                                  //     "isSeen": true,
                                  //     "name": widget.userName,
                                  //     "unread": false,
                                  //   });
                                  // }
                                  // FirebaseFirestore
                                  //   .instance
                                  // .collection("ChatProduct")
                                  // .doc("MessageList")
                                  // .collection(Id.BusinessAccountString).doc(widget.massageId).update({"unread": false},);
                                  // log(snapshot.data!.docs[index].id);
                                  // if (!snapshot.data!.docs[index]['isSeen'] &&
                                  //     snapshot.data!.docs[index]['receiverId'] ==
                                  //         Id.UserIdInt) {
                                  //   FirebaseFirestore.instance
                                  //       .collection("ChatProduct")
                                  //       .doc("users")
                                  //       .collection("chat")
                                  //       .doc(widget.userId.toString())
                                  //       .collection("products")
                                  //       .doc(widget.productId.toString())
                                  //       .collection("massage")
                                  //       .doc(snapshot.data!.docs[index].id)
                                  //       .update({"isSeen": true});
                                  // }
                                  // isSeent = snapshot.data!.docs.last['isSeen'];
                                  // lastMassage =
                                  //     snapshot.data!.docs.last['massage'];
                                  // userImage = snapshot.data!.docs.last['image'];
                                  // time = snapshot.data!.docs.last['date'];
                                  return GestureDetector(
                                      child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: TextMassage(
                                          isSeen: false,
                                          massage: snapshot.data!.docs[index]
                                              ['massage'],
                                          image: snapshot.data!.docs[index]
                                                      ['senderId'] !=
                                                  'admin'
                                              ? userModel!.photoPath!
                                              : AppImage.logo,
                                          adminMassage: true,
                                          myMassage: snapshot.data!.docs[index]
                                                  ['senderId'] !=
                                              'admin',
                                        ),
                                      ),
                                      // snapshot.data!.docs[index]['isWarning']
                                      // ? Align(
                                      //     child: Container(
                                      //       margin: EdgeInsets.symmetric(
                                      //           horizontal: 20),
                                      //       width: double.infinity,
                                      //       padding: EdgeInsets.all(20),
                                      //       height: 100,
                                      //       decoration: BoxDecoration(
                                      //           borderRadius:
                                      //               BorderRadius.circular(
                                      //                   15),
                                      //           color:
                                      //               Colors.red.shade50),
                                      //       child: Center(
                                      //         child: Row(
                                      //           crossAxisAlignment:
                                      //               CrossAxisAlignment
                                      //                   .start,
                                      //           children: [
                                      //             Icon(
                                      //               Icons.error_outline,
                                      //               color: Colors.red,
                                      //             ),
                                      //             Gap(8),
                                      //             Flexible(
                                      //               child: Text.rich(
                                      //                 TextSpan(
                                      //                   children: [
                                      //                     TextSpan(
                                      //                       text:
                                      //                           "Offensive chat warning\n"
                                      //                               .tr(),
                                      //                       style:
                                      //                           TextStyle(
                                      //                         color: Color(
                                      //                             0xFFFF3A51),
                                      //                         fontSize:
                                      //                             11,
                                      //                         fontFamily:
                                      //                             'Poppins',
                                      //                         fontWeight:
                                      //                             FontWeight
                                      //                                 .w500,
                                      //                       ),
                                      //                     ),
                                      //                     TextSpan(
                                      //                       text:
                                      //                           "B7R policy prohibits hateful conduct (any profanation, racial slurs and hate speech). any further activities will result in strict action applied to your account."
                                      //                               .tr(),
                                      //                       style:
                                      //                           TextStyle(
                                      //                         color: Color(
                                      //                             0xFFFF3A51),
                                      //                         fontSize: 9,
                                      //                         fontFamily:
                                      //                             'Poppins',
                                      //                         fontWeight:
                                      //                             FontWeight
                                      //                                 .w400,
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   )
                                      // : SizedBox(),
                                      Gap(20)
                                    ],
                                  ));
                                }),
                                // Gap(80)
                              ],
                            ),
                          );
                        } else {
                          log('messooooooooage');
                          return Container();
                        }
                      },
                    ),
                    TextFieldChat(
                        controller: controller,
                        chatController: chatController,
                        isThereMedia: false,
                        onTap: sendMassage),
                    Align(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              color: Colors.white,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          context.pop();
                                        },
                                        icon: Icon(
                                          Icons.arrow_back_ios_outlined,
                                          color: AppColor.blue500,
                                        ),
                                      ),
                                      Gap(15),
                                      Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: SvgPicture.asset(AppImage.logo),
                                      ),
                                      Gap(20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "BA7R",
                                            style: style18.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.blue500),
                                          ),
                                          // Gap(5),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: Column(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 2,
                                  decoration:
                                      BoxDecoration(color: Color(0x110E85B6)),
                                ),
                                Gap(11),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColor.blue500,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }

  sendMassage() {
    FirebaseFirestore.instance
        .collection(
          "chatDashBoardCustomer",
        )
        .doc(Id.BusinessAccountString)
        .collection("massage")
        .add(
      {
        "massage": chatController.text,
        "senderId": Id.UserIdInt,
        "date": DateTime.now().toString(),
      },
    );

    // FirebaseFirestore.instance
    //     .collection("Information")
    //     .doc(Id.UserIdString)
    //     .set({
    //   "massage": chatController.text,
    //   "userId": Id.UserIdInt,
    //   "Image": user!.photoPath,
    //   "name": "${user!.firstName} ${user!.lastName}",
    //   "date": DateTime.now().toString(),
    //   "role": "user",
    // });
    // log.log(chatController.text.toString());

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
