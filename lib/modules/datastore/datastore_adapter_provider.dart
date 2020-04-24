
import 'dart:convert';

import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/core/query_builder.dart';
import 'package:dhis2sdk/modules/datastore/datastore.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:dio/dio.dart';
import 'package:reflectable/reflectable.dart';

import 'datastore_model_adapter.dart';

class DatastoreAdapterModel extends ModelProvider{

  Future<List<T>> getAll<T>() async{
    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.filter(Filter(left:"namespace",operator: '=',right: ''));
    List<DataStore> dataStores= await getByQuery<DataStore>(queryBuilder);
    return dataStores.map((dataStore){
      return getObject<T>(jsonDecode(dataStore.value));
    });
  }
}