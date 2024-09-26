class MustEat {
  int? seq;
  String userId;
  String name;
  String address;
  double longtitude;
  double latitude;
  String? image;
  String review;
  double rankPoint;

  MustEat({
    this.seq,
    required this.userId,
    required this.name,
    required this.address,
    required this.longtitude,
    required this.latitude,
    this.image,
    required this.review,
    required this.rankPoint,
  });

  MustEat.fromlist(List<dynamic> res)
      : seq = res[0],
        userId = res[1],
        name = res[2],
        address = res[3],
        longtitude = res[4],
        latitude = res[5],
        image = res[6],
        review = res[7],
        rankPoint = res[8];
}
