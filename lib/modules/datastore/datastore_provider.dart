
import 'dart:convert';

import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/modules/datastore/datastore.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:dio/dio.dart';
import 'package:reflectable/reflectable.dart';

import 'datastore_model_adapter.dart';

class DatastoreModel extends ModelProvider<Datastore>{


  Future<dynamic> loadDataStore<T extends DatastoreAdapter>(Type dataStoreAdapterType) async {
    Credential credential = DHIS2.credentials;
    print('hey');
    ClassMirror classMirror = Model.reflectType(dataStoreAdapterType);
    DatastoreAdapter dataStoreAdapter = classMirror.newInstance("",[]);
    //this.client.get(config.url + '/api/dataStore/${dataStoreAdapter.namespace}/${dataStoreAdapter.key}/metaData').t
    Response<dynamic> response = await this.client.get(credential.url + '/api/dataStore/${dataStoreAdapter.namespace}');

    print(response);
    for(String key in response.data){
      Response<dynamic> dataResponse = await this.client.get(credential.url + '/api/dataStore/${dataStoreAdapter.namespace}/$key/metaData');
      print('dataResponse');
      print(dataResponse);
      await this.save(Datastore.fromJson(dataResponse.data));
    }

    //List<Response<dynamic>> responses = (await Future.wait(futures)).toList();
    //await Future.wait(responses.map((response) => this.save(Datastore.fromJson(response.data))).toList());
    //response = await this.client.get(credential.url + '/api/dataStore/${dataStoreAdapter.namespace}/${dataStoreAdapter.key}/metaData');
    print('Heerre');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print(response);
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
    print('What');
    List<Future<dynamic>> requests = DHIS2.config.dataStoreAdapters.map((e) => loadDataStore(e)).toList();
    print('Waiting:');
    //print(requests);
    List<dynamic> response = await Future.wait(requests);
    print(response);
    print('Done Waiting');
    notifyListeners();
  }

  Future<List<T>> getList<T extends DatastoreAdapter>() async{
    ClassMirror classMirror = Model.reflectType(T);
    T dataStoreInstance = classMirror.newInstance("", []);
    print(classMirror.simpleName.toLowerCase());
    return (await dbClient.getAllItemsByColumn('datastore','namespace',dataStoreInstance.namespace)).map((object){
      print('Here you go');
      print(object);
      Map<String,dynamic> e = json.decode(object['value']);
      Map<String, dynamic> resultMap = {};
      print(classMirror.declarations.keys.length);
      for(String key in classMirror.declarations.keys){
        print('Key:' + key);
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
      print('resultMap:' + classMirror.simpleName);
      print(resultMap);
      T instance = classMirror.newInstance('fromJson', [
        resultMap
      ]);
      print('Done Mapping resultMap');
      return instance;
    }).toList();
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
}