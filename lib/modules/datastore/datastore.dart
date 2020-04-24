
import 'package:dhis2sdk/core/model.dart';

@Model
class DataStore implements ModelInterface{
  String created;
  String lastUpdated;
  bool externalAccess;
  String namespace;
  String key;
  String value;
  bool favorite;
  String id;

  DataStore(
      {this.created,
        this.lastUpdated,
        this.externalAccess,
        this.namespace,
        this.key,
        this.value,
        this.favorite,
        this.id});

  DataStore.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    lastUpdated = json['lastUpdated'];
    externalAccess = json['externalAccess'];
    namespace = json['namespace'];
    key = json['key'];
    value = json['value'];
    favorite = json['favorite'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['lastUpdated'] = this.lastUpdated;
    data['externalAccess'] = this.externalAccess;
    data['namespace'] = this.namespace;
    data['key'] = this.key;
    data['value'] = this.value;
    data['favorite'] = this.favorite;
    data['id'] = this.id;
    return data;
  }
}
