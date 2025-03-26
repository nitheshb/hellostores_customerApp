class ReviewRequestModel {
  final int? shopId;
  final int? blogId;
  final int? driverId;
  final String? productUuid;
  final int? page;

  ReviewRequestModel(
      {required this.shopId,
      required this.blogId,
      required this.driverId,
      required this.productUuid,
      required this.page});

  factory ReviewRequestModel.fromJson({
    int? shopId,
    int? blogId,
    int? driverId,
    String? productUuid,
    int? page,
  }) {
    return ReviewRequestModel(
        shopId: shopId,
        blogId: blogId,
        driverId: driverId,
        productUuid: productUuid,
        page: page);
  }
}
