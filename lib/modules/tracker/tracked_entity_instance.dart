
import 'package:dhis2sdk/core/model.dart';

@Model
class TrackedEntityInstance {
  String created;
  String orgUnit;
  String createdAtClient;
  String trackedEntityInstance;
  String lastUpdated;
  String trackedEntityType;
  String lastUpdatedAtClient;
  bool inactive;
  bool deleted;
  String featureType;

  @Column()
  List<Attribute> attributes;

  TrackedEntityInstance(
      {this.created,
        this.orgUnit,
        this.createdAtClient,
        this.trackedEntityInstance,
        this.lastUpdated,
        this.trackedEntityType,
        this.lastUpdatedAtClient,
        this.inactive,
        this.deleted,
        this.featureType,
        this.attributes});

  TrackedEntityInstance.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    orgUnit = json['orgUnit'];
    createdAtClient = json['createdAtClient'];
    trackedEntityInstance = json['trackedEntityInstance'];
    lastUpdated = json['lastUpdated'];
    trackedEntityType = json['trackedEntityType'];
    lastUpdatedAtClient = json['lastUpdatedAtClient'];
    inactive = json['inactive'];
    deleted = json['deleted'];
    featureType = json['featureType'];
    if (json['attributes'] != null) {
      attributes = new List<Attribute>();
      json['attributes'].forEach((v) {
        attributes.add(new Attribute.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['orgUnit'] = this.orgUnit;
    data['createdAtClient'] = this.createdAtClient;
    data['trackedEntityInstance'] = this.trackedEntityInstance;
    data['lastUpdated'] = this.lastUpdated;
    data['trackedEntityType'] = this.trackedEntityType;
    data['lastUpdatedAtClient'] = this.lastUpdatedAtClient;
    data['inactive'] = this.inactive;
    data['deleted'] = this.deleted;
    data['featureType'] = this.featureType;
    if (this.attributes != null) {
      data['attributes'] = this.attributes.map((v) => v.toJson()).toList();
    }
    return data;
  }

  getValue(String attribute){
    if(this.attributes == null){
      return null;
    }
    List<Attribute> attributes = this.attributes.where((element) => element.attribute == attribute).toList();
    if(attributes.length > 0){
      return attributes.first.value;
    }else{
      return null;
    }
  }

  setValue(String attribute, String value){
    if(this.attributes == null){
      this.attributes = new List<Attribute>();
    }
    bool valueExists = false;
    this.attributes.forEach((element) {
      if(element.attribute == attribute){
        element.value = value;
        valueExists = true;
      }
    });
    if(!valueExists){
      this.attributes.add(Attribute(attribute: attribute, value: value));
    }
  }
}

@Model
class Attribute {
  String lastUpdated;
  String storedBy;
  String displayName;
  String created;
  String valueType;
  String attribute;
  String value;

  Attribute(
      {this.lastUpdated,
        this.storedBy,
        this.displayName,
        this.created,
        this.valueType,
        this.attribute,
        this.value});

  Attribute.fromJson(Map<String, dynamic> json) {
    lastUpdated = json['lastUpdated'];
    storedBy = json['storedBy'];
    displayName = json['displayName'];
    created = json['created'];
    valueType = json['valueType'];
    attribute = json['attribute'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdated'] = this.lastUpdated;
    data['storedBy'] = this.storedBy;
    data['displayName'] = this.displayName;
    data['created'] = this.created;
    data['valueType'] = this.valueType;
    data['attribute'] = this.attribute;
    data['value'] = this.value;
    return data;
  }
}
