import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ngo_app/view_models/user_prefernce/user_preference.dart';
import '../../data/exeception/status.dart';
import '../../repo/user_dashboard_repo/user_dashboard_repo.dart';
import '../device_utils/device_utils.dart';

class UserDashboardController extends GetxController{
  BannerAd? staticAd;
  BannerAd? inlineAd;
  NativeAd? nativeAd;

  var nativeAdLoaded = false.obs;  
  var staticAdLoaded = false.obs;
  RxBool inlineAdLoaded = false.obs;

  //For dashboard
  final _api= UserDashboardRepo();
  final rxRequestStatus = Status.LOADING.obs;
  RxString error = ''.obs;
  RxDouble totalDonation=  0.0.obs;
  RxString refreshedToken= ''.obs;

  RxBool isLoading= false.obs;
  final user= UserPreference();
  final DeviceUtils du = DeviceUtils();

  void setRequestStatus(Status value) => rxRequestStatus.value = value;
  void setError(String value) => error.value = value;

  @override
  void onInit() {
    super.onInit();
    fetchTotalDonationByUser();
  }

  @override
  void onReady() { // Changed from onInit
    super.onReady();
     loadStaticBannerAd();
     loadNativeAd();
     loadInlineBannerAd();
  }

  //Fetch Count OF Members
  void fetchTotalDonationByUser() async{
    isLoading.value= true;
    _api.fetchAllDonationAmount().then((value) {
      isLoading.value= false;
      totalDonation.value= value['totalContribution'];
      debugPrint(value['totalContribution'].toString());
      setRequestStatus(Status.COMPLETED);
    }).onError((error, stackTrace) {
      isLoading.value= false;
      debugPrint('UserDashboardController fetchTotalDonationByUser: ${error.toString()}');
      setRequestStatus(Status.ERROR);
    });
  }

//Native Ad
  void loadNativeAd() {
  nativeAd = NativeAd(
    adUnitId: "ca-app-pub-3940256099942544/2247696110",
    // adUnitId: "ca-app-pub-8961859671672268/1567973049", // your native ad id
    factoryId: "dashboardNativeAd", // must match Android factory
    request: const AdRequest(),
    listener: NativeAdListener(
      onAdLoaded: (ad) {
          nativeAdLoaded.value = true;
      },
      onAdFailedToLoad: (ad, error) {
        ad.dispose();
        debugPrint("Native ad failed: ${error.message}");
      },
    ),
  );
  nativeAd!.load();
}

//Static Banner Ad
  void loadStaticBannerAd() {
    staticAd = BannerAd(
      adUnitId: "ca-app-pub-8961859671672268/7445387190",
      size: AdSize.leaderboard,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
            staticAdLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error){
          ad.dispose();
          debugPrint('Static ad failed to load ${error.message}');
        }
      )
    );
    staticAd!.load();
  }

   ///function to load inline banner ad
  void loadInlineBannerAd() {
    inlineAd = BannerAd(
        adUnitId: "ca-app-pub-8961859671672268/9925955153",
        size: AdSize.leaderboard,
        request: const AdRequest(),
        listener: BannerAdListener(
            onAdLoaded: (ad) {
                inlineAdLoaded.value = true;
            },
            onAdFailedToLoad: (ad, error){
              ad.dispose();
              debugPrint('ad failed to load ${error.message}');
            }
        )
    );
    inlineAd!.load();
  }

  @override
  void onClose() {
    staticAd?.dispose();
    inlineAd?.dispose();
    nativeAd?.dispose();
    super.onClose();
  }

}