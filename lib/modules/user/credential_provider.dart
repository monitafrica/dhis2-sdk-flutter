import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dhis2sdk/modules/user/user.dart';


class CredentialModel  extends ModelProvider{
  bool isInitializing = true;
  Future<User> loadCredential() async {
    try{
      List<Credential> credentialList = await this.getAll<Credential>();
      if(credentialList.length != 0 ){
        DHIS2.credentials = credentialList.first;
        List<User> users = await DHIS2.User.getAll<User>();
        return users.first;
      }
    }catch(e, s){

    } finally {
      finishedInitialize();
    }
    return null;
  }
  void finishedInitialize() {
    isInitializing = false;
    //notifyListeners();
  }
}