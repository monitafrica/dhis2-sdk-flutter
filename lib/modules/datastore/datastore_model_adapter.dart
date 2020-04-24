
import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/modules/datastore/datastore.dart';

@Model
class DatastoreAdapter extends DataStore {

  final String namespace;

  DatastoreAdapter({this.namespace});
}
