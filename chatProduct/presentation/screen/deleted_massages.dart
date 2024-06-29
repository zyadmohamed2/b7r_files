import 'package:ba7r/Core/utils/colors.dart';
import 'package:ba7r/Core/utils/images.dart';
import 'package:ba7r/Core/utils/text_style.dart';
import 'package:ba7r/Core/widgets/custom_appBar.dart';
import 'package:ba7r/Core/widgets/custom_cached_network_image.dart';
import 'package:ba7r/Features/view/BusinessAccount/presentation/widget/more_card.dart';
import 'package:ba7r/id.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class DeletedMassages extends StatefulWidget {
  DeletedMassages({super.key});

  @override
  State<DeletedMassages> createState() => _DeletedMassagesState();
}

class _DeletedMassagesState extends State<DeletedMassages> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  CollectionReference? massage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    massage = FirebaseFirestore.instance
        .collection("ChatProduct")
        .doc("deltedMassage")
        .collection(Id.UserIdString);
  }
//
// "gg"
// (string)

//
// "https://s3-alpha-sig.figma.com/img/42d2/5f1b/0c80614694d212db301ef3aa827ecd53?Expires=1710115200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=okLKtATeGwtd12HtDb2~8bBhqlfiOxXAhdrLtsTgtENurD46UB6pNWrs9N3WLBMOgehlOCBJVgtcOjLI0MQS8FsVkSdDPMS3ViSp1kRVuyJ~D8Nbj~Xdt07BW1vf9rcmX598WFlmAu3qot6KXnmMwTloVoSDIDMslFof8KfygHWONbKhWV-RmYczO~hmgJ9hEIZaAPDCdxSiAPjbkbgHNK-muFpT5VFZ5216vVvhcJs8yhCqxRcRm0VMRIj~qt4Gft7g1e-xln4y64EnDAiKVLQYG1ORVV~cxlEafEd2zblyBZwKRg-18HdD0guavyLtiKajwNNhu53H5EnjUFLMJA__"
// (string)

//
// "zyad"
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: customAppBar(title: "Deleted Messages".tr(), context: context),
      body: Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: StreamBuilder<QuerySnapshot>(
            stream: massage!.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 3,
                            child: Row(
                              children: [
                                CustomCachedNetworkImage(
                                  placeholder: Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                        imageUrl: snapshot
                                            .data!.docs[index]['userImage'],
                                        imageBuilder: (context, imageProvider) {
                                          return Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.fill),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                );
                                        },
                                      ),
                                // Container(
                                //   width: 60,
                                //   height: 60,
                                //   decoration: BoxDecoration(
                                //     image: DecorationImage(
                                //         image: NetworkImage(snapshot
                                //             .data!.docs[index]['userImage']),
                                //         fit: BoxFit.fill),
                                //     borderRadius: BorderRadius.circular(15),
                                //   ),
                                // ),
                                Gap(12),
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          snapshot.data!.docs[index]
                                              ['userName'],
                                          style: style16.copyWith()),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                          snapshot.data!.docs[index]['massage'],
                                          overflow: TextOverflow.ellipsis,
                                          style: style12.copyWith(
                                              color: AppColor.black500)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: GestureDetector(
                              onTap: () {
                                scaffoldKey.currentState!.showBottomSheet(
                                  (context) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 16, horizontal: 20),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 1000)
                                          ]),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            width: 50,
                                            height: 5,
                                            decoration: BoxDecoration(
                                                color: AppColor.blue200,
                                                borderRadius:
                                                    BorderRadius.circular(50)),
                                          ),
                                          Gap(30),
                                          Image.asset(
                                            AppImage.deletAccount,
                                            width: 122,
                                            height: 122,
                                          ),
                                          Gap(16),
                                          Text(
                                            "Delete Forever".tr(),
                                            style: style24.copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Gap(6),
                                          Text(
                                            "Are you sure you want to delete\nThis message?"
                                                .tr(),
                                            style: style18.copyWith(
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xA32C2C2C),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Gap(50),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              MoreCard(
                                                  text: "Cancel".tr(),
                                                  color: AppColor.blue100,
                                                  textColor: AppColor.blue500),
                                              MoreCard(
                                                onTap: () {
                                                  FirebaseFirestore.instance
                                                      .collection("ChatProduct")
                                                      .doc("deltedMassage")
                                                      .collection(Id
                                                          .BusinessAccountString)
                                                      .doc(snapshot
                                                          .data!.docs[index].id)
                                                      .delete();
                                                  // FirebaseFirestore.instance.collection("ChatProduct").doc("users").collection("chat").doc(myId.toString()).collection("products").doc(widget.productId).collection("massage").doc(snapshot.data!.docs[index].id).delete();
                                                  context.pop();
                                                },
                                                text: "Delete".tr(),
                                                color: Colors.red
                                                    .withOpacity(0.20),
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
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.12),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                    child: SvgPicture.asset(
                                  AppImage.deleteIcon,
                                )),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          )),
    );
  }
}
