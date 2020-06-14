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
  test('Testing User', () {

    User user = User.fromJson({"code":"admin","lastUpdated":"2020-01-29T11:23:11.031","id":"M5zQapPyTZI","created":"2020-01-20T09:04:11.006","name":"admin admin","displayName":"admin admin","externalAccess":false,"surname":"admin","firstName":"admin","favorite":false,"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"userCredentials":{"lastUpdated":"2020-01-21T10:21:24.122","id":"KvMx6c1eoYo","created":"2020-01-21T10:21:24.122","name":"admin admin","lastLogin":"2020-03-17T16:15:09.725","displayName":"admin admin","externalAuth":false,"externalAccess":false,"disabled":false,"twoFA":false,"passwordLastUpdated":"2020-01-29T11:23:10.821","invitation":false,"selfRegistered":false,"favorite":false,"username":"admin","userInfo":{"id":"M5zQapPyTZI"},"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"favorites":[],"cogsDimensionConstraints":[],"catDimensionConstraints":[],"translations":[],"userGroupAccesses":[],"attributeValues":[],"userRoles":[{"id":"yrB6vc5Ip3r"}],"userAccesses":[]},"settings":{"keyMessageSmsNotification":true,"keyStyle":"light_blue/light_blue.css","keyUiLocale":"en","keyAnalysisDisplayProperty":"name","keyMessageEmailNotification":true},"favorites":[],"teiSearchOrganisationUnits":[],"translations":[],"organisationUnits":[{"id":"m0frOspS7JY"}],"dataViewOrganisationUnits":[{"id":"m0frOspS7JY"}],"userGroupAccesses":[],"attributeValues":[],"userGroups":[],"userAccesses":[],"authorities":["F_TRACKED_ENTITY_INSTANCE_SEARCH_IN_ALL_ORGUNITS","ALL","F_USERGROUP_MANAGING_RELATIONSHIPS_ADD","F_USER_VIEW","F_GENERATE_MIN_MAX_VALUES","F_ORGANISATIONUNIT_MOVE","F_USER_GROUPS_READ_ONLY_ADD_MEMBERS","F_PREDICTOR_RUN","F_IGNORE_TRACKER_REQUIRED_VALUE_VALIDATION","F_SKIP_DATA_IMPORT_AUDIT","F_RUN_VALIDATION","F_IMPORT_DATA","F_LOCALE_ADD","F_REPLICATE_USER","F_SEND_EMAIL","F_INSERT_CUSTOM_JS_CSS","F_ENROLLMENT_CASCADE_DELETE","F_METADATA_IMPORT","F_EXPORT_EVENTS","F_VIEW_EVENT_ANALYTICS","F_VIEW_UNAPPROVED_DATA","F_IMPORT_EVENTS","F_PERFORM_MAINTENANCE","F_USERGROUP_MANAGING_RELATIONSHIPS_VIEW","F_METADATA_EXPORT","F_TEI_CASCADE_DELETE","F_EXPORT_DATA","F_APPROVE_DATA","F_ACCEPT_DATA_LOWER_LEVELS","F_EDIT_EXPIRED","F_PROGRAM_DASHBOARD_CONFIG_ADMIN","F_APPROVE_DATA_LOWER_LEVELS","F_UNCOMPLETE_EVENT"],"programs":[],"dataSets":["Z8Hz5lc8utD","ZOvFj2vtlor","TfoI3vTGv1f","v6wdME3ouXu","qpcwPcj8D6u"]});
    Map<String, Map<String, dynamic>> userMap = getDBMap<User>(user);
    expect(userMap['user'] != null, true);
    expect(userMap['user']['id'], 'M5zQapPyTZI');

    expect(userMap['user']['userCredentials'] != null, true);
    expect(userMap['user']['userCredentials'] is String, true);

    //expect(userMap['user']['organisationUnits'] != null, true);
    //expect(userMap['user']['organisationUnits'] is String, true);

    Map<String,List<String>> metadata = getTableColumnDefinitions<User>();

    expect(metadata['user']!=null,true);
    expect(metadata['user'].indexOf('id TEXT PRIMARY KEY') > -1,true);
    expect(metadata['user'].indexOf('organisationUnits TEXT') > -1,true);

    User newUser = getObject<User>(user.toJson());
    expect(newUser.organisationUnits.length, 1);
  });
}


