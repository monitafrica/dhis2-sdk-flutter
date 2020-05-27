import 'dart:convert';
import 'dart:io';

import 'package:dhis2sdk/core/query_builder.dart';
import 'package:dhis2sdk/modules/organisation_unit/organisation_unit.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:flutter/foundation.dart';
import 'package:reflectable/reflectable.dart';
import 'package:dio/dio.dart';

import 'database_provider.dart';
import 'dhis2.dart';
import 'http_provider.dart';
import 'model.dart';
import 'dart:developer' as dev;

class ModelProvider extends ChangeNotifier {
  DHISHttpClient client = new DHISHttpClient();
  DatabaseHelper dbClient = new DatabaseHelper();

  Future<void> initialize<T>() async {
    await create_table<T>();
    await initializeOfflineData();
  }

  // ignore: non_constant_identifier_names
  Future create_table<T>({Type type}) async {
    Map<String, List<String>> tables = getTableColumnDefinitions<T>(type:type);
    await Future.wait(
        tables.keys.map((key) => dbClient.create_table(key, tables[key])));
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
    if(onlineQuery.parameters != null){
      onlineQuery.parameters.forEach((key, value) {
        if(parameters==''){
          parameters += '?';
        }else{
          parameters += '&';
        }
        parameters += '$key=$value';
      });
    }
    String url = credential.url + '/api/${onlineQuery.endpoint}.json$parameters&paging=false';
    print('Download:$url');
    Response<dynamic> response = await this.client.get(url);
    dynamic result = response.data[onlineQuery.endpoint];
    if(onlineQuery.resultField == null){
      result = response.data;
    }else{
      result = response.data[onlineQuery.resultField];
    }
    print(result);
    if(result is List){
      for(Map<String,dynamic> resultMap in result){
        await save(getObject<T>(resultMap));
      }
    }else{
      await save(getObject<T>(result));
    }
    //await Future.wait(orgUnitMaps.map((ouMap)=>save(OrganisationUnit.fromJson(ouMap))));
    notifyListeners();
  }

  Future<dynamic> downloadMemory<T>(QueryBuilder queryBuilder) async {
    Credential credential = DHIS2.credentials;
    OnlineQuery onlineQuery = queryBuilder.getOnlineQuery();
    String parameters = '';
    if(onlineQuery.fields != null){
      if(parameters==''){
        parameters += '?';
      }
      parameters += 'fields=${onlineQuery.fields}';
    }
    if(onlineQuery.parameters != null){
      onlineQuery.parameters.forEach((key, value) {
        if(parameters==''){
          parameters += '?';
        }else{
          parameters += '&';
        }
        parameters += '$key=$value';
      });
    }
    if(parameters == ''){
      parameters += '?';
    }else{
      parameters += '&';
    }
    parameters += 'paging=false';
    String url = credential.url + '/api/${onlineQuery.endpoint}.json$parameters';
    print('From Memory:$url');
    Response<dynamic> response = await this.client.get(url);
    if(onlineQuery.resultField == null){
      return getObject<T>(response.data);
    }else{
      return response.data[onlineQuery.resultField].map((resultMap) => getObject<T>(resultMap));
    }
  }

  Future<dynamic> upload<T>(QueryBuilder queryBuilder) async {
    ClassMirror classMirror = Model.reflectType(T);
    SelectQuery selectQuery = queryBuilder.getQueryStructure();
    List<T> entities = (await dbClient.getItemsByFieldsAndWhere(classMirror.simpleName.toLowerCase(),selectQuery.fields,selectQuery.where))
        .map((e) {
      return getObject<T>(e);
    }).toList();
    Credential credential = DHIS2.credentials;
    OnlineQuery onlineQuery = queryBuilder.getOnlineQuery();
    String parameters = '';
    if(onlineQuery.fields != null){
      if(parameters==''){
        parameters += '?';
      }
      parameters += 'fields=${onlineQuery.fields}';
    }
    if(onlineQuery.parameters != null){
      onlineQuery.parameters.forEach((key, value) {
        if(parameters==''){
          parameters += '?';
        }else{
          parameters += '&';
        }
        parameters += '$key=$value';
      });
    }
    String url = credential.url + '/api/${onlineQuery.endpoint}.json$parameters';
    print('Upload:$url');
    Response<dynamic> response = await this.client.post(url,{
      onlineQuery.endpoint: entities.map((e){
        InstanceMirror instanceMirror = Model.reflect(e);
        Map data = instanceMirror.invoke('toJson',[]);
        removeNullAndEmptyParams(data);
        return data;
      }).toList()
    });

    String key = getPrimaryKey<T>();
    for(T model in entities){
      InstanceMirror instanceMirror = Model.reflect(model);
      await update<T>(model, "$key ='${instanceMirror.invokeGetter(key)}'",isDirty: false);
    }
    return response.data;
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }

  Future<dynamic> uploadFile(String filePath) async {
    Credential credential = DHIS2.credentials;
    String url = credential.url + '/api/fileResources';
    List<String> dir = filePath.split('/');
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath,filename: dir[dir.length - 1]),
    });
    print('Upload File:$url');
    Response<dynamic> response = await this.client.post(url,formData);
    return response.data;
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
  Future<dynamic> downloadFile(String filePath, String endpoint) async {
    Credential credential = DHIS2.credentials;
    String url = credential.url + '/api/$endpoint';
    print('Download File:$url');
    Response response = await this.client.get(url);
    File file = new File(filePath);
    await file.writeAsBytes(response.data);
    return response.data;
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
  Future<T> singleDownloadMemory<T>(QueryBuilder queryBuilder) async {
    Credential credential = DHIS2.credentials;
    OnlineQuery onlineQuery = queryBuilder.getOnlineQuery();
    String parameters = '';
    if(onlineQuery.fields != null){
      if(parameters==''){
        parameters += '?';
      }
      parameters += 'fields=${onlineQuery.fields}';
    }
    if(onlineQuery.parameters != null){
      onlineQuery.parameters.forEach((key, value) {
        if(parameters==''){
          parameters += '?';
        }else{
          parameters += '&';
        }
        parameters += '$key=$value';
      });
    }
    String url = credential.url + '/api/${onlineQuery.endpoint}.json$parameters&paging=false';
    print('Single Download Memory:$url');
    Response<dynamic> response = await this.client.get(url);
    return getObject<T>(response.data);
  }
  Future<T> save<T>(T model,{isDirty = false}) async {
    Map<String, Map<String, dynamic>> results = getDBMap<T>(model);
    for(String key in results.keys){
      try{
        results[key]['isdirty'] = isDirty;
        await dbClient.saveItemMap(key, results[key]);
      }catch(e,s){
        if(e.message.contains('UNIQUE constraint failed') || e.message.contains('no such column: id')){
          String key = getPrimaryKey<T>();
          InstanceMirror instanceMirror = Model.reflect(model);
          await update<T>(model, "$key ='${instanceMirror.invokeGetter(key)}'",isDirty: isDirty);
        }else{
          throw(e);
        }
      }
    }
    return model;
  }

  Future<List<T>> saveAll<T>(List<T> models) async {
    for(T model in models){
      await save<T>(model);
    }
    return models;
  }

  Future<T> update<T>(T model,String criteria,{isDirty = false}) async {
    Map<String, Map<String, dynamic>> results = getDBMap<T>(model);
    for(String key in results.keys){
      results[key]['isdirty'] = isDirty;
      await dbClient.updateItemMap(key, criteria, results[key]);
    }
    return model;
  }
  Future deleteAll<T>() async {
    ClassMirror classMirror = Model.reflectType(T);
    return await dbClient.deleteAll(classMirror.simpleName);
  }

  Future<void> initializeOfflineData() async {

  }

  QueryBuilder fetch(){
    return QueryBuilder();
  }
  /**
   * Get all the entities of the model
   *
   * Returns list of models
   */
  Future<List<T>> getAll<T>() async {
    ClassMirror classMirror = Model.reflectType(T);
    return (await dbClient.getAllItems(classMirror.simpleName.toLowerCase()))
        .map((e) {
      return getObject<T>(e);
    }).toList();
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }

  Future<List<T>> getByQuery<T>(QueryBuilder queryBuilder) async {
    ClassMirror classMirror = Model.reflectType(T);
    SelectQuery selectQuery = queryBuilder.getQueryStructure();
    return (await dbClient.getItemsByFieldsAndWhere(classMirror.simpleName.toLowerCase(),selectQuery.fields,selectQuery.where))
        .map((e) {
      return getObject<T>(e);
    }).toList();
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
}

void removeNullAndEmptyParams(Map<String, Object> mapToEdit) {
// Remove all null values; they cause validation errors
  final keys = mapToEdit.keys.toList(growable: false);
  for (String key in keys) {
    final value = mapToEdit[key];
    if (value == null) {
      mapToEdit.remove(key);
    } else if (value is String) {
      if (value.isEmpty) {
        mapToEdit.remove(key);
      }
    } else if (value is Map) {
      removeNullAndEmptyParams(value);
    } else if (value is List) {
      value.forEach((element) {
        removeNullAndEmptyParams(element);
      });
    }
  }
}
getTableColumns<T>() {}
String getPrimaryKey<T>({Type type}) {
  ClassMirror classMirror;
  if (type != null) {
    classMirror = Model.reflectType(type);
  } else {
    classMirror = Model.reflectType(T);
  }
  String primaryKey;
  for (String key in classMirror.declarations.keys) {
    var value = classMirror.declarations[key];
    if (value is VariableMirror) {
      VariableMirror variableMirror = value;
      variableMirror.metadata.forEach((element) {
        if(element is PrimaryKey){
          primaryKey = key;
        }
      });
    }
  }
  return primaryKey;
}
Map<String, List<String>> getTableColumnDefinitions<T>({Type type}) {
  ClassMirror classMirror;
  if (type != null) {
    classMirror = Model.reflectType(type);
  } else {
    classMirror = Model.reflectType(T);
  }
  Map<String, List<String>> tables = {};
  List<String> columns = [];
  for (String key in classMirror.declarations.keys) {
    var value = classMirror.declarations[key];
    if (value is VariableMirror) {
      VariableMirror variableMirror = value;
      bool isPrimaryKey = false;
      variableMirror.metadata.forEach((element) {
        if(element is PrimaryKey){
          columns.add('$key TEXT PRIMARY KEY');
          isPrimaryKey = true;
        }
      });
      if(!isPrimaryKey){
        if (variableMirror.reflectedType == String) {
          columns.add('$key TEXT');
        } else if (variableMirror.reflectedType == int) {
          columns.add('$key INTEGER');
        } else if (variableMirror.reflectedType == bool) {
          columns.add('$key BOOLEAN');
        }else {
          variableMirror.metadata.forEach((element) {
            if (element is Column) {
              columns.add('$key TEXT');
            } else if (element is OneToOne) {
              Map<String, List<String>> tempTables = getTableColumnDefinitions(type: variableMirror.reflectedType);
              tables.addAll(tempTables);
            } else {

            }
          });
        }
      }
    }
  }
  columns.add('isdirty BOOLEAN');
  tables[classMirror.simpleName.toLowerCase()] = columns;
  return tables;
}

dynamic getObjectFieldValue(Type type, object, field) {
  ClassMirror classMirror = Model.reflectType(type);
  InstanceMirror instanceMirror = Model.reflect(object);
  for (String key in classMirror.declarations.keys) {
    if (key == field) {
      return instanceMirror.invokeGetter(key);
    }
  }
  return null;
}

Map<String, Map<String, dynamic>> getDBMap<T>(T object,{Type type}) {
  ClassMirror classMirror;
  if (type != null) {
    classMirror = Model.reflectType(type);
  } else {
    classMirror = Model.reflectType(T);
  }
  InstanceMirror instanceMirror = Model.reflect(object);
  Map<String, Map<String, dynamic>> resultMap = {
    classMirror.simpleName.toLowerCase():{}
  };
  for (String key in classMirror.declarations.keys) {
    var value = classMirror.declarations[key];
    if (value is VariableMirror) {
      VariableMirror variableMirror = value;

      if (variableMirror.reflectedType == String) {
        var valueToSave = instanceMirror.invokeGetter(key);
        if (valueToSave == null) {
          resultMap[classMirror.simpleName.toLowerCase()][key] = null;
        } else {
          resultMap[classMirror.simpleName.toLowerCase()][key] = valueToSave;
        }
      } else if (variableMirror.reflectedType == bool) {
        resultMap[classMirror.simpleName.toLowerCase()][key] = instanceMirror.invokeGetter(key);
      } else if (variableMirror.reflectedType == int) {
        resultMap[classMirror.simpleName.toLowerCase()][key] = instanceMirror.invokeGetter(key);
      } else {
        var otherObject = instanceMirror.invokeGetter(key);
        variableMirror.metadata.forEach((element) {
          if (element is Column) {
            if(instanceMirror.invokeGetter(key).runtimeType.toString().startsWith("List<")){
              resultMap[classMirror.simpleName.toLowerCase()][key] = jsonEncode((instanceMirror.invokeGetter(key) as List).map((object){
                return getDBMap(object,type: object.runtimeType)[object.runtimeType.toString().toLowerCase()];
              }).toList());
            }else{
              if(instanceMirror.invokeGetter(key) != null){
                Map<String,dynamic> dependeny = getDBMap(instanceMirror.invokeGetter(key),type: instanceMirror.invokeGetter(key).runtimeType);
                resultMap[classMirror.simpleName.toLowerCase()][key] = jsonEncode(Map<String, dynamic>.from(dependeny[instanceMirror.invokeGetter(key).runtimeType.toString().toLowerCase()]));
              }
            }
          }else if (element is OneToOne) {
            Map<String, dynamic> childMap = getDBMap(otherObject,type:variableMirror.reflectedType);
            resultMap.addAll(childMap);
          }
        });
      }
    }
  }
  return resultMap;
}

T getObject<T>(Map<String, dynamic> objectMap) {
  ClassMirror classMirror = Model.reflectType(T);
  Map<String, dynamic> resultMap = {};
  for (String key in classMirror.declarations.keys) {
    var value = classMirror.declarations[key];
    if (value is VariableMirror) {
      VariableMirror variableMirror = value;
      bool isMetadata = false;
      variableMirror.metadata.forEach((element) {
        if (element is Column) {
          if(variableMirror.reflectedType.toString().startsWith("List<")){
            if(objectMap[key].runtimeType == String){
              resultMap[key] = jsonDecode(objectMap[key]);
            }else{
              resultMap[key] = objectMap[key];
            }
          }else{
            if(variableMirror.reflectedType == String) {
              resultMap[key] = objectMap[key];
            }else{
              if(objectMap[key].runtimeType == String){
                try{
                  resultMap[key] = jsonDecode(objectMap[key]);
                }catch(e){
                  resultMap[key] = objectMap[key];
                }

              }else{
                resultMap[key] = objectMap[key];
              }
            }
          }
          isMetadata = true;
        }
      });
      if(!isMetadata && objectMap[key] != null){
        if (variableMirror.reflectedType == String) {
          var valueToSave = objectMap[key];
          if (valueToSave == null) {
            resultMap[key] = null;
          } else {
            resultMap[key] = valueToSave;
          }
        } else if (variableMirror.reflectedType == bool) {
          if (objectMap[key] == 0) {
            resultMap[key] = false;
          } else if (objectMap[key] == 1) {
            resultMap[key] = true;
          } else {
            resultMap[key] = objectMap[key];
          }
        } else if (variableMirror.reflectedType == int) {
          resultMap[key] = objectMap[key];
        } else if (variableMirror.reflectedType.toString().startsWith('Map<String')) {
          resultMap[key] = objectMap[key];

        }else if (variableMirror.reflectedType.toString().startsWith('List<')) {
          if(variableMirror.reflectedType.toString() == (List<String>()).runtimeType.toString()) {
            resultMap[key] = objectMap[key].map((element){
              return element.toString();
            }).toList();
            List<String> stringList = [];
            objectMap[key].forEach((element){
              stringList.add(element.toString());
            });
            resultMap[key] = stringList;
          }else{
            resultMap[key] = objectMap[key];
          }

        } else {
          //print(key + ' not used');
          //print(variableMirror.reflectedType);
        }
      }
    }
  }
  return classMirror.newInstance('fromJson', [resultMap]);
}
