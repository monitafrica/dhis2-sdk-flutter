

import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/modules/event/event.dart';
import 'package:reflectable/reflectable.dart';

class EventField {
  final String fieldId;
  const EventField(this.fieldId);
}

class EventAdapter{

  final Event event;

  EventAdapter(this.event){
    //print(this.runtimeType);
    ClassMirror classMirror = Model.reflectType(this.runtimeType);
    InstanceMirror instanceMirror = Model.reflect(this);
    //instanceMirror.invokeSetter(setterName, value)
    for (String key in classMirror.declarations.keys) {
      var value = classMirror.declarations[key];
      if (value is VariableMirror) {
        VariableMirror variableMirror = value;
        variableMirror.metadata.forEach((element) {
          if (element is EventField) {
            instanceMirror.invokeSetter(variableMirror.simpleName, getValue(element.fieldId));
          }
        });
      }
    }
  }

  getValue(String dataElement){
    if(event.dataValues == null){
      return null;
    }
    List<DataValue> dataValues = event.dataValues.where((element) => element.dataElement == dataElement).toList();
    if(dataValues.length > 0){
      return dataValues.first.value;
    }else{
      return null;
    }
  }

  setValue(String dataElement, String value){
    if(event.dataValues == null){
      event.dataValues = new List<DataValue>();
    }
    bool valueExists = false;
    event.dataValues.forEach((element) {
      if(element.dataElement == dataElement){
        element.value = value;
        valueExists = true;
      }
    });
    if(!valueExists){
      event.dataValues.add(DataValue(dataElement: dataElement, value: value));
    }
  }
}