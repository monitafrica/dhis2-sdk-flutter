import 'dart:convert';

import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/http_provider.dart';
import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/core/query_builder.dart';
import 'package:dhis2sdk/modules/datastore/datastore.dart';
import 'package:dhis2sdk/modules/datastore/datastore_model_adapter.dart';
import 'package:dhis2sdk/modules/datastore/datastore_provider.dart';
import 'package:dhis2sdk/modules/event/event.dart';
import 'package:dhis2sdk/modules/organisation_unit/organisation_unit.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:dhis2sdk/modules/user/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectable/reflectable.dart';

import 'dhis2sdk_test.reflectable.dart';

@Model
class Questionnaire{
  static final String namespace = 'questionnaires';
  String id;
  String title;
  List<Section> sections;
  String description;

  Questionnaire.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['sections'] != null) {
      sections = new List<Section>();
      json['sections'].forEach((v) {
        sections.add(new Section.fromJson(v));
      });
    }
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.sections != null) {
      data['sections'] = this.sections.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    return data;
  }
}

@Model
class Section {
  String id;
  String title;
  List<Section> subSections;

  Section({this.id, this.title, this.subSections});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    if (json['subSections'] != null) {
      subSections = new List<Section>();
      json['subSections'].forEach((v) {
        subSections.add(new Section.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    if (this.subSections != null) {
      data['subSections'] = this.subSections.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

void main() {

  //TestWidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();
  test('Testing Fetching Data Store', () async {

    //await DHIS2.login(Credential(url:'https://dhis.facility.monitafrica.com',username: 'admin',password: 'StrongPass@2020'));
  });

  test('Testing DataStore', () {

    DataStore dataStore = DataStore.fromJson({"created":"2020-04-08T02:30:57.844","lastUpdated":"2020-04-08T02:51:23.194","externalAccess":false,"publicAccess":"rw------","user":{"code":"admin","name":"admin admin","created":"2020-01-20T09:04:11.006","lastUpdated":"2020-04-08T13:14:17.176","externalAccess":false,"displayName":"admin admin","favorite":false,"id":"M5zQapPyTZI"},"lastUpdatedBy":{"id":"M5zQapPyTZI","name":"admin admin"},"namespace":"actionPoints","key":"Fl81oO5RQJN","value":"{\"id\": \"Fl81oO5RQJN\", \"name\": \"Hire more medical staff\", \"status\": \"Active\", \"healthAreaIds\": [\"tQAQAUjlL0i\"], \"questionTypeId\": \"xsHhxGIhGCb\", \"technicalAreaIds\": [\"uddmevCi0O5\"]}","favorite":false,"id":"UQwDX7c88fF"});

  });
  test('Testing Query Builder', () {

    QueryBuilder queryBuilder = QueryBuilder();

    queryBuilder.filter(Filter(left:"parent",operator: 'null'));
    SelectQuery structure = queryBuilder.getQueryStructure();
    expect(structure.where[0], 'parent is null');

    queryBuilder = QueryBuilder();

    queryBuilder.filter(Filter(left:"parent",operator: '=', right:'theID'));
    structure = queryBuilder.getQueryStructure();
    expect(structure.where[0], "parent = 'theID'");

    queryBuilder.filter(Filter(left:"parent",operator: '=', right:3));
    structure = queryBuilder.getQueryStructure();
    expect(structure.where[0], "parent = 'theID'");

  });
  test('Test Data Store Model Reflection',(){
    Questionnaire questionnaire = getObject<Questionnaire>({"id": "nRSAEAkfXdt", "title": "Example Questionnaire", "sections": [{"id": "ccAFCwkYU0M", "title": "Title one", "questions": [{"id": "", "code": "", "title": "Example Question", "status": "Active", "answerType": "TEXT", "generality": "Detailed", "indicators": [{"id": "tKALVlJRdGr", "name": "CYP Condoms"}, {"id": "MPBNuSP3NN0", "name": "Contraceptive Coverage - Modern Methods"}, {"id": "OVd3QGXl5dE", "name": "FP HIV Testing Rate"}, {"id": "fs1U513HkOa", "name": "FP New client rate"}], "facilityType": [], "healthAreaIds": ["EfANTEeYEAv"], "questionTypeId": "oLfTRHFEG8a", "technicalAreaIds": ["GNygmsc2e74"], "verificationMethod": ""}], "subSections": []}], "description": "MOre about example questionaire"});
    expect(questionnaire.sections != null,true);

  });
}


