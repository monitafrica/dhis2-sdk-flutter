import 'package:dhis2sdk/core/dhis2_provider.dart';
import 'package:dhis2sdk/modules/datastore/datastore_provider.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:provider/provider.dart';
import 'package:dhis2sdk/modules/datastore/datastore_model_adapter.dart';
import 'package:dhis2sdk/modules/user/user.dart' as UserImport;
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
  static Credential credentials;
  static Config config;
  static UserModel User;
  static bool isLogingIn = false;
  static DHIS2Model dhis2Model;
  static DatastoreModel DataStoreModel;

  static List<ChangeNotifierProvider> initialize(Config config){
    DHIS2.config = config;
    List<ChangeNotifierProvider> changeNotifierProviders = [];

    DHIS2.User = UserModel();
    changeNotifierProviders.add(ChangeNotifierProvider<UserModel>(create: (context) => DHIS2.User));

    dhis2Model = DHIS2Model();
    changeNotifierProviders.add(ChangeNotifierProvider<DHIS2Model>(create: (context) => dhis2Model));


    DataStoreModel = DatastoreModel();
    changeNotifierProviders.add(ChangeNotifierProvider<DatastoreModel>(create: (context) => DHIS2.DataStoreModel));

    dhis2Model.loadCredential();
    return changeNotifierProviders;
  }

  static login(Credential credentials) async{
    DHIS2.isLogingIn = true;
    DHIS2.credentials = credentials;
    await DHIS2.User.initialize();

    UserImport.User currentUser = await DHIS2.User.authenticate();
    print(currentUser);

    await DataStoreModel.initialize();

    await dhis2Model.initialize();
    DHIS2.isLogingIn = false;


    return currentUser;
  }

  static logout() async{
    DHIS2.User.logout();
    DHIS2.credentials = null;
  }
}