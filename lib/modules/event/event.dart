import 'dart:convert';

import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/core/utils/date-utils.dart';
import 'package:dhis2sdk/modules/tracker/tracked_entity_instance.dart';

@Model
class Event {
  @PrimaryKey()
  String event;
  String href;
  String status;
  String program;
  String programStage;
  String enrollment;
  String enrollmentStatus;
  String orgUnit;
  String orgUnitName;
  String trackedEntityInstance;
  String eventDate;
  String dueDate;
  String storedBy;
  @Column()
  List<DataValue> dataValues;
  @Column()
  List<Note> notes;
  bool deleted;
  String created;
  String lastUpdated;
  String createdAtClient;
  String lastUpdatedAtClient;
  String attributeOptionCombo;
  String attributeCategoryOptions;
  String completedBy;
  String completedDate;
  @Column()
  Coordinate coordinate;
  @Column()
  Geometry geometry;

  Event(
      {this.href,
        this.event,
        this.status,
        this.program,
        this.programStage,
        this.enrollment,
        this.enrollmentStatus,
        this.orgUnit,
        this.orgUnitName,
        this.trackedEntityInstance,
        this.eventDate,
        this.dueDate,
        this.storedBy,
        this.dataValues,
        this.notes,
        this.deleted,
        this.created,
        this.lastUpdated,
        this.createdAtClient,
        this.lastUpdatedAtClient,
        this.attributeOptionCombo,
        this.attributeCategoryOptions,
        this.completedBy,
        this.completedDate});

  Event.fromJson(Map<String, dynamic> json) {
    href = json['href'];
    event = json['event'];
    status = json['status'];
    program = json['program'];
    programStage = json['programStage'];
    enrollment = json['enrollment'];
    enrollmentStatus = json['enrollmentStatus'];
    orgUnit = json['orgUnit'];
    orgUnitName = json['orgUnitName'];
    trackedEntityInstance = json['trackedEntityInstance'];
    eventDate = json['eventDate'];
    dueDate = json['dueDate'];
    storedBy = json['storedBy'];
    if (json['dataValues'] != null) {
      if(json['dataValues'].runtimeType == String){
        json['dataValues'] = jsonDecode(json['dataValues']);
      }
      dataValues = List<DataValue>();
      json['dataValues'].forEach((v) {
        dataValues.add(new DataValue.fromJson(v));
      });
    }
    if (json['notes'] != null) {
      if(json['notes'].runtimeType == String){
        json['notes'] = jsonDecode(json['notes']);
      }
      notes = new List<Note>();
      json['notes'].forEach((v) {
        notes.add(new Note.fromJson(v));
      });
    }
    if (json['geometry'] != null) {
      geometry = Geometry.fromJson(json['geometry']);
    }
    if (json['coordinate'] != null) {
      coordinate = Coordinate.fromJson(json['coordinate']);
    }
    deleted = json['deleted'];
    created = json['created'];
    lastUpdated = json['lastUpdated'];
    createdAtClient = json['createdAtClient'];
    lastUpdatedAtClient = json['lastUpdatedAtClient'];
    attributeOptionCombo = json['attributeOptionCombo'];
    attributeCategoryOptions = json['attributeCategoryOptions'];
    completedBy = json['completedBy'];
    completedDate = json['completedDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['href'] = this.href;
    data['event'] = this.event;
    data['status'] = this.status;
    data['program'] = this.program;
    data['programStage'] = this.programStage;
    data['enrollment'] = this.enrollment;
    data['enrollmentStatus'] = this.enrollmentStatus;
    data['orgUnit'] = this.orgUnit;
    data['orgUnitName'] = this.orgUnitName;
    data['trackedEntityInstance'] = this.trackedEntityInstance;
    data['eventDate'] = this.eventDate;
    data['dueDate'] = this.dueDate;
    data['storedBy'] = this.storedBy;
    if (this.dataValues != null) {
      data['dataValues'] = this.dataValues.map((v) => v.toJson()).toList();
    }
    if (this.notes != null) {
      data['notes'] = this.notes.map((v) => v.toJson()).toList();
    }
    if (this.geometry != null) {
      data['geometry'] = this.geometry.toJson();
    }
    if (this.coordinate != null) {
      data['coordinate'] = this.coordinate.toJson();
    }
    data['deleted'] = this.deleted;
    data['created'] = this.created;
    data['lastUpdated'] = this.lastUpdated;
    data['createdAtClient'] = this.createdAtClient;
    data['lastUpdatedAtClient'] = this.lastUpdatedAtClient;
    data['attributeOptionCombo'] = this.attributeOptionCombo;
    data['attributeCategoryOptions'] = this.attributeCategoryOptions;
    data['completedBy'] = this.completedBy;
    data['completedDate'] = this.completedDate;
    return data;
  }

  Event castToEvent(){
    return Event.fromJson(this.toJson());
  }
  getValue(String dataElement){
    if(getDataValue(dataElement) != null){
      return getDataValue(dataElement).value;
    }else{
      return null;
    }
  }

  setValue(String dataElement, String value){
    setDataValue(DataValue(
      dataElement: dataElement,
      value: value
    ));
  }

  DataValue getDataValue(String dataElement){
    if(this.dataValues == null){
      return null;
    }
    List<DataValue> dataValues = this.dataValues.where((element) => element.dataElement == dataElement).toList();
    if(dataValues.length > 0){
      return dataValues[0];
    }else{
      return null;
    }
  }

  setDataValue(DataValue dataValue){
    if(this.dataValues == null){
      this.dataValues = new List<DataValue>();
    }
    if(dataValue.value == null){
      this.dataValues = this.dataValues.where((element) => element.dataElement != dataValue.dataElement).toList();
    }else{
      bool valueExists = false;
      this.dataValues.forEach((element) {
        if(element.dataElement == dataValue.dataElement){
          element.lastUpdated = getCurrentISODate();
          element.value = dataValue.value;
          valueExists = true;
        }
      });
      if(!valueExists){
        dataValue.created = getCurrentISODate();
        dataValue.lastUpdated = getCurrentISODate();
        this.dataValues.add(dataValue);
      }
    }
  }
  mergeBasedOnLatest(Event otherEvent){
    if(!(lastUpdated.compareTo(otherEvent.lastUpdated) > -1)){
      status = otherEvent.status;
    }
    otherEvent.dataValues.forEach((otherDataValue) {
      List<DataValue> filteredDataValues = this.dataValues.where((dataValue) => otherDataValue.dataElement == dataValue.dataElement).toList();
      if(filteredDataValues.length > 0){
        String onlineD = otherDataValue.lastUpdated;
        int fIndex = onlineD.length -1;
        if(onlineD[fIndex] != 'Z') {
          onlineD += 'Z';
        }
        final DateTime localLastUpdated = DateTime.parse(filteredDataValues[0].lastUpdated);
        final DateTime onlineLastUpdated = DateTime.parse(onlineD);
        if(onlineLastUpdated.isAfter(localLastUpdated)) {
          filteredDataValues[0].lastUpdated = otherDataValue.lastUpdated;
          filteredDataValues[0].value = otherDataValue.value;
        }
      }else{
        this.dataValues.add(otherDataValue);
      }
    });
  }
  bool sameAs(Event otherEvent){
    return this.event == otherEvent.event;
  }
}

@Model
class DataValue {
  String created;
  String lastUpdated;
  String value;
  String dataElement;
  bool providedElsewhere;
  String storedBy;

  DataValue(
      {this.created,
        this.lastUpdated,
        this.value,
        this.dataElement,
        this.providedElsewhere,
        this.storedBy});

  DataValue.fromJson(Map<String, dynamic> json) {
    created = json['created'];
    lastUpdated = json['lastUpdated'];
    value = json['value'];
    dataElement = json['dataElement'];
    providedElsewhere = json['providedElsewhere'];
    storedBy = json['storedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created'] = this.created;
    data['lastUpdated'] = this.lastUpdated;
    data['value'] = this.value;
    data['dataElement'] = this.dataElement;
    data['providedElsewhere'] = this.providedElsewhere;
    data['storedBy'] = this.storedBy;
    return data;
  }
}

@Model
class Note {
  String note;
  String storedDate;
  String storedBy;
  String value;

  Note({this.note, this.storedDate, this.storedBy, this.value});

  Note.fromJson(Map<String, dynamic> json) {
    note = json['note'];
    storedDate = json['storedDate'];
    storedBy = json['storedBy'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['note'] = this.note;
    data['storedDate'] = this.storedDate;
    data['storedBy'] = this.storedBy;
    data['value'] = this.value;
    return data;
  }
}
