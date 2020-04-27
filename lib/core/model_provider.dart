import 'dart:convert';

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
    Response<dynamic> response = await this.client.get(url);
    dynamic result = response.data[onlineQuery.endpoint];
    if(onlineQuery.resultField == null){
      result = response.data;
    }else{
      result = response.data[onlineQuery.resultField];
    }
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
  Future<T> save<T>(T model) async {
    Map<String, Map<String, dynamic>> results = getDBMap<T>(model);
    for(String key in results.keys){
      await dbClient.saveItemMap(key, results[key]);
    }
    return model;
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

getTableColumns<T>() {}

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

      if (variableMirror.reflectedType == String) {
        if (key == 'id') {
          columns.add('$key TEXT PRIMARY KEY');
        } else {
          columns.add('$key TEXT');
        }
      } else if (variableMirror.reflectedType == int) {
        columns.add('$key INTEGER');
      } else if (variableMirror.reflectedType == bool) {
        columns.add('$key BOOLEAN');
      }else {
        variableMirror.metadata.forEach((element) {
          if (element is Column) {
            if(element.map != null){
              element.map.keys.forEach((ckey) {
                MapField mapField = element.map[ckey];
                if(mapField.type == String) {
                  columns.add('${mapField.field} TEXT');
                }else{
                }
              });
            }else{
              columns.add('$key TEXT');
            }
          } else if (element is OneToOne) {
            Map<String, List<String>> tempTables = getTableColumnDefinitions<T>(type: variableMirror.reflectedType);
            tables.addAll(tempTables);
          } else {

          }
        });
      }
    }
  }
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
      } else {
        var otherObject = instanceMirror.invokeGetter(key);
        variableMirror.metadata.forEach((element) {
          if (element is Column) {
            if(element.map != null){
              element.map.keys.forEach((key2) {
                MapField mapField = element.map[key2];
                if(otherObject == null){
                  resultMap[classMirror.simpleName.toLowerCase()][mapField.field] = null;
                }else if(otherObject is List){
                  resultMap[classMirror.simpleName.toLowerCase()][mapField.field] = jsonEncode(otherObject.map((obj)=>obj.toJson()[key2]).toList());
                }else{
                  resultMap[classMirror.simpleName.toLowerCase()][mapField.field] = getObjectFieldValue(
                      variableMirror.reflectedType, otherObject, key2);
                }
              });
            }else{
              resultMap[classMirror.simpleName.toLowerCase()][key] = jsonEncode(instanceMirror.invokeGetter(key));
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
            resultMap[key] = objectMap[key];
          }else{
            if(objectMap[key].runtimeType == String) {
              Map<String, dynamic> relation = {};
              element.map.keys.forEach((ckey) {
                MapField mapField = element.map[ckey];
                relation[ckey] = objectMap[mapField.field];
              });
              resultMap[key] = relation;
            }else{
              resultMap[key] = objectMap[key];
            }
          }
          isMetadata = true;
        }
      });
      if(!isMetadata){
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
        } else if (variableMirror.reflectedType.toString().startsWith('List<')) {
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
          print(key + ' not used');
          print(variableMirror.reflectedType);
        }
      }
    }
  }
  return classMirror.newInstance('fromJson', [resultMap]);
}
