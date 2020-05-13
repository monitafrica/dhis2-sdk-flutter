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
import 'package:dhis2sdk/modules/event/event_adapter.dart';
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
    Gap gap = Gap(event);
    print(gap.gaps);
    expect(gap.gaps, 'Add Assistant Laboratory technologists');
  });
}


