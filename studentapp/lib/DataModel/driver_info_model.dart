class DriverInfoModel {
  String name;
  String yearsOfExpr;
  String busNumber;
  String workLocation;
  String driverPhoto;

  DriverInfoModel(
      {this.name,
      this.busNumber,
      this.workLocation,
      this.yearsOfExpr,
      this.driverPhoto});
}

final List<DriverInfoModel> driverInfoList = [
  DriverInfoModel(
      name: "Jama Ahmed",
      yearsOfExpr: "5",
      busNumber: "9868",
      workLocation: "Madiino",
      driverPhoto:
          "https://www.splend.com.au/wp-content/uploads/2018/11/five-star-uber-driver.jpg"),
  DriverInfoModel(
      name: "ahmed m",
      yearsOfExpr: "5",
      busNumber: "5666",
      workLocation: "Madiino",
      driverPhoto:
          "https://ak.picdn.net/shutterstock/videos/18777602/thumb/1.jpg"),
  DriverInfoModel(
      name: "jilibo hebl",
      yearsOfExpr: "5",
      busNumber: "1243",
      workLocation: "Madiino",
      driverPhoto: "https://vistapointe.net/images/driver-wallpaper-1.jpg"),
  DriverInfoModel(
      name: "khalid kabo",
      yearsOfExpr: "5",
      busNumber: "5467",
      workLocation: "Madiino",
      driverPhoto:
          "https://zendrive.com/wp-content/uploads/2016/08/uber-driver.jpg"),
];
