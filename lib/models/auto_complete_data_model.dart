class AutoCompleteDataModel {
  List<Predictions>? predictions;
  String? status;

  AutoCompleteDataModel({this.predictions, this.status});

  AutoCompleteDataModel.fromJson(Map<String, dynamic> json) {
    if (json['predictions'] != null) {
      predictions = <Predictions>[];
      json['predictions'].forEach((v) {
        predictions!.add(Predictions.fromJson(v));
      });
    }
    status = json['status'];
  }
}

class Predictions {
  String? description;
  String? placeId;
  String? reference;

  Predictions({this.description, this.placeId, this.reference});

  Predictions.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    placeId = json['place_id'];
    reference = json['reference'];
  }
}
