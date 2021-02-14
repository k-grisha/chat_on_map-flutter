class MapPoint {
  String uuid;
  String name;
  Sex sex;

  MapPoint(this.uuid, {this.name, this.sex = Sex.NONE});
}

enum Sex { MAN, FEMALE, NONE }
