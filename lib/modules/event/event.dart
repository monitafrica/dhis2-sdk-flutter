import 'dart:convert';

import 'package:dhis2sdk/core/model.dart';

@Model
class Event {
  String href;
  String event;
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
      dataValues = new List<DataValue>();
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
  getValue(String dataElement){
    if(this.dataValues == null){
      return null;
    }
    List<DataValue> dataValues = this.dataValues.where((element) => element.dataElement == dataElement).toList();
    if(dataValues.length > 0){
      return dataValues[0].value;
    }else{
      return null;
    }
  }

  setValue(String dataElement, String value){
    if(this.dataValues == null){
      this.dataValues = new List<DataValue>();
    }
    bool valueExists = false;
    this.dataValues.forEach((element) {
      if(element.dataElement == dataElement){
        element.value = value;
        valueExists = true;
      }
    });
    if(!valueExists){
      this.dataValues.add(DataValue(dataElement: dataElement, value: value));
    }
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
  String value;

  Note({this.value});

  Note.fromJson(Map<String, dynamic> json) {
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['value'] = this.value;
    return data;
  }
}
