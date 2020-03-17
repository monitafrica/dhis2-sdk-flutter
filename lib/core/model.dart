
import 'package:reflectable/reflectable.dart';

class ModelReflectable extends Reflectable {
  const ModelReflectable() : super(invokingCapability,declarationsCapability,reflectedTypeCapability,newInstanceCapability, metadataCapability);
}

const Model = ModelReflectable();

class ModelInterface {

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    return data;
  }
}