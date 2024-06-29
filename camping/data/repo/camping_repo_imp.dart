import 'package:ba7r/Core/function/log.dart';

import 'package:ba7r/Core/service/CachData.dart';
import 'package:ba7r/Core/service/api_service.dart';
import 'package:ba7r/Core/service/error.dart';
import 'package:ba7r/Core/utils/links.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/booking_model.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/get_all_reviews.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/rate_percentage_model.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/review_input_model.dart';
import 'package:ba7r/Features/view/camping/data/model/all_camping_model.dart';
import 'package:ba7r/Features/view/camping/data/model/available_camping_model.dart';
import 'package:ba7r/Features/view/camping/data/model/camping_model.dart';
import 'package:ba7r/Features/view/camping/data/repo/camping_repo.dart';
import 'package:ba7r/id.dart';
import 'package:dartz/dartz.dart';

class CampingRepoImp extends CampingRepo {
  ApiService api = ApiService();
  @override
  Future<Either<Failure, List<AllCampingModel>>> getAllCamping() async {
    try {
      var response = await api.get(
          url: Links.GetAllCampings, queryParameters: {"UserId": Id.UserIdInt});
      if (response.statusCode == 200) {
        List<AllCampingModel> allCamping = (response.data as List)
            .map((e) => AllCampingModel.fromJson(e))
            .toList();
        return right(allCamping);
      } else {
        return left(ServerFailure(errMessage: response.data['massage']));
      }
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, CampingModel>> getCamping({required int id}) async {
    try {
      log(id.toString());
      var response =
          await api.get(url: Links.GetCamping, key: "Id", valutInt: id);

      if (response.statusCode == 200) {
        CampingModel Camping = CampingModel.fromJson(response.data);
        return right(Camping);
      } else {
        return left(ServerFailure(errMessage: response.data['massage']));
      }
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableCampingModel>>> geTAvailableForCamping(
      {required int id}) async {
    try {
      var response = await api.get(
          url: Links.GeTAvailableForCamping, key: 'CampingId', valutInt: id);
      log(response.data.toString());
      log(response.statusCode.toString());
      if (response.statusCode == 200) {
        List<AvailableCampingModel> availableCampingModel =
            (response.data as List)
                .map((e) => AvailableCampingModel.fromJson(e))
                .toList();
        return right(availableCampingModel);
      } else {
        return left(ServerFailure(errMessage: response.data['massage']));
      }
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> addReview(
      {required ReviewInputModel reviewInputModel}) async {
    try {
      var response = await api.post(url: Links.AddCampingReview, data: {
        "comments": reviewInputModel.comment,
        "rating": reviewInputModel.rate
      }, queryParameters: {
        "CampingId": reviewInputModel.trainingId,
        "UserId": Id.UserIdInt
      });
      return right(response.data);
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> booking(
      {required BookingModel bookingModel}) async {
    try {
      log('messageoooo');
      // log(bookingModel.trainingId.toString());
      // log(.toString());
      // log(message)
      log(bookingModel.day!);
      log(bookingModel.fromTime!);
      log(bookingModel.toTime!);
      log(bookingModel.countPersons.toString());
      log(bookingModel.totalPrice.toString());
      // log(customizeModel!.customizeList.toString());
      log(bookingModel.informationModel!.trainingId.toString());
      var response = await api.post(url: Links.AddCampingBooking, data: {
        "day": bookingModel.day,
        "fromTime": bookingModel.fromTime,
        "toTime": bookingModel.toTime,
        "countPersons": bookingModel.countPersons,
        "totalPrice": bookingModel.totalPrice,
      }, queryParameters: {
        "CampingId": bookingModel.informationModel!.trainingId,
        "userId": Id.UserIdInt
      });

      log(response.statusCode.toString());
      log(response.data);
      if (response.statusCode == 200) {
        log(response.data);
        return right(response.data);
      } else {
        log(response.data.toString());
        return left(ServerFailure(errMessage: "Error For Booking"));
      }
    } catch (e) {
      log("Booking Error ${e.toString()}");
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<GetAllReviewsModel>>> getAllReviews(
      {required int id}) async {
    try {
      var response = await api.get(
          url: Links.GetAllReviewsCamping, key: "CampingId", valutInt: id);
      log("response.data ${response.data}");
      if (response.statusCode == 200) {
        List<GetAllReviewsModel> getAllReviewsList = (response.data as List)
            .map((e) => GetAllReviewsModel.fromJson(e))
            .toList();
        log("getAllReviewsList $getAllReviewsList");
        return right(getAllReviewsList);
      }
      if (response.data['message'] == 'No Reviews Found') {
        return left(NoComment(errMessage: response.data['message']));
      }
      throw "Error";
    } catch (e) {
      return left(ServerFailure(errMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, RatePercentageModel>> ratePercentage(
      {required int id}) async {
    try {
      var response = await api.get(
          url: Links.RatePercentageCamping, valutInt: id, key: "CampingId");
      // StackTrace stackTrace = StackTrace.current;
      // log("jjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjjj ${response.statusCode}", stackTrace: stackTrace);
      log("Llllllllllllllllllllllllllllllll ${response.data}");
      return right(RatePercentageModel.fromJson(response.data));
    } catch (e) {
      log("RatePercentageModel ${e.toString()}");
      return left(ServerFailure(errMessage: e.toString()));
    }
  }
}
