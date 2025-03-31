class Township {
  String name = "";

  Township.defaultTownship();

  Township({required this.name});

  factory Township.fromJson(Map<String, dynamic> json) {
    return Township(name: json['name'] as String);
  }

  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}

class NRC {
  String state = "";
  List<Township> townshipList = [Township.defaultTownship()];

  NRC.defaultNRC();

  NRC({required this.state, required this.townshipList});

  factory NRC.fromJson(Map<String, dynamic> json) {
    var list = json['townshipList'] as List;
    List<Township> townshipList = list.map((data) => Township.fromJson(data)).toList();

    return NRC(
      state: json['state'],
      townshipList: townshipList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state,
      'townshipList': townshipList.map((item) => item.toJson()).toList(),
    };
  }
}