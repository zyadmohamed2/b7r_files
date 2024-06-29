import 'package:ba7r/Core/service/error.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/booking_model.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/get_all_reviews.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/rate_percentage_model.dart';
import 'package:ba7r/Features/view/TrainingSession/data/models/training/review_input_model.dart';
import 'package:ba7r/Features/view/camping/data/model/all_camping_model.dart';
import 'package:ba7r/Features/view/camping/data/model/available_camping_model.dart';
import 'package:ba7r/Features/view/camping/data/model/camping_model.dart';
import 'package:dartz/dartz.dart';

abstract class CampingRepo {
  Future<Either<Failure, List<AllCampingModel>>> getAllCamping();
  Future<Either<Failure, CampingModel>> getCamping({required int id});
  Future<Either<Failure, List<AvailableCampingModel>>> geTAvailableForCamping(
      {required int id});
  Future<Either<Failure, Map<String, dynamic>>> booking(
      {required BookingModel bookingModel});
  Future<Either<Failure, Map<String, dynamic>>> addReview(
      {required ReviewInputModel reviewInputModel});
  Future<Either<Failure, List<GetAllReviewsModel>>> getAllReviews(
      {required int id});
  Future<Either<Failure, RatePercentageModel>> ratePercentage(
      {required int id});
}
