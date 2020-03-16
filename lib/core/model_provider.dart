
import 'package:flutter/foundation.dart';
import 'package:reflectable/reflectable.dart';

import 'database_provider.dart';
import 'http_provider.dart';
import 'model.dart';


abstract class ModelProvider<T> extends ChangeNotifier {

  DHISHttpClient client = new DHISHttpClient();
  DatabaseHelper dbClient = new DatabaseHelper();


  initialize() async {
    create_table(T);
    initializeOfflineData();
  }

  Future create_table(Type type) async{
    ClassMirror classMirror = Model.reflectType(type);
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
          await create_table(variableMirror.reflectedType);
        }
      }
    }
    await dbClient.create_table(classMirror.simpleName.toLowerCase(),columns);
  }

  Future<T> save(T model) async{
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
  Future<List<T>> getAll() async{
    ClassMirror classMirror = Model.reflectType(T);
    print(classMirror.simpleName.toLowerCase());
    return (await dbClient.getAllItems(classMirror.simpleName.toLowerCase())).map((e){
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
}