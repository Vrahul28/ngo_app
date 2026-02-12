class Urls {
  static const baseUrl= 'https://unbountiful-opposable-otelia.ngrok-free.dev';
  static const String signUpAPI= '$baseUrl/api/Auth/signup';
  static const String verifyEmailAPI= '$baseUrl/api/Auth/verify-email';
  static const String resendOTPAPI= '$baseUrl/api/Auth/resend-otp';
  static const String signInAPI= '$baseUrl/api/Auth/login';
  static const String resetPasswordAPI= '$baseUrl/api/Auth/reset-password';
  static const String resetOTPAPI= '$baseUrl/api/Auth/verify-reset-otp';
  static const String forgetPassAPI= '$baseUrl/api/Auth/forgot-password';
  static const String allMemberAPI= '$baseUrl/api/admin/users';
  static const String countMemberAPI= '$baseUrl/api/Admin/count';
  static const String totalDonationAPI= '$baseUrl/api/PaymentData/total/me';
  static const String paymentHistoryForUserAPI= '$baseUrl/api/PaymentData/list';
  static const String refreshTokenAPI= '$baseUrl/api/Auth/refresh';
  static const String logoutAPI= '$baseUrl/api/Auth/logout';
  //Donation
  static const String createOrderAPI= '$baseUrl/api/donation/create-order';
  static const String verifyPaymentAPI= '$baseUrl/api/donation/verify';
  //Add Member By Admin
  static const String addMemberByAdminAPI= '$baseUrl/api/Admin/by-number';
  static const String addDonationByAdminAPI= '$baseUrl/api/campaign/add-donationManually';
  static const String paymentHistoryForAdminAPI= '$baseUrl/api/PaymentData/admin/list';
  //Campaign
  static const String addCampaignAPI= '$baseUrl/api/campaign/add';
  static const String editCampaignAPI= '$baseUrl/api/campaign/edit';
  static const String deleteCampaignAPI= '$baseUrl/api/campaign/delete';
  static const String getAllCampaignAPI= '$baseUrl/api/campaign/active';
  static const String getAllUserCampaignAPI= '$baseUrl/api/campaign/list';
}