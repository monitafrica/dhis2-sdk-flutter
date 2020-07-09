

import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/modules/tracker/tracked_entity_instance.dart';
import 'package:reflectable/reflectable.dart';

class AttributeField {
  final String fieldId;
  const AttributeField(this.fieldId);
}

class TrackerAdapter extends TrackedEntityInstance{

  getValue(String attribute){
    if(this.attributes == null){
      return null;
    }
    List<Attribute> attributes = this.attributes.where((element) => element.attribute == attribute).toList();
    if(attributes.length > 0){
      return attributes.first.value;
    }else{
      return null;
    }
  }

  setValue(String attribute, String value){
    if(this.attributes == null){
      this.attributes = new List<Attribute>();
    }
    bool valueExists = false;
    this.attributes.forEach((element) {
      if(element.attribute == attribute){
        element.value = value;
        valueExists = true;
      }
    });
    if(!valueExists){
      this.attributes.add(Attribute(attribute: attribute, value: value));
    }
  }
}