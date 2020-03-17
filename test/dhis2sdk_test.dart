import 'dart:convert';

import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/http_provider.dart';
import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/modules/datastore/datastore_model_adapter.dart';
import 'package:dhis2sdk/modules/datastore/datastore_provider.dart';
import 'package:dhis2sdk/modules/organisation_unit/organisation_unit.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:dhis2sdk/modules/user/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectable/reflectable.dart';

import 'dhis2sdk_test.reflectable.dart';
import 'package:mockito/mockito.dart';


void main() {

  /*final Dio tdio = Dio();
  DioAdapterMock dioAdapterMock;
  //APIHelper tapi;

  setUp(() {
    dioAdapterMock = DioAdapterMock();
    tdio.httpClientAdapter = dioAdapterMock;
    DHISHttpClient(dio: tdio);
    //tapi = APIHelper.test(dio: tdio);
  });
  final responsepayload = jsonEncode({"response_code": "1000"});
  final httpResponse = ResponseBody.fromString(
    responsepayload,
    200,
    headers: {
      Headers.contentTypeHeader: [Headers.jsonContentType],
    },
  );
  TestWidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();
  test('Initializing the Module', () async{
    when(dioAdapterMock.fetch(any, any, any))
        .thenAnswer((_) async{
      print('Here');
      return httpResponse;
    });
    final user = await DHIS2.login(Config(url:'https://play.dhis2.org/2.31.8',username:'admin',password:'district'));
    print(user);
  });*/

  //TestWidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();
  test('Testing Data Store', () async{

    OrganisationUnit organisationUnit = OrganisationUnit.fromJson({"lastUpdated":"2017-05-22T15:21:48.515","id":"Rp268JB6Ne4","href":"https://play.dhis2.org/2.33.2/api/organisationUnits/Rp268JB6Ne4","level":4,"created":"2012-02-17T15:54:39.987","name":"Adonkia CHP","shortName":"Adonkia CHP","code":"OU_651071","leaf":true,"path":"/ImspTQPwCqd/at6UHUQatSo/qtr8GGlm4gg/Rp268JB6Ne4","favorite":false,"dimensionItemType":"ORGANISATION_UNIT","displayName":"Adonkia CHP","displayShortName":"Adonkia CHP","externalAccess":false,"openingDate":"2010-01-01T00:00:00.000","dimensionItem":"Rp268JB6Ne4","parent":{"id":"qtr8GGlm4gg"},"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"children":[],"translations":[],"ancestors":[{"id":"ImspTQPwCqd"},{"id":"at6UHUQatSo"},{"id":"qtr8GGlm4gg"}],"organisationUnitGroups":[{"id":"f25dqv3Y7Z0"}],"userGroupAccesses":[],"attributeValues":[],"users":[],"userAccesses":[],"dataSets":[{"id":"aLpVgfXiz0f"},{"id":"pBOMPrpg1QX"},{"id":"EKWVBc5C0ms"},{"id":"rsyjyJmYD4J"},{"id":"YFTk3VdO9av"},{"id":"ULowA8V3ucd"},{"id":"QX4ZTUbOt3a"},{"id":"eZDhcZi6FLP"},{"id":"YZhd4nu3mzY"},{"id":"Nyh6laLdBEJ"},{"id":"Y8gAn9DfAGU"},{"id":"V8MHeZHIrcP"},{"id":"Lpw6GcnTrmS"},{"id":"VTdjfLXXmoi"},{"id":"j38YW1Am7he"},{"id":"ce7DSxx5H2I"},{"id":"N4fIX1HL3TQ"},{"id":"SF8FDSqw30D"},{"id":"BfMAe6Itzgt"},{"id":"TuL8IOPzpHh"},{"id":"PLq9sJluXvc"}],"legendSets":[],"programs":[{"id":"q04UBOqq3rp"},{"id":"kla3mAPgvCH"},{"id":"M3xtLkYBlKI"},{"id":"uy2gU8kT1jF"},{"id":"VBqh0ynB2wv"},{"id":"eBAyeGv0exc"},{"id":"qDkgAbB5Jlk"},{"id":"IpHINAT79UW"},{"id":"lxAQ7Zs9VYR"},{"id":"bMcwwoVnbSR"},{"id":"WSGAb5XwJ3Y"},{"id":"ur1Edk5Oe2n"}],"favorites":[]});
    ModelProvider modelProvider = ModelProvider();

    Map<String, dynamic> orgMap = modelProvider.getDBMap<OrganisationUnit>(organisationUnit);
    expect(orgMap['parent'], 'qtr8GGlm4gg');

    OrganisationUnit newOrganisationUnit = modelProvider.getObject<OrganisationUnit>(orgMap);
    expect(newOrganisationUnit.parent.id, 'qtr8GGlm4gg');
    print('Finishing');
  });
}
