
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

class DatastoreModel extends ModelProvider{


  /*Future<void> initialize<T>() async {
    for(Type type in DHIS2.config.dataStoreAdapters){
      await super.create_table(type: type);
    }
  }*/
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
  Future<List<T>> download<T>(QueryBuilder queryBuilder) async {
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
      //if(id=='1A2sGtDA8i')
      {
        futures.add(this.client.get(credential.url + '/api/${onlineQuery.endpoint}/$id/metaData'));
      }
    });

    List<Response<dynamic>> responses = await Future.wait(futures);

    List<T> results = [];
    for(response in responses){
      try{
        await save<DataStore>(getObject<DataStore>(response.data));
      }catch(e){
        print("Error Saving Converting Class: DataStore");
        print(response.data['value']);
        print(e);
      }
      Map<String, dynamic> map = jsonDecode(response.data['value']);
      try{
        results.add(getObject<T>(map));
      }catch(e){
        ClassMirror classMirror = Model.reflectType(T);
        print("Error Adding Converting Class:" + classMirror.simpleName);
        map.forEach((key, value) {
          print(key + ":"+ value.runtimeType.toString());
        });
        print(response.data['value']);
        print(e);
      }
    }
    return results;
  }
  Future<List<T>> getByFilter<T>(Filter filter) async {
    ClassMirror classMirror = Model.reflectType(T);
    QueryBuilder queryBuilder = QueryBuilder();

    queryBuilder.filter(Filter(left:'namespace',operator: '==', right:classMirror.invokeGetter('namespace')));
    List<DataStore> data = await super.getByQuery<DataStore>(queryBuilder);
    return data.where((element){
      if(filter.operator == '=='){
        Map<String,dynamic> json = jsonDecode(element.value);
        return json[filter.left] == filter.right;
      }
      return false;
    }).map((element) {
      print('JSON Namespace:');
      print(jsonDecode(element.value));
      return getObject<T>(jsonDecode(element.value));
    }).toList();
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
}