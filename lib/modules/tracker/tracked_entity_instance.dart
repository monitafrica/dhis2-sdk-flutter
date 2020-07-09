
import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/core/utils/date-utils.dart';
import 'package:dhis2sdk/modules/event/event.dart';

@Model
class TrackedEntityInstance {
  @PrimaryKey()
  String trackedEntityInstance;
  String created;
  String orgUnit;
  String createdAtClient;
  String lastUpdated;
  String trackedEntityType;
  String lastUpdatedAtClient;
  bool inactive;
  bool deleted;
  String featureType;

  @Column()
  List<Attribute> attributes;

  @Column()
  List<Enrollment> enrollments;

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
        this.attributes,
        this.enrollments});

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
    if (json['enrollments'] != null) {
      enrollments = new List<Enrollment>();
      json['enrollments'].forEach((v) {
        enrollments.add(new Enrollment.fromJson(v));
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
    if (this.enrollments != null) {
      data['enrollments'] = this.enrollments.map((v) => v.toJson()).toList();
    }
    return data;
  }

  getValue(String attribute){
    if(this.getAttributeValue(attribute) == null){
      return null;
    } else {
      return this.getAttributeValue(attribute).value;
    }
  }

  setValue(String attribute, String value){
    this.setAttribute(Attribute(
      attribute: attribute,
      value: value,
      lastUpdated: getCurrentISODate()
    ));
  }
  Attribute getAttributeValue(String attribute){
    if(this.attributes == null){
      return null;
    }
    List<Attribute> attributes = this.attributes.where((element) => element.attribute == attribute).toList();
    if(attributes.length > 0){
      return attributes.first;
    }else{
      return null;
    }
  }

  setAttribute(Attribute attribute){
    if(this.attributes == null){
      this.attributes = new List<Attribute>();
    }
    if(attribute.value == null){
      this.attributes = this.attributes.where((element) => element.attribute != attribute.attribute).toList();
    }else{
      bool valueExists = false;
      this.attributes.forEach((element) {
        if(element.attribute == attribute.attribute){
          element.lastUpdated = getCurrentISODate();
          element.value = attribute.value;
          valueExists = true;
        }
      });
      if(!valueExists) {
        attribute.created = getCurrentISODate();
        attribute.lastUpdated = getCurrentISODate();
        this.attributes.add(attribute);
      }
    }
  }
  mergeBasedOnLatest(TrackedEntityInstance otherInstance){
    otherInstance.attributes.forEach((otherAttribute) {
      List<Attribute> filteredAttributes = this.attributes.where((attribute) => otherAttribute.attribute == attribute.attribute).toList();
      if(filteredAttributes.length > 0){
        if(!(filteredAttributes[0].lastUpdated.compareTo(otherAttribute.lastUpdated) > -1)){
          filteredAttributes[0].lastUpdated = otherAttribute.lastUpdated;
          filteredAttributes[0].value = otherAttribute.value;
        }
      }else{
        this.attributes.add(otherAttribute);
      }
    });
  }
  TrackedEntityInstance castToTracker(){
    return TrackedEntityInstance.fromJson(this.toJson());
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

@Model
class Enrollment {
  String storedBy;
  String created;
  String orgUnit;
  String createdAtClient;
  String program;
  String trackedEntityInstance;
  String enrollment;
  String lastUpdated;
  String trackedEntityType;
  String lastUpdatedAtClient;
  String orgUnitName;
  String enrollmentDate;
  bool deleted;
  String incidentDate;
  String status;
  Coordinate coordinate;
  Geometry geometry;
  List<Note> notes;

  Enrollment(
      {this.storedBy,
        this.created,
        this.orgUnit,
        this.createdAtClient,
        this.program,
        this.trackedEntityInstance,
        this.enrollment,
        this.lastUpdated,
        this.trackedEntityType,
        this.lastUpdatedAtClient,
        this.orgUnitName,
        this.enrollmentDate,
        this.deleted,
        this.incidentDate,
        this.status,
        this.notes});

  Enrollment.fromJson(Map<String, dynamic> json) {
    storedBy = json['storedBy'];
    created = json['created'];
    orgUnit = json['orgUnit'];
    createdAtClient = json['createdAtClient'];
    program = json['program'];
    trackedEntityInstance = json['trackedEntityInstance'];
    enrollment = json['enrollment'];
    lastUpdated = json['lastUpdated'];
    trackedEntityType = json['trackedEntityType'];
    lastUpdatedAtClient = json['lastUpdatedAtClient'];
    orgUnitName = json['orgUnitName'];
    enrollmentDate = json['enrollmentDate'];
    deleted = json['deleted'];
    incidentDate = json['incidentDate'];
    status = json['status'];
    if (json['notes'] != null) {
      notes = new List<Note>();
      json['notes'].forEach((v) {
        notes.add(new Note.fromJson(v));
      });
    }
    coordinate = json['coordinate'] != null
        ? new Coordinate.fromJson(json['coordinate'])
        : null;
    geometry = json['geometry'] != null
        ? new Geometry.fromJson(json['geometry'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['storedBy'] = this.storedBy;
    data['created'] = this.created;
    data['orgUnit'] = this.orgUnit;
    data['createdAtClient'] = this.createdAtClient;
    data['program'] = this.program;
    data['trackedEntityInstance'] = this.trackedEntityInstance;
    data['enrollment'] = this.enrollment;
    data['lastUpdated'] = this.lastUpdated;
    data['trackedEntityType'] = this.trackedEntityType;
    data['lastUpdatedAtClient'] = this.lastUpdatedAtClient;
    data['orgUnitName'] = this.orgUnitName;
    data['enrollmentDate'] = this.enrollmentDate;
    data['deleted'] = this.deleted;
    data['incidentDate'] = this.incidentDate;
    data['status'] = this.status;
    if (this.notes != null) {
      data['notes'] = this.notes.map((v) => v.toJson()).toList();
    }
    if (this.coordinate != null) {
      data['coordinate'] = this.coordinate.toJson();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    return data;
  }
}

@Model
class Coordinate {
  double latitude;
  double longitude;

  Coordinate({this.latitude, this.longitude});

  Coordinate.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

@Model
class Geometry {
  String type;
  List<dynamic> coordinates;

  Geometry({this.type, this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    if(json['coordinates'] != null){
      coordinates = List<dynamic>.from(json['coordinates']);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['coordinates'] = this.coordinates;
    return data;
  }

  double get latitude{
    if(type == 'Point'){
      return coordinates.elementAt(1);
    }
    return null;
  }

  double get longitude{

    if(type == 'Point'){
      return coordinates.elementAt(0);
    }
    return null;
  }
}

