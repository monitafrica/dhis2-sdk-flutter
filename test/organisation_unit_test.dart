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
  test('Testing Organisation Units', () {

    OrganisationUnit organisationUnit = OrganisationUnit.fromJson({"lastUpdated":"2017-05-22T15:21:48.515","id":"Rp268JB6Ne4","href":"https://play.dhis2.org/2.33.2/api/organisationUnits/Rp268JB6Ne4","level":4,"created":"2012-02-17T15:54:39.987","name":"Adonkia CHP","shortName":"Adonkia CHP","code":"OU_651071","leaf":true,"path":"/ImspTQPwCqd/at6UHUQatSo/qtr8GGlm4gg/Rp268JB6Ne4","favorite":false,"dimensionItemType":"ORGANISATION_UNIT","displayName":"Adonkia CHP","displayShortName":"Adonkia CHP","externalAccess":false,"openingDate":"2010-01-01T00:00:00.000","dimensionItem":"Rp268JB6Ne4","parent":{"id":"qtr8GGlm4gg"},"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"children":[],"translations":[],"ancestors":[{"id":"ImspTQPwCqd"},{"id":"at6UHUQatSo"},{"id":"qtr8GGlm4gg"}],"organisationUnitGroups":[{"id":"f25dqv3Y7Z0"}],"userGroupAccesses":[],"attributeValues":[],"users":[],"userAccesses":[],"dataSets":[{"id":"aLpVgfXiz0f"},{"id":"pBOMPrpg1QX"},{"id":"EKWVBc5C0ms"},{"id":"rsyjyJmYD4J"},{"id":"YFTk3VdO9av"},{"id":"ULowA8V3ucd"},{"id":"QX4ZTUbOt3a"},{"id":"eZDhcZi6FLP"},{"id":"YZhd4nu3mzY"},{"id":"Nyh6laLdBEJ"},{"id":"Y8gAn9DfAGU"},{"id":"V8MHeZHIrcP"},{"id":"Lpw6GcnTrmS"},{"id":"VTdjfLXXmoi"},{"id":"j38YW1Am7he"},{"id":"ce7DSxx5H2I"},{"id":"N4fIX1HL3TQ"},{"id":"SF8FDSqw30D"},{"id":"BfMAe6Itzgt"},{"id":"TuL8IOPzpHh"},{"id":"PLq9sJluXvc"}],"legendSets":[],"programs":[{"id":"q04UBOqq3rp"},{"id":"kla3mAPgvCH"},{"id":"M3xtLkYBlKI"},{"id":"uy2gU8kT1jF"},{"id":"VBqh0ynB2wv"},{"id":"eBAyeGv0exc"},{"id":"qDkgAbB5Jlk"},{"id":"IpHINAT79UW"},{"id":"lxAQ7Zs9VYR"},{"id":"bMcwwoVnbSR"},{"id":"WSGAb5XwJ3Y"},{"id":"ur1Edk5Oe2n"}],"favorites":[]});
    expect(organisationUnit.level, 4);

    Map<String, Map<String, dynamic>> orgMap = getDBMap<OrganisationUnit>(organisationUnit);
    expect(orgMap['organisationunit'] != null, true);
    print(orgMap['organisationunit']['parent']);
    print(orgMap['organisationunit']['parent'].runtimeType);
    expect(orgMap['organisationunit']['parent'].toString().contains('qtr8GGlm4gg'), true);
    expect(orgMap['organisationunit']['level'], 4);

    OrganisationUnit newOrganisationUnit = getObject<OrganisationUnit>(orgMap['organisationunit']);
    expect(newOrganisationUnit.parent.id, 'qtr8GGlm4gg');
    expect(newOrganisationUnit.level, 4);

    Map<String,List<String>> metadata = getTableColumnDefinitions<OrganisationUnit>();

    expect(metadata['organisationunit']!=null,true);
    expect(metadata['organisationunit'].indexOf('id TEXT PRIMARY KEY') > -1,true);
    expect(metadata['organisationunit'].indexOf('id TEXT') > -1,false);
  });
}


