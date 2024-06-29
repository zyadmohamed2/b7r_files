import 'dart:async';
import 'package:ba7r/Core/function/log.dart';
import 'dart:io';
import 'dart:ui';
// import 'dart:io';

import 'package:ba7r/Core/service/CachData.dart';
import 'package:ba7r/Core/service/notification_service.dart';
import 'package:ba7r/Core/utils/colors.dart';
import 'package:ba7r/Core/utils/images.dart';
import 'package:ba7r/Core/utils/routes.dart';
import 'package:ba7r/Core/utils/text_style.dart';
import 'package:ba7r/Core/widgets/custom_cached_network_image.dart';
import 'package:ba7r/Features/view/BusinessAccount/presentation/screen/home/ads/data/model/product_model.dart';
import 'package:ba7r/Features/view/BusinessAccount/presentation/widget/more_card.dart';
import 'package:ba7r/Features/view/ProfileSession/data/model/user_information_model.dart';
import 'package:ba7r/Features/view/chat/presentation/screen/chat_screen.dart';
import 'package:ba7r/Features/view_model/profile/profile_bloc.dart';
import 'package:ba7r/id.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
// import 'package:http/io_client.dart';
// import 'package:signalr_core/signalr_core.dart';
// import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:ui' as ui;

class ChatProductScreen extends StatefulWidget {
  ChatProductScreen({
    super.key,
    required this.productId,
    required this.productModel,
  });
  final String productId;
  final AdsBusinessModel productModel;
  @override
  State<ChatProductScreen> createState() => _ChatProductScreenState();
}

class _ChatProductScreenState extends State<ChatProductScreen> {
  TextEditingController chatController = TextEditingController();

  ScrollController controller = ScrollController();

  CollectionReference? massage;
  CollectionReference? online;
  int? myId;
  bool isLoding = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool idRecord = false;
  double secondsElapsed = 0.0;
  final record = AudioRecorder();
  bool? isYouBlock;
  UserInformationModel? userModel;
  @override
  initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetUserInformation());
    myId = Id.UserIdInt;
    // await CachData.getData(key: "id");
    log("widget.productId.toString() ${widget.productId.toString()}");
    massage = FirebaseFirestore.instance
        .collection("ChatProduct")
        .doc("users")
        .collection("chat")
        .doc(myId.toString())
        .collection("products")
        .doc(widget.productId)
        .collection("massage");
    online = FirebaseFirestore.instance
        .collection("users")
        .doc("online")
        .collection(widget.productModel.userId.toString());

    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   FirebaseFirestore.instance
    //       .collection("ChatProduct")
    //       .doc("users")
    //       .collection("chat")
    //       .doc(myId.toString())
    //       .collection("products")
    //       .doc(widget.productId)
    //       .get()
    //       .then((DocumentSnapshot<Map<String, dynamic>> snapshot) {
    //     // تحديد نوع البيانات المتوقعة
    //     if (snapshot.exists) {
    //       log("Blockkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    //       setState(() {
    //         isBlock = snapshot.data()?['block'] == Id.UserIdString
    //             ? "You Block"
    //             : "You Blocked";
    //         log(isBlock!);
    //       });
    //     } else {
    //       log("No Blockkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk");
    //       isBlock = "No Block";
    //     }
    //   });
    // });
    // log(isBlock.toString());
  }
  // SignalRHelper signalR = new SignalRHelper();

  // receiveMessageHandler(args) {
  //   signalR.messageList.add(Message(
  //       name: args[0], message: args[1], isMine: args[0] == "1"));
  //   // scrollController.jumpTo(scrollController.position.maxScrollExtent + 75);
  //   setState(() {});
  // }
  // String? lastMassage;
  // // String? time;
  // String? userImage;
  // bool? isSeent;
  // int? senderId;

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
                                ...List.generate(
                                  snapshot.data!.docs.length,
                                  (index) {
                                    FirebaseFirestore.instance
                                        .collection("ChatProduct")
                                        .doc("MessageList")
                                        .collection(widget
                                            .productModel.businessAccountId
                                            .toString())
                                        .where("productId",
                                            isEqualTo: widget.productId)
                                        // .where("productName",
                                        //     isEqualTo: widget.productModel.title)
                                        // .where("productPrice",
                                        //     isEqualTo: widget.productModel.price)
                                        // .where("productImage",
                                        //     isEqualTo:
                                        //         widget.productModel.images!.first)
                                        .where("userId",
                                            isEqualTo: Id.UserIdInt)
                                        .get()
                                        .then((querySnapshot) {
                                      if (querySnapshot.docs.isNotEmpty) {
                                        // إذا تم العثور على وثيقة تطابق الشروط، قم بتحديثها
                                        FirebaseFirestore.instance
                                            .collection("ChatProduct")
                                            .doc("MessageList")
                                            .collection(widget
                                                .productModel.businessAccountId
                                                .toString())
                                            .doc(querySnapshot.docs[0]
                                                .id) // استخرج معرّف الوثيقة
                                            .update({
                                          "massage": snapshot
                                              .data!.docs.first['massage'],
                                          "time":
                                              snapshot.data!.docs.first['date'],
                                          "isSeen": snapshot
                                              .data!.docs.first['isSeen'],
                                          "unread": true,
                                        });
                                      } else {
                                        // إذا لم يتم العثور على وثيقة تطابق الشروط، قم بإنشاء وثيقة جديدة
                                        FirebaseFirestore.instance
                                            .collection("ChatProduct")
                                            .doc("MessageList")
                                            .collection(widget
                                                .productModel.businessAccountId
                                                .toString())
                                            .add({
                                          "massage": snapshot
                                              .data!.docs.first['massage'],
                                          "imageUser": snapshot
                                              .data!.docs.first['image'],
                                          "time":
                                              snapshot.data!.docs.first['date'],
                                          "isSeen": snapshot
                                              .data!.docs.first['isSeen'],
                                          "name":
                                              "${userModel!.firstName} ${userModel!.lastName}",
                                          "productId": widget.productId,
                                          "productName":
                                              widget.productModel.title,
                                          "productPrice":
                                              widget.productModel.price,
                                          "productImage":
                                              widget.productModel.images!.first,
                                          "userId": Id.UserIdInt,
                                          "unread": true,
                                          "senderId": snapshot
                                              .data!.docs.first['senderId']
                                        });
                                      }
                                    });

                                    if (!snapshot.data!.docs[index]['isSeen'] &&
                                        snapshot.data!.docs[index]
                                                ['receiverId'] ==
                                            myId) {
                                      FirebaseFirestore.instance
                                          .collection("ChatProduct")
                                          .doc("users")
                                          .collection("chat")
                                          .doc(myId.toString())
                                          .collection("products")
                                          .doc(widget.productId)
                                          .collection("massage")
                                          .doc(snapshot.data!.docs[index].id)
                                          .update({"isSeen": true});
                                    }

                                    return GestureDetector(
                                        onLongPress: () {
                                          showModalBottomSheet(
                                            isScrollControlled: true,
                                            context: context,
                                            backgroundColor: Colors.white,
                                            builder: (context) {
                                              return Container(
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 16,
                                                    horizontal: 20),
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(20),
                                                      topRight:
                                                          Radius.circular(20),
                                                    ),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.black12,
                                                          blurRadius: 1000)
                                                    ]),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 5,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              AppColor.blue200,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      50)),
                                                    ),
                                                    Gap(30),
                                                    Image.asset(
                                                      AppImage.deletAccount,
                                                      width: 122,
                                                      height: 122,
                                                    ),
                                                    Gap(16),
                                                    Text(
                                                      "Delete Massage".tr(),
                                                      style: style24.copyWith(
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    Gap(6),
                                                    Text(
                                                      "Are you sure you want to delete This message?"
                                                          .tr(),
                                                      style: style18.copyWith(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xA32C2C2C),
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                    Gap(50),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        MoreCard(
                                                            text: "Cancel".tr(),
                                                            color: AppColor
                                                                .blue100,
                                                            textColor: AppColor
                                                                .blue500),
                                                        MoreCard(
                                                          onTap: () {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "ChatProduct")
                                                                .doc("users")
                                                                .collection(
                                                                    "chat")
                                                                .doc(myId
                                                                    .toString())
                                                                .collection(
                                                                    "products")
                                                                .doc(widget
                                                                    .productId)
                                                                .collection(
                                                                    "massage")
                                                                .doc(snapshot
                                                                    .data!
                                                                    .docs[index]
                                                                    .id)
                                                                .delete();
                                                            context.pop();
                                                          },
                                                          text: "Delete".tr(),
                                                          color: Colors.red
                                                              .withOpacity(
                                                                  0.20),
                                                          textColor: Colors.red,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            ChatContent(
                                              type: snapshot.data!.docs[index]
                                                  ['type'],
                                              isSeen: snapshot.data!.docs[index]
                                                  ['isSeen'],
                                              image: snapshot.data!.docs[index]
                                                  ['image'],
                                              massage: snapshot
                                                  .data!.docs[index]['massage'],
                                              myMassage:
                                                  snapshot.data!.docs[index]
                                                          ["senderId"] ==
                                                      myId,
                                            ),
                                            snapshot.data!.docs[index]
                                                    ['isWarning']
                                                ? Align(
                                                    child: Container(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 20),
                                                      width: double.infinity,
                                                      padding:
                                                          EdgeInsets.all(20),
                                                      height: 100,
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          color: Colors
                                                              .red.shade50),
                                                      child: Center(
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .error_outline,
                                                              color: Colors.red,
                                                            ),
                                                            Gap(8),
                                                            Flexible(
                                                              child: Text.rich(
                                                                TextSpan(
                                                                  children: [
                                                                    TextSpan(
                                                                      text: "Offensive chat warning\n"
                                                                          .tr(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFFFF3A51),
                                                                        fontSize:
                                                                            11,
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                    TextSpan(
                                                                      text: "B7R policy prohibits hateful conduct (any profanation, racial slurs and hate speech). any further activities will result in strict action applied to your account."
                                                                          .tr(),
                                                                      style:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xFFFF3A51),
                                                                        fontSize:
                                                                            9,
                                                                        fontFamily:
                                                                            'Poppins',
                                                                        fontWeight:
                                                                            FontWeight.w400,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Gap(20)
                                          ],
                                        ));
                                  },
                                ),

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
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: FirebaseFirestore.instance
                          .collection("ChatProduct")
                          .doc("users")
                          .collection("chat")
                          .doc(Id.UserIdString)
                          .collection("products")
                          .doc(widget.productId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData && !snapshot.data!.exists) {
                          // Handle case where snapshot has data but document does not exist
                          isYouBlock = false;
                          return ChatTextField(
                            userId: widget.productModel.userId!,
                            productModel: widget.productModel,
                            userModel: userModel!,
                            chatController: chatController,
                            scaffoldKey: scaffoldKey,
                            productId: widget.productId,
                          );
                        } else if (snapshot.hasData && snapshot.data!.exists) {
                          final data = snapshot.data!.data();
                          if (data != null) {
                            if (data["first block"] == "No Block" ||
                                data["second"] == "No Block") {
                              isYouBlock = false;
                              return ChatTextField(
                                userId: widget.productModel.userId!,
                                productModel: widget.productModel,
                                userModel: userModel!,
                                chatController: chatController,
                                scaffoldKey: scaffoldKey,
                                productId: widget.productId,
                              );
                            } else if (data["first block"] == Id.UserIdString) {
                              isYouBlock = true;
                              return Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 30),
                                  child: Text(
                                    "You have blocked this user".tr(),
                                    style: style20.copyWith(color: Colors.grey),
                                  ),
                                ),
                              );
                            } else if (data["second"] == Id.UserIdString) {
                              isYouBlock = true;
                              return ChatTextField(
                                userId: widget.productModel.userId!,
                                userModel: userModel!,
                                productModel: widget.productModel,
                                chatController: chatController,
                                scaffoldKey: scaffoldKey,
                                productId: widget.productId,
                              );
                            }
                          }
                        }

                        // Default case: return a message indicating an error or loading state
                        return CircularProgressIndicator(); // You can replace this with an appropriate widget
                      },
                    ),
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
                                      CustomCachedNetworkImage(
                                        placeholder: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                      ),
                                        imageUrl: widget
                                                    .productModel
                                                    .businessAccountImage!,
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover)),
                                      );
                                        },
                                      ),
                                      // Container(
                                      //   width: 50,
                                      //   height: 50,
                                      //   decoration: BoxDecoration(
                                      //       shape: BoxShape.circle,
                                      //       image: DecorationImage(
                                      //           image: NetworkImage(widget
                                      //               .productModel
                                      //               .businessAccountImage!),
                                      //           fit: BoxFit.cover)),
                                      // ),
                                      Gap(20),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.productModel
                                                .businessAccountName!,
                                            style: style18.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: AppColor.blue500),
                                          ),
                                          // Gap(5),
                                          StreamBuilder<QuerySnapshot>(
                                            stream: online!.snapshots(),
                                            builder: (context, snapshot) {
                                              // if (snapshot.connectionState ==
                                              // ConnectionState.waiting) {
                                              // return CircularProgressIndicator();
                                              // }
                                              if (snapshot.hasError) {
                                                return Text(
                                                    'Error: ${snapshot.error}');
                                              } else {
                                                final data =
                                                    snapshot.data?.docs;
                                                if (data != null &&
                                                    data.isNotEmpty) {
                                                  final isOnline = data.first
                                                      .get("isOnline");
                                                  // استخدم isOnline كما تحتاج
                                                  log(isOnline.runtimeType
                                                      .toString());
                                                  if (isOnline.runtimeType ==
                                                      bool) {
                                                    return Text(
                                                      "onlie".tr(),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: Color(
                                                              0xFF979797)),
                                                    );
                                                  } else {
                                                    DateTime date =
                                                        DateTime.parse(
                                                            isOnline);
                                                    DateTime now =
                                                        DateTime.now();
                                                    Duration difference =
                                                        now.difference(date);

                                                    String lastSeenText;
                                                    if (difference.inDays > 0) {
                                                      lastSeenText = "Last seen " +
                                                          "${difference.inDays} ${difference.inDays == 1 ? "day".tr() : "days".tr()}" +
                                                          " ago".tr();
                                                    } else if (difference
                                                            .inHours >
                                                        0) {
                                                      lastSeenText = "Last seen" +
                                                          " ${difference.inHours} ${difference.inHours == 1 ? "hour" : "hours"}" +
                                                          " ago".tr();
                                                    } else if (difference
                                                            .inMinutes >
                                                        0) {
                                                      lastSeenText = "Last seen"
                                                              .tr() +
                                                          " ${difference.inMinutes} ${difference.inMinutes == 1 ? "minute".tr() : "minutes".tr()}" +
                                                          "ago".tr();
                                                    } else {
                                                      lastSeenText =
                                                          "Last seen just now"
                                                              .tr();
                                                    }

                                                    return Text(
                                                      lastSeenText,
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            Color(0xFF979797),
                                                      ),
                                                    );
                                                  }
                                                }
                                                return Container();
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      scaffoldKey.currentState!.showBottomSheet(
                                        // enableDrag: true,
                                        backgroundColor: Colors.white,
                                        (context) {
                                          return Container(
                                            width: double.infinity,
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0xFFE5E5E5),
                                                  blurRadius: 100,
                                                  offset: Offset(0,
                                                      3), // changes position of shadow
                                                ),
                                              ],
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(30),
                                              ),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 50,
                                                  height: 5,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      color: AppColor.blue200),
                                                ),
                                                Gap(40),
                                                GestureDetector(
                                                  onTap: () async {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection(
                                                            "ChatProduct")
                                                        .doc("users")
                                                        .collection("chat")
                                                        .doc(Id.UserIdString)
                                                        .collection("products")
                                                        .doc(widget.productId)
                                                        .collection("massage")
                                                        .get()
                                                        .then(
                                                      (value) {
                                                        log(value.docs
                                                            .toString());
                                                        for (DocumentSnapshot ds
                                                            in value.docs) {
                                                          ds.reference.delete();
                                                        }
                                                        ;
                                                      },
                                                    );
                                                    context.pop();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.delete_outlined,
                                                        color: AppColor.blue500,
                                                        size: 30,
                                                      ),
                                                      Gap(20),
                                                      Text(
                                                        "Delete".tr(),
                                                        style: style16.copyWith(
                                                            color: AppColor
                                                                .blue500,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Gap(40),
                                                GestureDetector(
                                                  onTap: () {
                                                    FirebaseFirestore.instance.collection("reportChat").add(
                          {
                            "from_user_id": Id.UserIdInt,
                            "to_user_id": widget.productModel.userId,
                            // "to_user_Name": widget.productModel.userId,
                          }
                        );
                        context.pop();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.error_outline,
                                                        color: AppColor.blue500,
                                                        size: 30,
                                                      ),
                                                      Gap(20),
                                                      Text(
                                                        "Report".tr(),
                                                        style: style16.copyWith(
                                                            color: AppColor
                                                                .blue500,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Gap(40),
                                                GestureDetector(
                                                  onTap: () async {
                                                    DocumentSnapshot<
                                                            Map<String,
                                                                dynamic>>
                                                        snapshot =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "ChatProduct")
                                                            .doc("users")
                                                            .collection("chat")
                                                            .doc(
                                                                Id.UserIdString)
                                                            .collection(
                                                                "products")
                                                            .doc(widget
                                                                .productId)
                                                            .get();
                                                    if (snapshot.exists) {
                                                      var data =
                                                          snapshot.data();
                                                      if (data != null) {
                                                        if (isYouBlock!) {
                                                          if (snapshot[
                                                                  "first block"] ==
                                                              "No Block") {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "ChatProduct")
                                                                .doc("users")
                                                                .collection(
                                                                    "chat")
                                                                .doc(Id
                                                                    .UserIdString)
                                                                .collection(
                                                                    "products")
                                                                .doc(widget
                                                                    .productId)
                                                                .set({
                                                              "first block":
                                                                  "No Block"
                                                            });
                                                          } else {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "ChatProduct")
                                                                .doc("users")
                                                                .collection(
                                                                    "chat")
                                                                .doc(Id
                                                                    .UserIdString)
                                                                .collection(
                                                                    "products")
                                                                .doc(widget
                                                                    .productId)
                                                                .set({
                                                              "second":
                                                                  "No Block"
                                                            });
                                                          }
                                                        }
                                                        // No Block
                                                        else {
                                                          if (snapshot[
                                                                  "first block"] ==
                                                              "No Block") {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "ChatProduct")
                                                                .doc("users")
                                                                .collection(
                                                                    "chat")
                                                                .doc(Id
                                                                    .UserIdString)
                                                                .collection(
                                                                    "products")
                                                                .doc(widget
                                                                    .productId)
                                                                .set({
                                                              "first block": Id
                                                                  .UserIdString
                                                            });
                                                          } else {
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    "ChatProduct")
                                                                .doc("users")
                                                                .collection(
                                                                    "chat")
                                                                .doc(Id
                                                                    .UserIdString)
                                                                .collection(
                                                                    "products")
                                                                .doc(widget
                                                                    .productId)
                                                                .set({
                                                              "second": Id
                                                                  .UserIdString
                                                            });
                                                          }
                                                        }
                                                      }
                                                    } else {
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "ChatProduct")
                                                          .doc("users")
                                                          .collection("chat")
                                                          .doc(Id.UserIdString)
                                                          .collection(
                                                              "products")
                                                          .doc(widget.productId)
                                                          .set({
                                                        "first block":
                                                            Id.UserIdString
                                                      });
                                                    }
                                                    context.pop();
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.block_flipped,
                                                        color: AppColor.blue500,
                                                        size: 30,
                                                      ),
                                                      Gap(20),
                                                      Text(
                                                        isYouBlock!
                                                            ? "unBlock".tr()
                                                            : "Block".tr(),
                                                        style: style16.copyWith(
                                                            color: AppColor
                                                                .blue500,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Gap(40),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: AppColor.blue500,
                                    ),
                                  )
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
                                GestureDetector(
                                  onTap: () {
                                    context.pushNamed(AppRouter.productScreen,
                                        extra: int.parse(widget.productId));
                                  },
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        color: Color(0x110E85B6),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Row(
                                            children: [
                                              CustomCachedNetworkImage(
                                                placeholder: Container(
                                                width: 88,
                                                height: 77,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                        ),
                                              ),
                                        imageUrl: widget.productModel
                                                                .images!.first,
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                                width: 88,
                                                height: 77,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover)),
                                              );
                                        },
                                      ),
                                              // Container(
                                              //   width: 88,
                                              //   height: 77,
                                              //   decoration: BoxDecoration(
                                              //       borderRadius:
                                              //           BorderRadius.circular(
                                              //               10),
                                              //       image: DecorationImage(
                                              //           image: NetworkImage(
                                              //               widget.productModel
                                              //                   .images!.first),
                                              //           fit: BoxFit.cover)),
                                              // ),
                                              Gap(15),
                                              Flexible(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget
                                                          .productModel.title!,
                                                      style: style14.copyWith(
                                                        color: AppColor.blue500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "Price".tr(),
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                    Text(
                                                      widget.productModel.price
                                                          .toString(),
                                                      style: style12.copyWith(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          color: AppColor
                                                              .black500),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Flexible(
                                          child: Icon(
                                            Icons.arrow_forward_ios_outlined,
                                            color: AppColor.black100,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
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

  // massageWithMedia(){

  // }
}

class ChatTextField extends StatefulWidget {
  ChatTextField(
      {super.key,
      required this.chatController,
      required this.scaffoldKey,
      required this.productId,
      required this.productModel,
      required this.userModel,
      required this.userId});
  TextEditingController chatController;
  GlobalKey<ScaffoldState> scaffoldKey;
  final AdsBusinessModel productModel;
  final UserInformationModel userModel;
  final int userId;
  final String productId;
  @override
  State<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends State<ChatTextField> {
  ScrollController controller = ScrollController();
  final record = AudioRecorder();
  late Timer? timer;
  bool idRecord = false;
  double secondsElapsed = 0.0;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();

  // }
  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldChat(
      prefixIcon: GestureDetector(
        onLongPressStart: (details) async {
          log("Ok");
          setState(() {
            idRecord = true;
          });
          const oneSec = const Duration(seconds: 1);
          timer = Timer.periodic(oneSec, (Timer timer) {
            setState(() {
              secondsElapsed += 1;
            });
          });
          if (await record.hasPermission()) {
            // Start recording to file
            String path = (await getTemporaryDirectory()).path + '/record.mp3';
            await record.start(const RecordConfig(), path: path);
            // ... or to stream
            // final stream = await record.startStream(
            //     const RecordConfig(encoder: AudioEncoder.pcm16bits));
          }
        },
        onLongPressEnd: (details) async {
          setState(() {
            idRecord = false;
          });
          timer?.cancel();
          setState(() {
            secondsElapsed = 0;
          });
          final path = await record.stop();
          log("---------------------------------------------------------------------------");
          log(path.toString());
          log("---------------------------------------------------------------------------");
          XFile file = XFile(path!);

          String url = await uploadVideo(file, "sound");
          log('----------------------------------------------------------');
          log(file.path);
          log('----------------------------------------------------------');
          sendMassage(url, "sound");
        },
        child: idRecord
            ? Text(
                secondsElapsed.toString(),
                style: style12,
              )
            : Icon(
                Icons.keyboard_voice,
                color: AppColor.blue500,
              ),
      ),
      isThereMedia: true,
      onTap: () async {
        if (widget.chatController.text.isNotEmpty) {
          sendMassage(widget.chatController.text, "text");
        }
      },
      onTapMedia: () async {
        widget.scaffoldKey.currentState!.showBottomSheet(
          (context) {
            return Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 100,
                    )
                  ]),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                      onTap: () async {
                        XFile? file = await ImagePicker()
                            .pickVideo(source: ImageSource.gallery);
                        if (file == null) {
                          return;
                        }
                        String url = await uploadVideo(file, "videos");
                        sendMassage(url, "video");
                        context.pop();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImage.takeVideo),
                          Gap(10),
                          Text(
                            "Take Video".tr(),
                            style:
                                style12.copyWith(fontWeight: FontWeight.w600),
                          )
                        ],
                      )),
                  // Gap(20),
                  GestureDetector(
                      onTap: () async {
                        XFile? file = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (file == null) {
                          return;
                        }
                        String url = await uploadVideo(file, "images");
                        sendMassage(url, "image");
                        context.pop();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(AppImage.camera),
                          Gap(10),
                          Text(
                            "Take Image".tr(),
                            style:
                                style12.copyWith(fontWeight: FontWeight.w600),
                          )
                        ],
                      )),
                ],
              ),
            );
          },
        );
      },
      //
      // () {
      // sendMassage();
      // signalR..sendMessage("widget.name", "txtController.text");
      // txtController.clear();
      // scrollController.jumpTo(
      //     scrollController.position.maxScrollExtent + 75);
      // },
      //             onTap: () async {
      //               final wsUrl = Uri.parse('https://92.205.235.108:2020/chat-hub');
      // final channel = WebSocketChannel.connect(wsUrl);

      // await channel.ready;

      // channel.stream.listen((message) {
      //   channel.sink.add('received!');
      //   // channel.sink.close(status.goingAway);
      // });
      // },
      // main,
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
      chatController: widget.chatController,
      // image: "user!.photoPath!",
      // name: "user!.firstName!",
      // email: "user!.email!",
      // phone: "user!.phoneNumber!",
    );
  }

  uploadVideo(XFile file, String type) async {
    //Get Video from the gallery
    log(file.path.split("/").last);
    File videoFile = File(file.path);
    // 1. Create a reference to the file you want to upload
    FirebaseStorage storage = FirebaseStorage.instance;
    TaskSnapshot storageRef = await storage
        .ref()
        .child("$type/${"${DateTime.now()}${file.path.split("/").last}"}")
        .putFile(videoFile);
    final String videoURL = await storageRef.ref.getDownloadURL();
    NotificationServiceChat.sendNotification(
      title: "فيديو جديده",
      body: "فيديو",
      id: int.parse(widget.userId.toString()),
    );

    if (videoURL.isEmpty) {
      return;
    }
    return videoURL;
  }

  sendMassage(String massage, String type) async {
    var insultsList =
        await FirebaseFirestore.instance.collection("insults").get();

    if (insultsList.docs.isNotEmpty) {
      var insults = insultsList.docs.map((doc) => doc['insults']).toList();
      var wordsInSentence = widget.chatController.text.split(' ');

      bool insultFound = false;

      for (var word in wordsInSentence) {
        if (insults.contains(word)) {
          insultFound = true;
          break;
        }
      }

      if (insultFound) {
        FirebaseFirestore.instance
            .collection(
              "ChatProduct",
            )
            .doc("users")
            .collection("chat")
            .doc(Id.UserIdString)
            .collection("products")
            .doc(widget.productId)
            .collection("massage")
            .add(
          {
            "massage": massage,
            "senderId": Id.UserIdInt,
            "receiverId": widget.productModel
                .userId, //CachData.getData(key: 'idbBusinessAcount')
            "image": widget.userModel.photoPath,
            "name":
                "${widget.userModel.firstName} ${widget.userModel.lastName}",
            "email": widget.userModel.email,
            "date": DateTime.now().toString(),
            "phone": widget.userModel.phoneNumber,
            "isSeen": false,
            "type": type,
            "isWarning": true,
          },
        );
        widget.chatController.clear();
      } else {
        FirebaseFirestore.instance
            .collection(
              "ChatProduct",
            )
            .doc("users")
            .collection("chat")
            .doc(Id.UserIdString)
            .collection("products")
            .doc(widget.productId)
            .collection("massage")
            .add(
          {
            "massage": massage,
            "senderId": Id.UserIdInt,
            "receiverId": widget.productModel
                .userId, //CachData.getData(key: 'idbBusinessAcount')
            "image": widget.userModel.photoPath,
            "name":
                "${widget.userModel.firstName} ${widget.userModel.lastName}",
            "email": widget.userModel.email,
            "date": DateTime.now().toString(),
            "phone": widget.userModel.phoneNumber,
            "isSeen": false,
            "type": type,
            "isWarning": false,
          },
        );
        NotificationServiceChat.sendNotification(
            title: "رساله جديده",
            body: widget.chatController.text,
            id: widget.userId);
        widget.chatController.clear();
      }
    }
    FirebaseFirestore.instance
        .collection("ChatProduct")
        .doc("users")
        .collection("chat")
        .doc(Id.UserIdString)
        .collection("products")
        .doc(widget.productId)
        .set({"first block": "No Block", "second": "No Block"});
  }
}
