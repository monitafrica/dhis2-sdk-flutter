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

void main() {

  //TestWidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();
  test('Testing Event', () {

    Event event = Event.fromJson({"href":"https://dhis.facility.monitafrica.com/api/events/b69iTUNdsTB","event":"b69iTUNdsTB","status":"COMPLETED","program":"iRAGY1xYrFk","programStage":"jJnYXM8rbGL","enrollment":"kVCoqKLulZh","enrollmentStatus":"ACTIVE","orgUnit":"VN8Jjz61jOE","orgUnitName":"Aar Health Center","trackedEntityInstance":"plrwsnAipA7","eventDate":"2020-04-03T00:00:00.000","dueDate":"2020-04-03T00:00:00.000","storedBy":"admin","dataValues":[{"created":"2020-04-03T13:46:59.467","lastUpdated":"2020-04-03T13:48:08.586","value":"Add Assistant Laboratory technologists","dataElement":"LkcOeGmoiFv","providedElsewhere":false,"storedBy":"admin"},{"created":"2020-04-03T13:47:43.547","lastUpdated":"2020-04-03T13:48:08.586","value":"High","dataElement":"YVCAlkFbc9k","providedElsewhere":false,"storedBy":"admin"},{"created":"2020-04-03T13:47:38.065","lastUpdated":"2020-04-03T13:48:08.586","value":"Limited number of allocated assistant laboratory technologists","dataElement":"EBHn9DmnjHy","providedElsewhere":false,"storedBy":"admin"}],"deleted":false,"created":"2020-04-03T13:41:25.136","lastUpdated":"2020-04-03T13:48:08.587","createdAtClient":"2020-04-03T13:41:25.136","lastUpdatedAtClient":"2020-04-03T13:48:08.587","attributeOptionCombo":"HllvX50cXC0","attributeCategoryOptions":"xYerKDKCefk","completedBy":"admin","completedDate":"2020-04-03T00:00:00.000"});
    Map<String, Map<String, dynamic>> userMap = getDBMap<Event>(event);
    expect(userMap['event'] != null, true);

    expect(userMap['event']['dataValues'] != null, true);
    expect(userMap['event']['dataValues'].runtimeType, String);

    Map<String,List<String>> metadata = getTableColumnDefinitions<Event>();

    expect(metadata['event']!=null,true);
    expect(metadata['event'].indexOf('dataValues TEXT') > -1,true);
    expect(metadata['event'].indexOf('event TEXT PRIMARY KEY') > -1,true);

    Event newEvent = Event.fromJson(userMap['event']);

    expect(newEvent.dataValues != null, true);
  });

  test('Testing Event With Coordinates', () {

    Event event = Event.fromJson({"href":"https://dhis.facility.monitafrica.com/api/events/HQ83CnGtzsi","event":"HQ83CnGtzsi","status":"ACTIVE","program":"iRAGY1xYrFk","programStage":"pZzz8OFJs3w","enrollment":"HSNOkXVN8Jj","enrollmentStatus":"ACTIVE","orgUnit":"VN8Jjz61jOE","orgUnitName":"Aar Health Center","trackedEntityInstance":"HSNOkXVN8Jj","eventDate":"2020-06-10T11:37:35.671","dueDate":"2020-06-10T10:09:21.310","storedBy":"system","dataValues":[{"created":"2020-06-10T08:47:55.374","lastUpdated":"2020-06-10T10:09:21.313","value":"kyz1pUOeNgl","dataElement":"p5SW0c7a8Ka","providedElsewhere":false,"storedBy":"system"},{"created":"2020-06-10T08:47:55.374","lastUpdated":"2020-06-10T10:09:21.313","value":"Yes","dataElement":"xQDDu6SRUi3","providedElsewhere":false,"storedBy":"system"},{"created":"2020-06-10T08:47:55.374","lastUpdated":"2020-06-10T10:09:21.313","value":"DQN00000413","dataElement":"CtJOnujenbE","providedElsewhere":false,"storedBy":"system"},{"created":"2020-06-10T08:47:55.374","lastUpdated":"2020-06-10T10:09:21.313","value":"Do the health service providers assess each woman on arrival and record findings accurately and with completeness ?","dataElement":"kk5V5AUgCcC","providedElsewhere":false,"storedBy":"system"},{"created":null,"lastUpdated":null,"value":"jAR8o5Yp7vW","dataElement":"XhtBxHc8OrO","providedElsewhere":null,"storedBy":null}],"notes":[],"geometry":{"type":"Point","coordinates":[-122.084,37.4219983]},"coordinate":{"latitude":37.4219983,"longitude":-122.084},"deleted":false,"created":"2020-06-10T08:47:55.204","lastUpdated":"2020-06-10T10:09:21.314","createdAtClient":null,"lastUpdatedAtClient":null,"attributeOptionCombo":"HllvX50cXC0","attributeCategoryOptions":"xYerKDKCefk","completedBy":null,"completedDate":null});
    expect(event.geometry != null, true);
    expect(event.geometry.type, 'Point');
    expect(event.geometry.coordinates != null, true);
    expect(event.geometry.coordinates.length, 2);
    expect(event.geometry.coordinates.elementAt(0), -122.084);
    expect(event.geometry.coordinates.elementAt(1), 37.4219983);

    expect(event.coordinate != null, true);
    expect(event.coordinate.longitude != null, true);
    expect(event.coordinate.latitude != null, true);

    expect(event.coordinate.longitude, -122.084);
    expect(event.coordinate.latitude, 37.4219983);

    Map<String, Map<String, dynamic>> userMap = getDBMap<Event>(event);

    expect(userMap['event'] != null, true);

    expect(userMap['event']['geometry'] != null, true);
    expect(userMap['event']['geometry'] is String, true);


    expect(userMap['event']['coordinate'] != null, true);
    expect(userMap['event']['coordinate'] is String, true);

  });
}


