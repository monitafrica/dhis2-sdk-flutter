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
import 'dart:developer' as dev;

import 'dhis2sdk_test.reflectable.dart';

void main() {

  //TestWidgetsFlutterBinding.ensureInitialized();
  initializeReflectable();
  test('Testing Organisation Units', () {

    OrganisationUnit organisationUnit = OrganisationUnit.fromJson({"lastUpdated":"2017-05-22T15:21:48.515","id":"Rp268JB6Ne4","href":"https://play.dhis2.org/2.33.2/api/organisationUnits/Rp268JB6Ne4","level":4,"created":"2012-02-17T15:54:39.987","name":"Adonkia CHP","shortName":"Adonkia CHP","code":"OU_651071","leaf":true,"path":"/ImspTQPwCqd/at6UHUQatSo/qtr8GGlm4gg/Rp268JB6Ne4","favorite":false,"dimensionItemType":"ORGANISATION_UNIT","displayName":"Adonkia CHP","displayShortName":"Adonkia CHP","externalAccess":false,"openingDate":"2010-01-01T00:00:00.000","dimensionItem":"Rp268JB6Ne4","parent":{"id":"qtr8GGlm4gg"},"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"children":[],"translations":[],"ancestors":[{"id":"ImspTQPwCqd"},{"id":"at6UHUQatSo"},{"id":"qtr8GGlm4gg"}],"organisationUnitGroups":[{"id":"f25dqv3Y7Z0"}],"userGroupAccesses":[],"attributeValues":[],"users":[],"userAccesses":[],"dataSets":[{"id":"aLpVgfXiz0f"},{"id":"pBOMPrpg1QX"},{"id":"EKWVBc5C0ms"},{"id":"rsyjyJmYD4J"},{"id":"YFTk3VdO9av"},{"id":"ULowA8V3ucd"},{"id":"QX4ZTUbOt3a"},{"id":"eZDhcZi6FLP"},{"id":"YZhd4nu3mzY"},{"id":"Nyh6laLdBEJ"},{"id":"Y8gAn9DfAGU"},{"id":"V8MHeZHIrcP"},{"id":"Lpw6GcnTrmS"},{"id":"VTdjfLXXmoi"},{"id":"j38YW1Am7he"},{"id":"ce7DSxx5H2I"},{"id":"N4fIX1HL3TQ"},{"id":"SF8FDSqw30D"},{"id":"BfMAe6Itzgt"},{"id":"TuL8IOPzpHh"},{"id":"PLq9sJluXvc"}],"legendSets":[],"programs":[{"id":"q04UBOqq3rp"},{"id":"kla3mAPgvCH"},{"id":"M3xtLkYBlKI"},{"id":"uy2gU8kT1jF"},{"id":"VBqh0ynB2wv"},{"id":"eBAyeGv0exc"},{"id":"qDkgAbB5Jlk"},{"id":"IpHINAT79UW"},{"id":"lxAQ7Zs9VYR"},{"id":"bMcwwoVnbSR"},{"id":"WSGAb5XwJ3Y"},{"id":"ur1Edk5Oe2n"}],"favorites":[]});
    expect(organisationUnit.level, 4);

    Map<String, Map<String, dynamic>> orgMap = getDBMap<OrganisationUnit>(organisationUnit);
    print(jsonEncode((orgMap['organisationunit'])));
    dev.log(jsonEncode((orgMap['organisationunit'])));
    expect(orgMap['organisationunit'] != null, true);
    expect(orgMap['organisationunit']['parent'].toString().contains('qtr8GGlm4gg'), true);
    expect(orgMap['organisationunit']['level'], 4);

    OrganisationUnit newOrganisationUnit = getObject<OrganisationUnit>(orgMap['organisationunit']);
    expect(newOrganisationUnit.parent.id, 'qtr8GGlm4gg');
    expect(newOrganisationUnit.level, 4);

    Map<String,List<String>> metadata = getTableColumnDefinitions<OrganisationUnit>();

    expect(metadata['organisationunit']!=null,true);
    expect(metadata['organisationunit'].indexOf('id TEXT PRIMARY KEY') > -1,true);
    expect(metadata['organisationunit'].indexOf('id TEXT') > -1,false);
    expect(metadata['organisationunit'].indexOf('geometry TEXT') > -1,true);
  });

  test('Testing Organisation Units Coordinates', () {

    OrganisationUnit organisationUnit = OrganisationUnit.fromJson({"lastUpdated":"2020-03-05T12:03:41.044","id":"VXYf2snmuNJ","href":"https://dhis.facility.monitafrica.com/api/organisationUnits/VXYf2snmuNJ","level":4,"created":"2019-01-22T15:41:30.434","name":"066","shortName":"Emporium Eye Centre Clinic","code":"111707-6","leaf":true,"path":"/m0frOspS7JY/acZHYslyJLt/HIOQoi1aeL8/VXYf2snmuNJ","favorite":false,"dimensionItemType":"ORGANISATION_UNIT","displayName":"066","displayShortName":"Emporium Eye Centre Clinic","externalAccess":false,"openingDate":"2017-04-18T00:00:00.000","dimensionItem":"VXYf2snmuNJ","geometry":{"type":"Point","coordinates":[39.25661,-6.84039]},"parent":{"id":"HIOQoi1aeL8"},"lastUpdatedBy":{"id":"M5zQapPyTZI"},"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"user":{"id":"M5zQapPyTZI"},"children":[],"translations":[],"ancestors":[{"id":"m0frOspS7JY"},{"id":"acZHYslyJLt"},{"id":"HIOQoi1aeL8"}],"organisationUnitGroups":[{"id":"xQDiGgEFknR"},{"id":"UE4MHrqMzfd"},{"id":"neiLYc7nArW"},{"id":"P7vTwHby6vZ"},{"id":"ZGhwSwcXKla"}],"userGroupAccesses":[],"attributeValues":[],"users":[],"userAccesses":[],"dataSets":[],"legendSets":[],"programs":[{"id":"iHH3PtbfYDu"},{"id":"vSFtc2GKo1u"},{"id":"Hpz8KbeoFFm"},{"id":"iRAGY1xYrFk"}],"favorites":[]});
    expect(organisationUnit.geometry != null, true);
    expect(organisationUnit.geometry.type, 'Point');
    expect(organisationUnit.geometry.coordinates != null, true);
    expect(organisationUnit.geometry.coordinates.length, 2);
    expect(organisationUnit.geometry.coordinates.elementAt(0), 39.25661);
    expect(organisationUnit.geometry.coordinates.elementAt(1), -6.84039);

    Map<String, Map<String, dynamic>> orgMap = getDBMap<OrganisationUnit>(organisationUnit);
    expect(orgMap['organisationunit'] != null, true);

    expect(orgMap['organisationunit']['geometry'] != null, true);
    expect(orgMap['organisationunit']['geometry'] is String, true);

    OrganisationUnit district = OrganisationUnit.fromJson({"lastUpdated":"2020-03-05T12:00:54.684","id":"lgZ6HfZaj3f","href":"https://dhis.facility.monitafrica.com/api/organisationUnits/lgZ6HfZaj3f","level":3,"created":"2012-03-02T11:00:20.094","name":"Arusha City Council","shortName":"Arusha City Council","leaf":false,"path":"/m0frOspS7JY/YtVMnut7Foe/lgZ6HfZaj3f","favorite":false,"dimensionItemType":"ORGANISATION_UNIT","displayName":"Arusha City Council","displayShortName":"Arusha City Council","externalAccess":false,"openingDate":"1970-01-01T00:00:00.000","dimensionItem":"lgZ6HfZaj3f","geometry":{"type":"Polygon","coordinates":[[[36.6148,-3.4386],[36.6014,-3.4344],[36.601,-3.4346],[36.5974,-3.4364],[36.5967,-3.439],[36.592,-3.4334],[36.5918,-3.4302],[36.5922,-3.4255],[36.5914,-3.4258],[36.5914,-3.4255],[36.5928,-3.4175],[36.5923,-3.4157],[36.591,-3.4103],[36.5881,-3.4024],[36.5843,-3.3942],[36.5831,-3.3884],[36.5851,-3.3882],[36.5891,-3.3902],[36.5896,-3.3899],[36.5896,-3.3899],[36.5908,-3.3892],[36.5904,-3.3849],[36.5904,-3.3849],[36.5902,-3.3821],[36.5902,-3.382],[36.59,-3.3759],[36.611,-3.3422],[36.6251,-3.353],[36.6339,-3.3573],[36.6355,-3.3621],[36.6377,-3.3635],[36.6506,-3.3598],[36.6506,-3.3594],[36.6505,-3.3589],[36.6514,-3.3584],[36.6534,-3.3558],[36.6559,-3.356],[36.6576,-3.356],[36.6578,-3.3561],[36.6583,-3.3562],[36.6595,-3.3567],[36.6605,-3.3564],[36.6762,-3.3598],[36.6946,-3.3584],[36.7012,-3.3602],[36.702,-3.3598],[36.702,-3.3597],[36.7066,-3.362],[36.7257,-3.3624],[36.7259,-3.3624],[36.726,-3.3624],[36.726,-3.3624],[36.7284,-3.3629],[36.7303,-3.3632],[36.7355,-3.3652],[36.7423,-3.3695],[36.7511,-3.3715],[36.7574,-3.377],[36.7601,-3.388],[36.7623,-3.3909],[36.7637,-3.3916],[36.7643,-3.3919],[36.765,-3.3922],[36.766,-3.3927],[36.7663,-3.3928],[36.7659,-3.3932],[36.7652,-3.394],[36.7646,-3.3943],[36.7639,-3.3944],[36.7623,-3.3945],[36.7608,-3.395],[36.7606,-3.3952],[36.7598,-3.3961],[36.7595,-3.3969],[36.7595,-3.3971],[36.7596,-3.3982],[36.7598,-3.3999],[36.7542,-3.4064],[36.7526,-3.414],[36.7491,-3.4176],[36.747,-3.4199],[36.7449,-3.4223],[36.7427,-3.4246],[36.739,-3.427],[36.7387,-3.4289],[36.7387,-3.4311],[36.7385,-3.4337],[36.7383,-3.4355],[36.7304,-3.4355],[36.7265,-3.4345],[36.7212,-3.441],[36.7213,-3.4414],[36.7234,-3.4437],[36.7257,-3.4475],[36.7191,-3.464],[36.7201,-3.4679],[36.7199,-3.47],[36.7199,-3.471],[36.7198,-3.4717],[36.7197,-3.4731],[36.7202,-3.4739],[36.7206,-3.4745],[36.7209,-3.4751],[36.7213,-3.4788],[36.7238,-3.4789],[36.7295,-3.4878],[36.7259,-3.505],[36.7227,-3.5288],[36.7202,-3.5316],[36.7197,-3.5372],[36.7156,-3.5481],[36.7149,-3.5512],[36.7142,-3.5516],[36.713,-3.5521],[36.7102,-3.5512],[36.7035,-3.5507],[36.7002,-3.5509],[36.6989,-3.5512],[36.6969,-3.5527],[36.6959,-3.5544],[36.6821,-3.5559],[36.6761,-3.555],[36.672,-3.5557],[36.6693,-3.5547],[36.6677,-3.5524],[36.6664,-3.5497],[36.6652,-3.5474],[36.6637,-3.5456],[36.6635,-3.5337],[36.6535,-3.515],[36.6539,-3.507],[36.651,-3.4874],[36.6488,-3.4876],[36.6391,-3.488],[36.639,-3.488],[36.6289,-3.4891],[36.6287,-3.4885],[36.6283,-3.4872],[36.6297,-3.479],[36.632,-3.4716],[36.6244,-3.4464],[36.6148,-3.4386]]]},"parent":{"id":"YtVMnut7Foe"},"lastUpdatedBy":{"id":"M5zQapPyTZI"},"access":{"read":true,"update":true,"externalize":true,"delete":true,"write":true,"manage":true},"user":{"id":"M5zQapPyTZI"},"children":[{"id":"g3ATGeDJpr0"},{"id":"FxkvwFQBteg"},{"id":"Nky82zx6NQw"},{"id":"Vnzin0vWH9c"},{"id":"MGRNfzaj2NR"},{"id":"uQ6AEPLq1W0"},{"id":"xd2Rxi91ZTD"},{"id":"Fw7YZAASKel"},{"id":"hh0mrmZ1Viq"},{"id":"E7wzi4PdTiD"},{"id":"euufGwsOdQz"},{"id":"e3OgvhjDa7D"},{"id":"ch0KchJQVl6"},{"id":"vJ5s1v4SNSQ"},{"id":"AGQikljQSJ1"},{"id":"y3BwWgEBHD4"},{"id":"mPP11IHuwHU"},{"id":"fMBAgl4v8ZM"},{"id":"To5ATasBZMu"},{"id":"pK5FsujmLPf"},{"id":"ri55daHZCCt"},{"id":"pbt52idmn2y"},{"id":"cfmo8YynfrX"},{"id":"myYdAxOCkpR"},{"id":"FDpsVCkyrtX"},{"id":"W1uL3UTkc9I"},{"id":"qObyLU1yJoN"},{"id":"QonSb24QVNo"},{"id":"OapFyXDTlMp"},{"id":"ueA5e1VANsu"},{"id":"DxKeXp4SRle"},{"id":"hl6gBEyQ2ZE"},{"id":"DmmzYQSSqeS"},{"id":"R7gKjuhTRrV"},{"id":"ZvW1SsWm9VP"},{"id":"jGRJjf4ZM94"},{"id":"aAMeRYFum96"},{"id":"pChM6mlXt73"},{"id":"aVQFxLRDxW3"},{"id":"XMXUbkykD72"},{"id":"fRzkZyPlPaU"},{"id":"vu8bIjX9gD1"},{"id":"WwkgvKn4lbb"},{"id":"v9ZWDqvz4bJ"},{"id":"wkt9kBPiUhQ"},{"id":"B4xeYH1Bh44"},{"id":"RFxJQgHTP9I"},{"id":"C7CbWUh3ZGZ"},{"id":"rQCXeEZ2Hu2"},{"id":"yxDguaBESrz"},{"id":"SuoqM5pXPWG"},{"id":"PkYOq3i96W5"},{"id":"IDW9Eez19K6"},{"id":"hbeiD77AQxs"},{"id":"EwiQb3Ro0K8"},{"id":"YnyHZS7iTzr"},{"id":"x9rWO43vi0w"},{"id":"IzqA1bVBDmf"},{"id":"yB8hKiHiVqe"},{"id":"d0OIGtP3C5z"},{"id":"mmz3jdw1yZL"},{"id":"VsBybftGPCh"},{"id":"Qw4j4vqVZQd"},{"id":"hgqiYpjjCGK"},{"id":"Y8rGS7kiOav"},{"id":"MmgvsH4h8pn"},{"id":"VR9DGyn74Qw"},{"id":"ZfHUjM9fQoN"},{"id":"gmcaHms2xyb"},{"id":"zeBD0GNTXuH"},{"id":"bbx2XZhopXy"},{"id":"jNAny7XRnDb"},{"id":"M63y0lV6dCQ"},{"id":"NV8pMkRVSX1"},{"id":"Jzg8ZduUaBg"},{"id":"XwSWVFKMzee"},{"id":"cJAFqbZOIn8"},{"id":"ThjuZW56J4J"},{"id":"q91iEOWkRyx"},{"id":"EPP1XcYSwha"},{"id":"KKI55pR8v43"},{"id":"JVgr5ecJKxd"},{"id":"rfo2Eqny4zf"},{"id":"OEL2xs4Ugpb"},{"id":"wJNRf5HFkn1"},{"id":"vGgfWC2XX2R"},{"id":"gDcTrVWcaex"},{"id":"qTCRCgN12gE"},{"id":"S75EZoUUftE"},{"id":"bLU2X0DWfLm"},{"id":"DwmrRABVABm"},{"id":"zZMzWjD2tux"},{"id":"eCUwwNkqxOL"},{"id":"SwXhEVeg1Xy"},{"id":"kIZQN2D1ekK"},{"id":"wahSKrGd1v8"},{"id":"JTzn5YtWBIy"},{"id":"vW00w9u5ghW"},{"id":"TKGFxisQtcd"},{"id":"vdhmdacr3FO"},{"id":"n7TEJsHmWDd"},{"id":"DFAZ8676wy4"},{"id":"Evd3wbDmdGu"},{"id":"jeW1i7vkgaH"},{"id":"EDBRNm4RWw3"},{"id":"jUpCI4ul5kN"},{"id":"oprrRJ54Yup"},{"id":"vB38tTn5YGm"},{"id":"hcb09IcZvZo"},{"id":"cMXbDCKFOjr"},{"id":"VN8Jjz61jOE"},{"id":"FwGAWe7EO3z"},{"id":"n3WL7IVRMgN"},{"id":"JraJ1Bp0ZAY"},{"id":"zd1wO4UoL3f"},{"id":"mcSNtlO2X3M"},{"id":"TA9jVBhblu6"},{"id":"Xe9q1NwLEAu"},{"id":"JQMx11NWqAg"},{"id":"DpUMHSNKeiS"},{"id":"FX9ABe3SEwA"},{"id":"mrgygzWlK28"},{"id":"epbMUPJh161"},{"id":"QZqP8F53daD"},{"id":"QW1IRLgfxLd"}],"translations":[],"ancestors":[{"id":"m0frOspS7JY"},{"id":"YtVMnut7Foe"}],"organisationUnitGroups":[{"id":"IhzZ8M2Jm9F"},{"id":"sxgDEDLkuAs"},{"id":"Bf2IyOkJ3R4"}],"userGroupAccesses":[],"attributeValues":[],"users":[{"id":"z1wrDSy0Oqh"},{"id":"fV9JxjXDEgO"},{"id":"o0fdX3gAi8L"}],"userAccesses":[],"dataSets":[{"id":"Z8Hz5lc8utD"}],"legendSets":[],"programs":[{"id":"iHH3PtbfYDu"},{"id":"vSFtc2GKo1u"}],"favorites":[]});
  });
}


