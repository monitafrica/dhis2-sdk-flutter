
import 'package:dhis2sdk/modules/organisation_unit/organisation_unit.dart';
import 'package:flutter/foundation.dart';
import 'package:reflectable/reflectable.dart';

import 'database_provider.dart';
import 'http_provider.dart';
import 'model.dart';


class ModelProvider extends ChangeNotifier {

  DHISHttpClient client = new DHISHttpClient();
  DatabaseHelper dbClient = new DatabaseHelper();


  initialize<T>() async {
    create_table<T>();
    initializeOfflineData();
  }

  // ignore: non_constant_identifier_names
  Future create_table<T>({Type type}) async{
    ClassMirror classMirror;
    if(type != null){
      classMirror = Model.reflectType(type);
    }else{
      classMirror = Model.reflectType(T);
    }
    List<String> columns = [];
    for(String key in classMirror.declarations.keys){
      var value = classMirror.declarations[key];
      if(value is VariableMirror){
        VariableMirror variableMirror = value;

        if(variableMirror.reflectedType == String){
          if(key == 'id'){
            columns.add('$key TEXT PRIMARY KEY');
          }else{
            columns.add('$key TEXT');
          }
        }else if(variableMirror.reflectedType == bool){
          columns.add('$key BOOLEAN');
        }else{
          //variableMirror.reflectedType.
          await create_table(type:variableMirror.reflectedType);
        }
      }
    }
    await dbClient.create_table(classMirror.simpleName.toLowerCase(),columns);
  }

  Future<T> save<T>(T model) async{
    ClassMirror classMirror = Model.reflectType(T);
    InstanceMirror instanceMirror = Model.reflect(model);
    Map<String, dynamic> resultMap = {};
    for(String key in classMirror.declarations.keys){
      var value = classMirror.declarations[key];
      if(value is VariableMirror){
        VariableMirror variableMirror = value;

        if(variableMirror.reflectedType == String){
          var valueToSave = instanceMirror.invokeGetter(key);
          if(valueToSave == null){
            resultMap[key] = null;
          }else{
            resultMap[key] = valueToSave;
          }
        }else if(variableMirror.reflectedType == bool){
          resultMap[key] = instanceMirror.invokeGetter(key);
        }else{
          var otherObject = instanceMirror.invokeGetter(key);
          if(otherObject is ModelInterface) {
            print('Found toJson Interface');
            await dbClient.saveItemMap(variableMirror.reflectedType.toString().toLowerCase(), otherObject.toJson());
          } else {
            print(instanceMirror.invokeGetter(key));
            print('Found Boolean:' + key);
          }
        }
      }
    }
    await dbClient.saveItemMap(classMirror.simpleName.toLowerCase(),resultMap);
    return model;
  }
  void initializeOfflineData() async{
    print('Running Offline Innitialization:');
  }

  /**
   * Get all the entities of the model
   *
   * Returns list of models
   */
  Future<List<T>> getAll<T>() async{
    ClassMirror classMirror = Model.reflectType(T);
    print(classMirror.simpleName.toLowerCase());
    return (await dbClient.getAllItems(classMirror.simpleName.toLowerCase())).map((e){
      /*Map<String, dynamic> resultMap = {};
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
      ]);*/
      return getObject<T>(e);
    }).toList();
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }

  dynamic getObjectFieldValue(Type type, object, field){
    ClassMirror classMirror = Model.reflectType(type);
    InstanceMirror instanceMirror = Model.reflect(object);
    for(String key in classMirror.declarations.keys){
      if(key == field){
        return instanceMirror.invokeGetter(key);
      }
    }
    return null;
  }
  Map<String, dynamic> getDBMap<T>(T object) {
    ClassMirror classMirror = Model.reflectType(T);
    InstanceMirror instanceMirror = Model.reflect(object);
    Map<String, dynamic> resultMap = {};
    for(String key in classMirror.declarations.keys){
      var value = classMirror.declarations[key];
      if(value is VariableMirror){
        VariableMirror variableMirror = value;

        if(variableMirror.reflectedType == String){
          var valueToSave = instanceMirror.invokeGetter(key);
          if(valueToSave == null){
            resultMap[key] = null;
          }else{
            resultMap[key] = valueToSave;
          }
        }else if(variableMirror.reflectedType == bool){
          resultMap[key] = instanceMirror.invokeGetter(key);
        }else{
          var otherObject = instanceMirror.invokeGetter(key);
          variableMirror.metadata.forEach((element) {
            if(element is ColumnMap){
              element.map.keys.forEach((key) {
                resultMap[element.map[key]] = getObjectFieldValue(variableMirror.reflectedType,otherObject, key);
              });
            }
          });
        }
      }
    }
    return resultMap;
  }

  T getObject<T>(Map<String, dynamic>  objectMap) {
    ClassMirror classMirror = Model.reflectType(T);
    Map<String, dynamic> resultMap = {};
    for(String key in classMirror.declarations.keys){
      var value = classMirror.declarations[key];
      if(value is VariableMirror){
        VariableMirror variableMirror = value;

        if(variableMirror.reflectedType == String){
          var valueToSave = objectMap[key];
          if(valueToSave == null){
            resultMap[key] = null;
          }else{
            resultMap[key] = valueToSave;
          }
        }else if(variableMirror.reflectedType == bool){
          if(objectMap[key] == 0){
            resultMap[key] = false;
          } else if(objectMap[key] == 1){
            resultMap[key] = true;
          } else{
            resultMap[key] = objectMap[key];
          }
        }else{
          variableMirror.metadata.forEach((element) {
            if(element is ColumnMap){
              Map<String,dynamic> relation = {};
              element.map.keys.forEach((ckey) {
                relation[ckey] = objectMap[element.map[ckey]];
              });
              resultMap[key] = relation;
            }
          });
        }
      }
    }
    return classMirror.newInstance('fromJson', [
      resultMap
    ]);
  }


}