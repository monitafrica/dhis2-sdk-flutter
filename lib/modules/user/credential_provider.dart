import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dhis2sdk/modules/user/user.dart';


class CredentialModel  extends ModelProvider{
  bool isInitializing = true;
  initialize<T>() async {
    super.initialize<Credential>();
    await this.save<Credential>(DHIS2.credentials);
  }

  Future loadCredential() async {
    try{
      List<Credential> credentialList = await this.getAll<Credential>();
      if(credentialList.length != 0 ){
        DHIS2.credentials = credentialList.first;
        List<User> users = await DHIS2.User.getAll<User>();
        DHIS2.User.currentUser = users.first;
      }
    }catch(e, s){
      print(e);
      print(s);
    } finally {
      finishedInitialize();
    }
    print('Heutwe');
    return DHIS2.User.currentUser;
  }
  void finishedInitialize() {
    isInitializing = false;
    //notifyListeners();
  }
}