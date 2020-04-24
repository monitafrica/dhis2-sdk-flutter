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
  test('Testing Organisation Units', () {

    OrganisationUnit organisationUnit = OrganisationUnit.fromJson({"lastUpdated":"2017-05-22T15:21:48.515","id":"Rp268JB6Ne4","href":"https://play.dhis2.org/2.33.2/api/organisationUnits/Rp268JB6Ne4","level":4,"created":"2012-02-17T15:54:39.987","name":"Adonkia CHP","shortName":"Adonkia CHP","code":"OU_651071","leaf":true,"path":"/ImspTQPwCqd/at6UHUQatSo/qtr8GGlm4gg/Rp268JB6Ne4","favorite":false,"dimensionItemType":"ORGANISATION_UNIT","displayName":"Adonkia CHP","displayShortName":"Adonkia CHP","externalAccess":false,"openingDate":"2010-01-01T00:00:00.000","dimensionItem":"Rp268JB6Ne4","parent":{"id":"qtr8GGlm4gg"},"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"children":[],"translations":[],"ancestors":[{"id":"ImspTQPwCqd"},{"id":"at6UHUQatSo"},{"id":"qtr8GGlm4gg"}],"organisationUnitGroups":[{"id":"f25dqv3Y7Z0"}],"userGroupAccesses":[],"attributeValues":[],"users":[],"userAccesses":[],"dataSets":[{"id":"aLpVgfXiz0f"},{"id":"pBOMPrpg1QX"},{"id":"EKWVBc5C0ms"},{"id":"rsyjyJmYD4J"},{"id":"YFTk3VdO9av"},{"id":"ULowA8V3ucd"},{"id":"QX4ZTUbOt3a"},{"id":"eZDhcZi6FLP"},{"id":"YZhd4nu3mzY"},{"id":"Nyh6laLdBEJ"},{"id":"Y8gAn9DfAGU"},{"id":"V8MHeZHIrcP"},{"id":"Lpw6GcnTrmS"},{"id":"VTdjfLXXmoi"},{"id":"j38YW1Am7he"},{"id":"ce7DSxx5H2I"},{"id":"N4fIX1HL3TQ"},{"id":"SF8FDSqw30D"},{"id":"BfMAe6Itzgt"},{"id":"TuL8IOPzpHh"},{"id":"PLq9sJluXvc"}],"legendSets":[],"programs":[{"id":"q04UBOqq3rp"},{"id":"kla3mAPgvCH"},{"id":"M3xtLkYBlKI"},{"id":"uy2gU8kT1jF"},{"id":"VBqh0ynB2wv"},{"id":"eBAyeGv0exc"},{"id":"qDkgAbB5Jlk"},{"id":"IpHINAT79UW"},{"id":"lxAQ7Zs9VYR"},{"id":"bMcwwoVnbSR"},{"id":"WSGAb5XwJ3Y"},{"id":"ur1Edk5Oe2n"}],"favorites":[]});

    Map<String, Map<String, dynamic>> orgMap = getDBMap<OrganisationUnit>(organisationUnit);
    expect(orgMap['organisationunit'] != null, true);
    expect(orgMap['organisationunit']['parent'], 'qtr8GGlm4gg');

    OrganisationUnit newOrganisationUnit = getObject<OrganisationUnit>(orgMap['organisationunit']);
    expect(newOrganisationUnit.parent.id, 'qtr8GGlm4gg');

    Map<String,List<String>> metadata = getTableColumnDefinitions<OrganisationUnit>();

    expect(metadata['organisationunit']!=null,true);
    expect(metadata['organisationunit'].indexOf('id TEXT PRIMARY KEY') > -1,true);
    expect(metadata['organisationunit'].indexOf('id TEXT') > -1,false);
  });

  test('Testing User', () {

    User user = User.fromJson({"code":"admin","lastUpdated":"2020-01-29T11:23:11.031","id":"M5zQapPyTZI","created":"2020-01-20T09:04:11.006","name":"admin admin","displayName":"admin admin","externalAccess":false,"surname":"admin","firstName":"admin","favorite":false,"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"userCredentials":{"lastUpdated":"2020-01-21T10:21:24.122","id":"KvMx6c1eoYo","created":"2020-01-21T10:21:24.122","name":"admin admin","lastLogin":"2020-03-17T16:15:09.725","displayName":"admin admin","externalAuth":false,"externalAccess":false,"disabled":false,"twoFA":false,"passwordLastUpdated":"2020-01-29T11:23:10.821","invitation":false,"selfRegistered":false,"favorite":false,"username":"admin","userInfo":{"id":"M5zQapPyTZI"},"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"favorites":[],"cogsDimensionConstraints":[],"catDimensionConstraints":[],"translations":[],"userGroupAccesses":[],"attributeValues":[],"userRoles":[{"id":"yrB6vc5Ip3r"}],"userAccesses":[]},"settings":{"keyMessageSmsNotification":true,"keyStyle":"light_blue/light_blue.css","keyUiLocale":"en","keyAnalysisDisplayProperty":"name","keyMessageEmailNotification":true},"favorites":[],"teiSearchOrganisationUnits":[],"translations":[],"organisationUnits":[{"id":"m0frOspS7JY"}],"dataViewOrganisationUnits":[{"id":"m0frOspS7JY"}],"userGroupAccesses":[],"attributeValues":[],"userGroups":[],"userAccesses":[],"authorities":["F_TRACKED_ENTITY_INSTANCE_SEARCH_IN_ALL_ORGUNITS","ALL","F_USERGROUP_MANAGING_RELATIONSHIPS_ADD","F_USER_VIEW","F_GENERATE_MIN_MAX_VALUES","F_ORGANISATIONUNIT_MOVE","F_USER_GROUPS_READ_ONLY_ADD_MEMBERS","F_PREDICTOR_RUN","F_IGNORE_TRACKER_REQUIRED_VALUE_VALIDATION","F_SKIP_DATA_IMPORT_AUDIT","F_RUN_VALIDATION","F_IMPORT_DATA","F_LOCALE_ADD","F_REPLICATE_USER","F_SEND_EMAIL","F_INSERT_CUSTOM_JS_CSS","F_ENROLLMENT_CASCADE_DELETE","F_METADATA_IMPORT","F_EXPORT_EVENTS","F_VIEW_EVENT_ANALYTICS","F_VIEW_UNAPPROVED_DATA","F_IMPORT_EVENTS","F_PERFORM_MAINTENANCE","F_USERGROUP_MANAGING_RELATIONSHIPS_VIEW","F_METADATA_EXPORT","F_TEI_CASCADE_DELETE","F_EXPORT_DATA","F_APPROVE_DATA","F_ACCEPT_DATA_LOWER_LEVELS","F_EDIT_EXPIRED","F_PROGRAM_DASHBOARD_CONFIG_ADMIN","F_APPROVE_DATA_LOWER_LEVELS","F_UNCOMPLETE_EVENT"],"programs":[],"dataSets":["Z8Hz5lc8utD","ZOvFj2vtlor","TfoI3vTGv1f","v6wdME3ouXu","qpcwPcj8D6u"]});
    Map<String, Map<String, dynamic>> userMap = getDBMap<User>(user);
    expect(userMap['user'] != null, true);
    expect(userMap['user']['id'], 'M5zQapPyTZI');

    expect(userMap['usercredentials'] != null, true);

    expect(userMap['user']['organisationUnits'] != null, true);
    expect(userMap['user']['organisationUnits'] is String, true);

    Map<String,List<String>> metadata = getTableColumnDefinitions<User>();

    expect(metadata['user']!=null,true);
    expect(metadata['usercredentials']!=null,true);
    expect(metadata['user'].indexOf('id TEXT PRIMARY KEY') > -1,true);
    expect(metadata['user'].indexOf('organisationUnits TEXT') > -1,true);

    User newUser = getObject<User>(user.toJson());
    expect(newUser.organisationUnits.length, 1);
  });
  test('Testing Event', () {

    Event event = Event.fromJson({"href":"https://dhis.facility.monitafrica.com/api/events/b69iTUNdsTB","event":"b69iTUNdsTB","status":"COMPLETED","program":"iRAGY1xYrFk","programStage":"jJnYXM8rbGL","enrollment":"kVCoqKLulZh","enrollmentStatus":"ACTIVE","orgUnit":"VN8Jjz61jOE","orgUnitName":"Aar Health Center","trackedEntityInstance":"plrwsnAipA7","eventDate":"2020-04-03T00:00:00.000","dueDate":"2020-04-03T00:00:00.000","storedBy":"admin","dataValues":[{"created":"2020-04-03T13:46:59.467","lastUpdated":"2020-04-03T13:48:08.586","value":"Add Assistant Laboratory technologists","dataElement":"LkcOeGmoiFv","providedElsewhere":false,"storedBy":"admin"},{"created":"2020-04-03T13:47:43.547","lastUpdated":"2020-04-03T13:48:08.586","value":"High","dataElement":"YVCAlkFbc9k","providedElsewhere":false,"storedBy":"admin"},{"created":"2020-04-03T13:47:38.065","lastUpdated":"2020-04-03T13:48:08.586","value":"Limited number of allocated assistant laboratory technologists","dataElement":"EBHn9DmnjHy","providedElsewhere":false,"storedBy":"admin"}],"deleted":false,"created":"2020-04-03T13:41:25.136","lastUpdated":"2020-04-03T13:48:08.587","createdAtClient":"2020-04-03T13:41:25.136","lastUpdatedAtClient":"2020-04-03T13:48:08.587","attributeOptionCombo":"HllvX50cXC0","attributeCategoryOptions":"xYerKDKCefk","completedBy":"admin","completedDate":"2020-04-03T00:00:00.000"});
    Map<String, Map<String, dynamic>> userMap = getDBMap<Event>(event);
    expect(userMap['event'] != null, true);

    expect(userMap['event']['dataValues'] != null, true);
    expect(userMap['event']['dataValues'].runtimeType, String);
    print(jsonDecode(userMap['event']['dataValues']).runtimeType);
    expect(jsonDecode(userMap['event']['dataValues']).runtimeType, (List<dynamic>()).runtimeType);

    Map<String,List<String>> metadata = getTableColumnDefinitions<Event>();

    expect(metadata['event']!=null,true);
    expect(metadata['event'].indexOf('dataValues TEXT') > -1,true);

    Event newEvent = Event.fromJson(userMap['event']);

    expect(newEvent.dataValues != null, true);
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


