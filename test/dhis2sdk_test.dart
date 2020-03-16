import 'dart:convert';

import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/http_provider.dart';
import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/modules/datastore/datastore_model_adapter.dart';
import 'package:dhis2sdk/modules/datastore/datastore_provider.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:dhis2sdk/modules/user/user_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:reflectable/reflectable.dart';

import 'dhis2sdk_test.reflectable.dart';
import 'package:mockito/mockito.dart';

class ExampleDataStoreAdapter extends DatastoreAdapter {
  ExampleDataStoreAdapter() : super(namespace:'METADATASTORE',key:'Version_3');
}

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

    ClassMirror classMirror = Model.reflectType(User);
    classMirror.newInstance('from', positionalArguments)
    await DHIS2.initialize(Config(url:'https://play.dhis2.org/2.31.8',username:'admin',password:'district',dataStoreAdapters: [
      ExampleDataStoreAdapter()
    ]));
    DatastoreModel dataStoreModel = DatastoreModel();

    await dataStoreModel.initialize();
    print('Finishing');
  });
}
