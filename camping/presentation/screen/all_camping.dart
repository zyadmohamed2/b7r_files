import 'package:ba7r/Core/function/log.dart';
import 'package:ba7r/Core/service/uni_service.dart';

import 'package:ba7r/Core/utils/colors.dart';
import 'package:ba7r/Core/utils/routes.dart';
import 'package:ba7r/Core/utils/text_style.dart';
import 'package:ba7r/Core/widgets/custom_appBar.dart';
import 'package:ba7r/Features/view/SafariSport/presentation/screen/dune_bashing.dart';
import 'package:ba7r/Features/view/camping/data/model/all_camping_model.dart';
import 'package:ba7r/Features/view/home_sea/presentation/widget/recomended_card.dart';
import 'package:ba7r/Features/view/home_sea/presentation/widget/search_hoem.dart';
import 'package:ba7r/Features/view_model/Camping/camping_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class AllCampingScreen extends StatefulWidget {
  const AllCampingScreen({super.key});

  @override
  State<AllCampingScreen> createState() => _AllCampingScreenState();
}

class _AllCampingScreenState extends State<AllCampingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<CampingBloc>(context).add(GetAllCamping());
  }

  List<AllCampingModel>? allCamping;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: "Camping".tr(), context: context),
      body: BlocConsumer<CampingBloc, CampingState>(
        listener: (context, state) {
          if (state is SuccessGetALlCamping) {
            allCamping = state.allCamping;
          }
        },
        builder: (context, state) {
          if (allCamping != null) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Gap(30),
                    SearchHoem(
                      searchList: allCamping!
                          .map((e) => SearchModel(
                              isFavorite: e.isFavorite!,
                              image: e.campingImage!,
                              title: e.title!,
                              location: e.address.toString(),
                              id: e.id!))
                          .toList(),
                      onTap: (id, type) {
                        context.pushNamed(AppRouter.camping, extra: id);
                      },
                      title: "Search for any hunting camping...".tr(),
                    ),
                    Gap(48),
                    ...List.generate(
                      allCamping!.length,
                      (index) {
                        return ItemCardHoemLand(
                            onShare: () {
                              Share.share(
                                  "${UniService.camping}?id=${allCamping?[index].id}");
                            },
                            onSuccess: () {
                              BlocProvider.of<CampingBloc>(context)
                                  .add(GetAllCamping());
                            },
                            onTap: () {
                              context.pushNamed(AppRouter.campingScreen,
                                  extra: allCamping![index].id);
                            },
                            image: allCamping![index].campingImage!,
                            title: allCamping![index].title!,
                            location: allCamping![index].address!,
                            favorite: allCamping![index].isFavorite!,
                            id: allCamping![index].id!,
                            serviceType: ServiceType.Camping);
                      },
                    )
                  ],
                ),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(color: AppColor.blue500),
            );
          }
        },
      ),
    );
  }
}
