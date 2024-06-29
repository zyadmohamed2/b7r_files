import 'package:ba7r/Core/function/log.dart';

import 'package:ba7r/Core/function/handleCustomizePrice.dart';
import 'package:ba7r/Core/service/booking/confirm.dart';
import 'package:ba7r/Core/service/booking/model/information_page_model.dart';
import 'package:ba7r/Core/utils/links.dart';
import 'package:ba7r/Core/service/uni_service.dart';
import 'package:ba7r/Core/utils/colors.dart';
import 'package:ba7r/Core/utils/routes.dart';
import 'package:ba7r/Core/utils/text_style.dart';
import 'package:ba7r/Core/widgets/custom_buttom.dart';
import 'package:ba7r/Core/widgets/product_info.dart';
import 'package:ba7r/Features/notification_service.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/get_all_reviews.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/rate_percentage_model.dart';
import 'package:ba7r/Features/view/TrainingSession/presentation/screen/coache_screen.dart';
import 'package:ba7r/Features/view/TrainingSession/presentation/widget/Image_product.dart';
import 'package:ba7r/Features/view/TrainingSession/presentation/widget/comment.dart';
import 'package:ba7r/Features/view/TrainingSession/presentation/widget/rating_card.dart';
import 'package:ba7r/Features/view/camping/data/model/available_camping_model.dart';
import 'package:ba7r/Features/view/camping/data/model/camping_model.dart';
import 'package:ba7r/Features/view_model/Camping/camping_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class CampingScreen extends StatefulWidget {
  const CampingScreen({super.key, required this.id});
  final int id;
  @override
  State<CampingScreen> createState() => _CampingScreenState();
}

class _CampingScreenState extends State<CampingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CampingBloc>(context).add(GetCamping(id: widget.id));
    BlocProvider.of<CampingBloc>(context)
        .add(GeTAvailableForCamping(id: widget.id));
    BlocProvider.of<CampingBloc>(context).add(GetAllReviews(id: widget.id));
    BlocProvider.of<CampingBloc>(context).add(RatePercentage(id: widget.id));
    log(widget.id.toString());
    customize = CustomizeModel(
        customizeModel:
            CustomizeListModel(customizeList: [], customizeListKey: []));
  }

  CustomizeModel? customize;

  CampingModel? Camping;
  List<AvailableCampingModel>? avaliableCampingModel;
  List<GetAllReviewsModel> getAllReviews = [];
  RatePercentageModel? ratePercentageModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<CampingBloc, CampingState>(
        listener: (context, state) {
          if (state is SuccessGeTAvailableForCamping) {
            avaliableCampingModel = state.availableCamping;
          }
          if (state is SuccessGetCamping) {
            Camping = state.Camping;
          }
          if (state is SuccessGetAllReviewsCamping) {
            getAllReviews = state.getAllReviewsModel;
          }
          if (state is SuccessRatePercentageCamping) {
            ratePercentageModel = state.ratePercentage;
          }
        },
        builder: (context, state) {
          if (Camping != null && avaliableCampingModel != null) {
            return Stack(children: [
              Stack(
                // crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  ImageProduct(
                    isShare: true,
                    urlShare: "${UniService.camping}?id=${widget.id}",
                    height: 335,
                    images: Camping!.images,
                    isList: true,
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 260.h),
                    padding: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30))),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Gap(15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Text(
                                          Camping!.title!,
                                          style: style20.copyWith(
                                              fontWeight: FontWeight.bold),
                                          softWrap: true,
                                        ),
                                      ),
                                      Flexible(
                                        flex: 2,
                                        child: TextButton(
                                          onPressed: () {
                                            AddReviewModel addReviewModel =
                                                AddReviewModel(
                                                    keyId: "CampingId",
                                                    isLand: true,
                                                    url: Links.AddCampingReview,
                                                    image:
                                                        Camping!.images!.first,
                                                    title: Camping!.title!,
                                                    price: Camping!.price!,
                                                    isThereComment: true,
                                                    id: widget.id);
                                            context.pushNamed(
                                                AppRouter.addReviewSafariSport,
                                                extra: addReviewModel);
                                          },
                                          child: Text(
                                            "Add Review".tr(),
                                            style: style14.copyWith(
                                                fontWeight: FontWeight.w700,
                                                color: AppColor.blue500),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 25.h,
                                  ),
                                  Text(
                                    "Available".tr(),
                                    style: style12.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15,
                                        color: AppColor.blue500),
                                  ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  // widget.customize
                                  // ?
                                  Column(
                                    children: [
                                      SizedBox(
                                          height: 100,
                                          child:
                                              avaliableCampingModel!.isNotEmpty
                                                  ? ListView(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      children: List.generate(
                                                        avaliableCampingModel!
                                                            .length,
                                                        (index) {
                                                          return AvailableCard(
                                                              title: avaliableCampingModel![
                                                                      index]
                                                                  .nameAvailable!,
                                                              image: avaliableCampingModel![
                                                                      index]
                                                                  .photoPathAvailable!);
                                                        },
                                                      ))
                                                  : Text(
                                                      "No available".tr(),
                                                      style: style18.copyWith(
                                                          color: AppColor
                                                              .primaryColor),
                                                    )),
                                      ReviewAndAbout(
                                        totalCountComments:
                                            Camping!.commentsCount!,
                                        aboutORreview: false,
                                        secondChild: Column(
                                          children: [
                                            RatingCard(
                                              rate: Camping!.rating!,
                                              totalCountReview:
                                                  Camping!.commentsCount!,
                                              ratePercentage:
                                                  ratePercentageModel!,
                                            ),
                                            // SvgPicture.asset(AppImage.user2,),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            state is NoCommentCamping?
                                                ? SizedBox.shrink()
                                                : Column(
                                                    children: List.generate(
                                                        Camping?.reviewCount??0,
                                                        (index) {
                                                    return Comment(
                                                        name: getAllReviews![
                                                                index]
                                                            .userName!,
                                                        image: getAllReviews![
                                                                index]
                                                            .imageUser!,
                                                        contant: getAllReviews![
                                                                index]
                                                            .comment!,
                                                        date: getAllReviews![
                                                                index]
                                                            .date!,
                                                        rate: getAllReviews![
                                                                index]
                                                            .rate!
                                                            .toDouble());
                                                  }))
                                          ],
                                        ),
                                        firstChild: Container(
                                          margin: EdgeInsets.only(bottom: 20),
                                          child: Text(
                                            Camping!.about!,
                                            style: style14.copyWith(
                                                color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${Camping!.price} AED",
                                      style: style20,
                                    ),
                                    Text(
                                      "Per Day".tr(),
                                    )
                                  ],
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: CustomButtom(
                                  text: "Book Now".tr(),
                                  onTap: () {
                                    InformationPageModel informationPageModel =
                                        InformationPageModel(
                                            notificationType: NotificationType
                                                .Camping,
                                            supplise: handleCustomizePrice(
                                                customizeATourGuidePrice: Camping!
                                                    .customizeATourGuidePrice!,
                                                customizeArtistMusicianPrice:
                                                    Camping!
                                                        .customizeArtistMusicianPrice!,
                                                customizeBoatDriverPrice: Camping!
                                                    .customizeBoatDriverPrice!,
                                                customizeFilmingVideoPrice: Camping!
                                                    .customizeFilmingVideoPrice!,
                                                customizeFoodServicesPrice: Camping!
                                                    .customizeFoodServicesPrice!,
                                                customize: customize!),
                                            type: "Camping".tr(),
                                            textButtom: "Book Camping".tr(),
                                            couponLink:
                                                Links.CheckCouponCamping,
                                            keyId: "CampingId",
                                            urlBooking: Links.AddCampingBooking,
                                            urlReview: Links.AddCampingReview,
                                            id: widget.id,
                                            image: Camping!.images!.first,
                                            price: Camping!.price!,
                                            title: Camping!.title,
                                            isThereCustomize: true,
                                            customizeList: customize);
                                    context.pushNamed(
                                        AppRouter.informationSfariSport,
                                        extra: informationPageModel);
                                    // InformationModel info;
                                    // if (widget.isPackage) {
                                    //   info = InformationModel(
                                    //       titleButtom: widget.titleButtom,
                                    //       price: widget.productModel.price!,
                                    //       image: widget.productModel.images![0],
                                    //       title: widget.productModel.title!,
                                    //       trainingId: widget.id,
                                    //       addReview: widget.linkReview,
                                    //       booking: widget.linkBooking,
                                    //       key: widget.keyApi,
                                    //       userCount: countPersons,
                                    //       customize: [],
                                    //       timeFrom: timeFrom == null
                                    //           ? widget.productModel.packageTimes!
                                    //               .first.timeFrom
                                    //           : timeFrom,
                                    //       timeTo: timeTo == null
                                    //           ? widget.productModel.packageTimes!
                                    //               .first.timeTo
                                    //           : timeTo,
                                    //       packageDays:
                                    //           widget.productModel.packageDays,
                                    //       isPackage: true);
                                    // } else {
                                    //   info = InformationModel(
                                    //       titleButtom: widget.titleButtom,
                                    //       userCount: countPersons,
                                    //       price: widget.productModel.price!,
                                    //       image: widget.productModel.images![0],
                                    //       title: widget.productModel.title!,
                                    //       trainingId: widget.id,
                                    //       addReview: widget.linkReview,
                                    //       booking: widget.linkBooking,
                                    //       key: widget.keyApi,
                                    //       isPackage: widget.isPackage);
                                    // }
                                    // context.pushNamed(AppRouter.bookScreen,
                                    //     extra: info);
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // widget.customize
                  //     ?
                  CustomizeButtom(
                    onTap: (customizeModel) {
                      // log(customizeModel.customizeList.toString());
                      log(customizeModel.customRequst.toString());
                      customize = customizeModel;
                    },
                  ),
                ],
              ),
            ]);
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: AppColor.blue500,
              ),
            );
          }
        },
      ),
    );
  }
}
