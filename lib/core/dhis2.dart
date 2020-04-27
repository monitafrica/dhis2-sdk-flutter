import 'package:dhis2sdk/modules/datastore/datastore.dart' as DatastoreImport;
import 'package:dhis2sdk/modules/datastore/datastore_adapter_provider.dart';
import 'package:dhis2sdk/modules/datastore/datastore_provider.dart';
import 'package:dhis2sdk/modules/event/event_model.dart';
import 'package:dhis2sdk/modules/organisation_unit/organisation_unit.dart' as OrgUnitImport;
import 'package:dhis2sdk/modules/organisation_unit/organisationunit_model.dart';
import 'package:dhis2sdk/modules/user/credential.dart' as CredentialImport;
import 'package:dhis2sdk/modules/user/credential_provider.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:provider/provider.dart';
import 'package:dhis2sdk/modules/datastore/datastore_model_adapter.dart';
import 'package:dhis2sdk/modules/user/user.dart' as UserImport;
import 'package:dhis2sdk/modules/event/event.dart' as EventImport;
import 'package:dhis2sdk/modules/user/user_provider.dart';

class Config{
  List<Type> dataStoreAdapters;
  Config({this.dataStoreAdapters});
}
class MProviders{
  static UserModel user;
  get User => user;
  set User(u){
    user=u;
  }
}
/// A DHIS2 Instance.
class DHIS2 {
  static CredentialImport.Credential credentials;
  static Config config;
  static final UserModel User = UserModel();
  static bool isLogingIn = false;
  static final CredentialModel Credential = CredentialModel();
  static OrganisationUnitModel OrganisationUnit = OrganisationUnitModel();
  static DatastoreModel Datastore= DatastoreModel();
  static DatastoreAdapterModel DatastoreAdapter = DatastoreAdapterModel();
  static EventModel Event = EventModel();

  static List<ChangeNotifierProvider> initialize(Config config){
    DHIS2.config = config;
    List<ChangeNotifierProvider> changeNotifierProviders = [];

    changeNotifierProviders.add(ChangeNotifierProvider<UserModel>(create: (context) => DHIS2.User));

    changeNotifierProviders.add(ChangeNotifierProvider<CredentialModel>(create: (context) => DHIS2.Credential));

    changeNotifierProviders.add(ChangeNotifierProvider<DatastoreModel>(create: (context) => DHIS2.Datastore));

    changeNotifierProviders.add(ChangeNotifierProvider<DatastoreAdapterModel>(create: (context) => DHIS2.DatastoreAdapter));

    changeNotifierProviders.add(ChangeNotifierProvider<OrganisationUnitModel>(create: (context) => DHIS2.OrganisationUnit));

    changeNotifierProviders.add(ChangeNotifierProvider<EventModel>(create: (context) => DHIS2.Event));

    DHIS2.Credential.loadCredential();

    //OrganisationUnit.initialize<OrgUnitImport.OrganisationUnit>();

    /*DHIS2.Datastore.initialize<DatastoreImport.Datastore>().then((value){
      DHIS2.Datastore.getAll<DatastoreImport.Datastore>().then((value){

      });
    });*/
    return changeNotifierProviders;
  }

  static login(CredentialImport.Credential credentials) async{
    DHIS2.isLogingIn = true;
    DHIS2.credentials = credentials;
    await DHIS2.User.initialize<UserImport.User>();

    UserImport.User currentUser = await DHIS2.User.authenticate();

    await DHIS2.Datastore.initialize<DatastoreImport.DataStore>();

    await DHIS2.Credential.initialize<CredentialImport.Credential>();

    await DHIS2.OrganisationUnit.initialize<OrgUnitImport.OrganisationUnit>();

    await DHIS2.Event.initialize<EventImport.Event>();
    DHIS2.isLogingIn = false;


    return currentUser;
  }

  static logout() async{
    DHIS2.User.logout();
    DHIS2.credentials = null;
  }
}