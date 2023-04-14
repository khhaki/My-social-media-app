class AppwriteConstants {
  static const String databaseId = "6432173709f46f7e5537";
  static const String projectId = "6432109a594854041278";
  static const String endPoint = "http://192.168.1.2/v1";
  static const String usercollection = "6434ca1c663bd519e12b";
  static const String tweetscollection = "643840fc2e6063696dc6";
  static const String imagesBacket = "643985c4410589985fff";
  static String imageUrl(String imageId) =>
      'http://192.168.1.2/v1/storage/buckets/643985c4410589985fff/files/$imageId/view?project=6432109a594854041278&mode=admin';
}
