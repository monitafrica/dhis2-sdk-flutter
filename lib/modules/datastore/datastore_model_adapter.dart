
import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/modules/datastore/datastore.dart';

@Model
class DatastoreAdapter extends Datastore {

  final String namespace;

  DatastoreAdapter({this.namespace});
}
