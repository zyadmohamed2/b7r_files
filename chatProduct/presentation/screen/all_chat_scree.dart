import 'package:ba7r/Core/function/log.dart';

import 'package:ba7r/Core/service/CachData.dart';
import 'package:ba7r/Core/utils/colors.dart';
import 'package:ba7r/Core/utils/images.dart';
import 'package:ba7r/Core/utils/routes.dart';
import 'package:ba7r/Core/utils/text_style.dart';
import 'package:ba7r/Core/widgets/custom_appBar.dart';
import 'package:ba7r/Core/widgets/custom_cached_network_image.dart';
import 'package:ba7r/id.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({super.key});

  @override
  State<AllChatScreen> createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  CollectionReference? massage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    massage = FirebaseFirestore.instance
        .collection("ChatProduct")
        .doc("MessageList")
        .collection(Id.BusinessAccountString);
  }
  // FirebaseFirestore
  //.instance.collection("").doc("").collection(widget.businessAcountId).add({
  //,, "time": time, "isSeen": isSeent, "": "zyad", "productId": widget.productId, "productName": widget.productTitle, "productPrice": widget.productPrice, "productImage": widget.productImage},);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              "Chats".tr(),
              style: style20,
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    isScrollControlled: true,
                    backgroundColor: Colors.white,
                    context: context,
                    builder: (context) {
                      return Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
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
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 50,
                              height: 5,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: AppColor.blue200),
                            ),
                            Gap(40),
                            GestureDetector(
                              onTap: () {
                                context.pushNamed(AppRouter.deletedMassages);
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
                                    "Deleted Messages".tr(),
                                    style: style16.copyWith(
                                        color: AppColor.blue500,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                            Gap(40),
                            // Row(
                            //   children: [
                            //     Icon(Icons.person, color: AppColor.blue500, size: 30,),
                            //     Gap(20),
                            //     Text("Edite Profile", style: style16.copyWith(color: AppColor.blue500, fontWeight: FontWeight.w500),)
                            //   ],
                            // ),
                          ],
                        ),
                      );
                    },
                  );
                },
                icon: Icon(
                  Icons.more_vert_outlined,
                  color: AppColor.blue500,
                ),
              ),
            ],
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColor.blue500,
              unselectedLabelColor: AppColor.blue500.withOpacity(0.68),
              indicatorColor: AppColor.blue500,
              tabs: [
                Tab(icon: Text("All".tr())),
                Tab(icon: Text("Unread".tr())),
                Tab(icon: Text("Important".tr())),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ChatTab(),
              UnreadTab(),
              ImportantTab(),
            ],
          )),
    );
  }
}

class ChatTab extends StatefulWidget {
  const ChatTab({super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  CollectionReference? massage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    massage = FirebaseFirestore.instance
        .collection("ChatProduct")
        .doc("MessageList")
        .collection(Id.BusinessAccountString);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder<QuerySnapshot>(
          stream: massage!.orderBy("time", descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              // log(snapshot.data!.docs[0]['time'].toString());
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  // if (snapshot.data!.docs[index]['unread']) {
                  return GestureDetector(
                    onTap: () {
                      log(snapshot.data!.docs.length.toString());
                      context.pushNamed(
                        AppRouter.businessChat,
                        extra: {
                          "productId": snapshot.data!.docs[index]['productId'],
                          "userId": snapshot.data!.docs[index]['userId'],
                          "userImage": snapshot.data!.docs[index]['imageUser'],
                          "userName": snapshot.data!.docs[index]['name'],
                          "massageId": snapshot.data!.docs[index].id,
                          "productImage": snapshot.data!.docs[index]
                              ['productImage'],
                          "productPrice": snapshot.data!.docs[index]
                              ['productPrice'],
                          "productName": snapshot.data!.docs[index]
                              ['productName'],
                        },
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                CustomCachedNetworkImage(
                                  placeholder: Container(
                                  width: 65,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
            imageUrl: snapshot.data!.docs[index]['imageUser'],
            imageBuilder: (context, imageProvider) {
              return Container(
                                  width: 65,
                                  height: 60,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.circular(10)),
                                );
            },
          ),
                                // Container(
                                //   width: 65,
                                //   height: 60,
                                //   decoration: BoxDecoration(
                                //       image: DecorationImage(
                                //           image: NetworkImage(snapshot
                                //               .data!.docs[index]['imageUser']),
                                //           fit: BoxFit.cover),
                                //       borderRadius: BorderRadius.circular(10)),
                                // ),
                                Gap(15),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(snapshot.data!.docs[index]['name'],
                                          style: style16,
                                          overflow: TextOverflow.ellipsis),
                                      Gap(8),
                                      Text(
                                        snapshot.data!.docs[index]['massage']
                                                .toString()
                                                .startsWith(
                                                    "https://firebasestorage")
                                            ? ""
                                            : snapshot.data!.docs[index]
                                                ['massage'],
                                        style: style12.copyWith(
                                            color: AppColor.black500),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  children: [
                                    Text(
                                      getTime(
                                          snapshot.data!.docs[index]['time']),
                                      style: style12,
                                    ),
                                    Gap(15),
                                    snapshot.data!.docs[index]['senderId'] ==
                                            Id.UserIdInt
                                        ? SizedBox()
                                        : Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              color: !snapshot.data!.docs[index]
                                                      ['isSeen']
                                                  ? AppColor.blue500
                                                  : Colors.transparent,
                                              border: Border.all(
                                                  color: AppColor.blue500,
                                                  width: 2),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.check,
                                                color: !snapshot.data!
                                                        .docs[index]['isSeen']
                                                    ? Colors.white
                                                    : AppColor.blue500,
                                                size: 12,
                                              ),
                                            ),
                                          )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  );
                  // }
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You’re all up to date", style: style24.copyWith(color: AppColor.blue100),),
                    Gap(10),
                    Text("Currently, you do not have any chats", style: style14.copyWith(color: Colors.grey),),
                  ],
                ),
              );
            }
          },
        ));
  }

  getTime(String time) {
    final dateTime = DateTime.parse(time);

    final now = DateTime.now();

    final difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      return DateFormat('d/M/yyyy').format(dateTime); // تنسيق التاريخ
    } else {
      return DateFormat('h:mm a').format(dateTime); // تنسيق الساعة
    }
  }
}

class UnreadTab extends StatefulWidget {
  const UnreadTab({super.key});

  @override
  State<UnreadTab> createState() => _UnreadTabState();
}

class _UnreadTabState extends State<UnreadTab> {
  CollectionReference? massage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    massage = FirebaseFirestore.instance
        .collection("ChatProduct")
        .doc("MessageList")
        .collection(Id.BusinessAccountString);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder<QuerySnapshot>(
          stream: massage!.orderBy("time", descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // log(snapshot.data!.docs[0]['time'].toString());
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  log("snapshot.data!.docs[index]['unread'] 333333333 ${snapshot.data!.docs[0]['unread']}");
                  log("snapshot.data!.docs[index]['unread'] 333333333 ${snapshot.data!.docs[index].exists}");
                  if (snapshot.data!.docs[index]['unread']) {
                    log("snapshot.data!.docs[index]['unread']  ${snapshot.data!.docs[index]['unread']}");
                    return GestureDetector(
                      onTap: () {
                        log(snapshot.data!.docs.length.toString());
                        context.pushNamed(
                          AppRouter.businessChat,
                          extra: {
                            "productId": snapshot.data!.docs[index]
                                ['productId'],
                            "userId": snapshot.data!.docs[index]['userId'],
                            "userImage": snapshot.data!.docs[index]
                                ['imageUser'],
                            "userName": snapshot.data!.docs[index]['name'],
                            "massageId": snapshot.data!.docs[index].id,
                          },
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: Row(
                                children: [
                                  CustomCachedNetworkImage(
                                    placeholder: Container(
                                    width: 65,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
            imageUrl: snapshot.data!.docs[index]['imageUser'],
            imageBuilder: (context, imageProvider) {
              return Container(
                                    width: 65,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  );
            },
          ),
                                  // Container(
                                  //   width: 65,
                                  //   height: 60,
                                  //   decoration: BoxDecoration(
                                  //       image: DecorationImage(
                                  //           image: NetworkImage(snapshot.data!
                                  //               .docs[index]['imageUser']),
                                  //           fit: BoxFit.cover),
                                  //       borderRadius:
                                  //           BorderRadius.circular(10)),
                                  // ),
                                  Gap(15),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(snapshot.data!.docs[index]['name'],
                                            style: style16,
                                            overflow: TextOverflow.ellipsis),
                                        Gap(8),
                                        Text(
                                          snapshot.data!.docs[index]['massage'],
                                          style: style12.copyWith(
                                              color: AppColor.black500),
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Column(
                                    children: [
                                      Text(
                                        getTime(
                                            snapshot.data!.docs[index]['time']),
                                        style: style12,
                                      ),
                                      Gap(15),
                                      snapshot.data!.docs[index]['senderId'] ==
                                              Id.UserIdInt
                                          ? SizedBox()
                                          : Container(
                                              width: 18,
                                              height: 18,
                                              decoration: BoxDecoration(
                                                color: !snapshot.data!
                                                        .docs[index]['isSeen']
                                                    ? AppColor.blue500
                                                    : Colors.transparent,
                                                border: Border.all(
                                                    color: AppColor.blue500,
                                                    width: 2),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: !snapshot.data!
                                                          .docs[index]['isSeen']
                                                      ? Colors.white
                                                      : AppColor.blue500,
                                                  size: 12,
                                                ),
                                              ),
                                            )
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              );
            } else {
              return Center(
                child: Text("You don't have any\nUnread chats", style: style18.copyWith(color: AppColor.blue100), textAlign: TextAlign.center,),
              );
            }
          },
        ));
  }

  getTime(String time) {
    final dateTime = DateTime.parse(time);

    final now = DateTime.now();

    final difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      return DateFormat('d/M/yyyy').format(dateTime); // تنسيق التاريخ
    } else {
      return DateFormat('h:mm a').format(dateTime); // تنسيق الساعة
    }
  }
}

class ImportantTab extends StatefulWidget {
  @override
  State<ImportantTab> createState() => _ImportantTabState();
}

class _ImportantTabState extends State<ImportantTab> {
  CollectionReference? massage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    massage = FirebaseFirestore.instance
        .collection("chatDashBoardCustomer")
        .doc(Id.BusinessAccountString)
        .collection("massage");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: StreamBuilder<QuerySnapshot>(
          stream: massage!.orderBy("date", descending: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              log(snapshot.data);
              log(snapshot.data!.docs[0]['date'].toString());
              return ListView.builder(
                itemCount: 1,
                itemBuilder: (context, index) {
                  // if (snapshot.data!.docs[index]['unread']) {
                  return GestureDetector(
                    onTap: () {
                      context.pushNamed(AppRouter.importantChatScreen);
                      // log(snapshot.data!.docs.length.toString());
                      // context.pushNamed(
                      //   AppRouter.businessChat,
                      //   extra: {
                      //     "productId": snapshot.data!.docs[index]['productId'],
                      //     "userId": snapshot.data!.docs[index]['userId'],
                      //     "userImage": snapshot.data!.docs[index]['imageUser'],
                      //     "userName": snapshot.data!.docs[index]['name'],
                      //     "massageId": snapshot.data!.docs[index].id,
                      //     "productImage": snapshot.data!.docs[index]
                      //         ['productImage'],
                      //     "productPrice": snapshot.data!.docs[index]
                      //         ['productPrice'],
                      //     "productName": snapshot.data!.docs[index]
                      //         ['productName'],
                      //   },
                      // );
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 5,
                            child: Row(
                              children: [
                                Container(
                                  width: 65,
                                  height: 60,
                                  // decoration: BoxDecoration(
                                  //     image: DecorationImage(
                                  //         image: AssetImage(AppImage.logo),
                                  //         fit: BoxFit.cover),
                                  //     ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: SvgPicture.asset(AppImage.logo),
                                  ),
                                ),
                                Gap(15),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Ba7r",
                                          style: style16,
                                          overflow: TextOverflow.ellipsis),
                                      Gap(8),
                                      Text(
                                        snapshot.data!.docs[index]['massage']
                                                .toString()
                                                .startsWith(
                                                    "https://firebasestorage")
                                            ? ""
                                            : snapshot.data!.docs[index]
                                                ['massage'],
                                        style: style12.copyWith(
                                            color: AppColor.black500),
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.topRight,
                                child: Column(
                                  children: [
                                    Text(
                                      getTime(
                                          snapshot.data!.docs[index]['date']),
                                      style: style12,
                                    ),
                                    Gap(15),
                                    // snapshot.data!.docs[index]['senderId'] == 3
                                    //     ? SizedBox()
                                    //     : Container(
                                    //         width: 18,
                                    //         height: 18,
                                    //         decoration: BoxDecoration(
                                    //           color: !snapshot.data!.docs[index]
                                    //                   ['isSeen']
                                    //               ? AppColor.blue500
                                    //               : Colors.transparent,
                                    //           border: Border.all(
                                    //               color: AppColor.blue500,
                                    //               width: 2),
                                    //           shape: BoxShape.circle,
                                    //         ),
                                    //         child: Center(
                                    //           child: Icon(
                                    //             Icons.check,
                                    //             color: !snapshot.data!
                                    //                     .docs[index]['isSeen']
                                    //                 ? Colors.white
                                    //                 : AppColor.blue500,
                                    //             size: 12,
                                    //           ),
                                    //         ),
                                    //       )
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  );
                  // }
                },
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("You’re all up to date", style: style24.copyWith(color: AppColor.blue100),),
                    Gap(10),
                    Text("Currently, you do not have any chats", style: style14.copyWith(color: Colors.grey),),
                  ],
                ),
              );
            }
          },
        ));
  }

  getTime(String time) {
    final dateTime = DateTime.parse(time);

    final now = DateTime.now();

    final difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      return DateFormat('d/M/yyyy').format(dateTime); // تنسيق التاريخ
    } else {
      return DateFormat('h:mm a').format(dateTime); // تنسيق الساعة
    }
  }
}
