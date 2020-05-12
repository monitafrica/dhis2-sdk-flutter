

import 'package:dhis2sdk/modules/event/event.dart';

class EventAdapter{

  final Event event;

  const EventAdapter(this.event);

  getValue(String dataElement){
    if(event.dataValues == null){
      return null;
    }
    List<DataValue> dataValues = event.dataValues.where((element) => element.dataElement == dataElement).toList();
    if(dataValues.length > 0){
      return dataValues[0].value;
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
      print('Adding Events');
      event.dataValues.add(DataValue(dataElement: dataElement, value: value));
      print(event.dataValues);
    }
  }
}