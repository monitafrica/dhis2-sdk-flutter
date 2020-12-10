
import 'dart:convert';

import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/core/utils/date-utils.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/core/query_builder.dart';
import 'package:dhis2sdk/modules/datastore/datastore.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:dio/dio.dart';
import 'package:reflectable/reflectable.dart';
import 'dart:developer' as dev;

import 'datastore_model_adapter.dart';

class DatastoreAdapterModel extends ModelProvider{

  Future<dynamic> loadDataStore<T extends DatastoreAdapter>(Type dataStoreAdapterType) async {
    Credential credential = DHIS2.credentials;
    this.initialize<T>();
    ClassMirror classMirror = Model.reflectType(dataStoreAdapterType);
    DatastoreAdapter dataStoreAdapter = classMirror.newInstance("",[]);
    //this.client.get(config.url + '/api/dataStore/${dataStoreAdapter.namespace}/${dataStoreAdapter.key}/metaData').t
    Response<dynamic> response = await this.client.get(credential.url + '/api/dataStore/${dataStoreAdapter.namespace}');
    
    for(String key in response.data){
      Response<dynamic> dataResponse = await this.client.get(credential.url + '/api/dataStore/${dataStoreAdapter.namespace}/$key/metaData');
      await this.save<DataStore>(DataStore.fromJson(dataResponse.data));
    }

    //List<Response<dynamic>> responses = (await Future.wait(futures)).toList();
    //await Future.wait(responses.map((response) => this.save(Datastore.fromJson(response.data))).toList());
    //response = await this.client.get(credential.url + '/api/dataStore/${dataStoreAdapter.namespace}/${dataStoreAdapter.key}/metaData');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.

    } else if(response.statusCode == 404){
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Server ${credential.url} Not Found');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load User');
    }
    notifyListeners();
  }
  Future<void> initializeOfflineData() async{
    //List<Future<dynamic>> requests = DHIS2.config.dataStoreAdapters.map((e) => loadDataStore(e)).toList();
    //List<dynamic> response = await Future.wait(requests);
    notifyListeners();
  }
  Future<List<T>> getList<T extends DatastoreAdapter>() async{
    ClassMirror classMirror = Model.reflectType(T);
    T dataStoreInstance = classMirror.newInstance("", []);
    return (await dbClient.getAllItemsByColumn('datastore','namespace',dataStoreInstance.namespace)).map((object){
      Map<String,dynamic> e = json.decode(object['value']);
      Map<String, dynamic> resultMap = {};
      for(String key in classMirror.declarations.keys){
        var value = classMirror.declarations[key];
        if(value is VariableMirror){
          VariableMirror variableMirror = value;
          if(variableMirror.reflectedType == String){
            var valueToSave = e[key];
            if(valueToSave == null){
              resultMap[key] = null;
            }else{
              resultMap[key] = valueToSave;
            }
          }else if(variableMirror.reflectedType == bool){
            if(e[key] == 0){
              resultMap[key] = false;
            } else if(e[key] == 1){
              resultMap[key] = true;
            } else {
              resultMap[key] = null;
            }
          }else{

          }
        }
      }
      T instance = classMirror.newInstance('fromJson', [
        resultMap
      ]);
      return instance;
    }).toList();
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
  Future download<T>(QueryBuilder queryBuilder) async {
    Credential credential = DHIS2.credentials;
    OnlineQuery onlineQuery = queryBuilder.getOnlineQuery();
    String parameters = '';
    if(onlineQuery.fields != null){
      if(parameters==''){
        parameters += '?';
      }
      parameters += 'fields=${onlineQuery.fields}';
    }
    Response<dynamic> response = await this.client.get(credential.url + '/api/${onlineQuery.endpoint}.json$parameters&paging=false');
    List<Future<Response>> futures = [];
    response.data.forEach((id){
      futures.add(this.client.get(credential.url + '/api/${onlineQuery.endpoint}/$id/metaData'));
    });
    List<Response<dynamic>> responses = await Future.wait(futures);

    for(response in responses){
      try{
        await save<DataStore>(getObject<DataStore>(response.data));
      }catch(e, s){
        print(e);
        print(s);
      }
    }
  }
  Future<List<T>> getByFilter<T>(Filter filter) async {

    ClassMirror classMirror = Model.reflectType(T);

    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.filter(Filter(left:'namespace',operator: '==', right:classMirror.invokeGetter('namespace')));
    queryBuilder.filter(filter);
    List<DataStore> data = await super.getByQuery<DataStore>(queryBuilder);
    return data.where((element){
      if(filter.operator == '=='){
        Map<String,dynamic> json = jsonDecode(element.value);
        return json[filter.left] == filter.right;
      }
      if(filter.operator == 'in'){
        Map<String,dynamic> json = jsonDecode(element.value);
        return List<String>.from(filter.right).contains(json[filter.left]);
      }
      return false;
    }).map((element) {
      return getObject<T>(jsonDecode(element.value));
    }).toList();
  }
  Future<List<T>> getAll<T>() async{
    ClassMirror classMirror = Model.reflectType(T);
    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.filter(Filter(left:'namespace',operator: '==', right:classMirror.invokeGetter('namespace')));
    List<DataStore> data = await super.getByQuery<DataStore>(queryBuilder);
    List<T> results = [];
    data.forEach((element) {
      try{
        results.add(getObject<T>(jsonDecode(element.value)));
      }catch(e, s){
        dev.log(jsonEncode(element.value));
        print(s);
      }
    });
    return results;
  }

  DataStore createNewDataStoreObject(Map<String, dynamic> object, String namespace) {
    final String id = object['id'];
    final String value = jsonEncode(object);
    final DataStore dataStore = DataStore(
      id: id,
      key: id,
      value: value,
      namespace: namespace,
      lastUpdated: getCurrentISODate(),
    );

    return dataStore;
  }

  Future<dynamic> saveToDataStore(Map<String, dynamic> object, String namespace, {isDirty: false}) async {
   Map<String, dynamic> data = createNewDataStoreObject(object, namespace).toJson();
   try{
     data['isDirty'] = isDirty;
     await dbClient.saveItemMap('datastore', data);
   }catch(e,s){
     print('Error is $e');
     if((e.message.contains('UNIQUE constraint failed') || e.message.contains('no such column: id'))){
       await updateToDataStore(object, namespace, isDirty: isDirty);
     }else{
       throw(e);
     }
   }
    return object;
  }

  Future<dynamic> updateToDataStore(Map<String, dynamic> object, String namespace, {isDirty: false}) async {
    try{
      Map<String, dynamic> data = object;
      data['isDirty'] = isDirty;
      String key = 'id';
      String criteria = "$key = '${data[key]}'";
      await dbClient.updateItemMap('datastore', criteria, data);
    } catch (e) {
      throw(e);
    }
    return object;
  }

  Future<dynamic> uploadToDataStore(String namespace) async {
    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.filter(Filter(left:'namespace',operator: '==',right: namespace));
    queryBuilder.filter(Filter(left:'isdirty',operator: '==',right: true));
    SelectQuery selectQuery = queryBuilder.getQueryStructure();
    List<Map<String, dynamic>> results = await dbClient.getItemsByFieldsAndWhere('datastore',selectQuery.fields,selectQuery.where);
    if(results.length == 0){
      return {};
    }
    Credential credential = DHIS2.credentials;
    for (var i = 0; i < results.length; i++) {
      Map<String, dynamic> data = results[i];
      String keyLabel = 'id';
      String namespace = data['namespace'];
      String key = data[keyLabel];
      String value = data['value'];

      String url = credential.url + '/api/dataStore/$namespace/$key';
      try{
        await this.client.post(url, jsonDecode(value));
        Map<String, dynamic> newData = Map<String, dynamic>.from(data);
        String criteria = " $keyLabel = '${newData[keyLabel]}'";
        newData['isDirty'] = false;
        await dbClient.updateItemMap('datastore', criteria, newData);
      } catch (e) {
        if(e is DioError) {
          DioError dioError = e as DioError;
          String message = dioError.response != null && dioError.response.data != null ? dioError.response.data['message']: '';
          if(message.contains('already exists on the namespace')) {
            await this.client.put(url, jsonDecode(value));
            Map<String, dynamic> newData = Map<String, dynamic>.from(data);
            String criteria = " $keyLabel = '${newData[keyLabel]}'";
            newData['isDirty'] = false;
            await dbClient.updateItemMap('datastore', criteria, newData);
          } else {
            throw(e);
          }
        }
      }
    }

    return null;
  }
}