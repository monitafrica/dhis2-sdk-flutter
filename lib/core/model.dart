
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
class Resource {
  final String endpoint;
  const Resource({this.endpoint});
}
class MapField {
  final String field;
  final Type type;
  const MapField({this.field, this.type});
}
class Column {
  final Map<String,MapField> map;
  const Column({this.map});
}

class Relation {
  final String columnId;
  final String refferenceId;
  const Relation({this.refferenceId, this.columnId});
}
class OneToOne {
  final Relation relation;
  const OneToOne({this.relation});
}