import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dhis2sdk/modules/user/user.dart';

import 'model_provider.dart';

class DHIS2Model  extends ModelProvider<Credential>{
  bool isInitializing = true;
  initialize() async {
    super.initialize();
    await this.save(DHIS2.credentials);
  }

  Future loadCredential() async {
    try{
      List<Credential> credentialList = await this.getAll();
      if(credentialList.length != 0 ){
        DHIS2.credentials = credentialList.first;
        List<User> users = await DHIS2.User.getAll();
        DHIS2.User.currentUser = users.first;
      }
    }catch(e){
      print('Error loading Credentials');
      print(e);
    } finally {
      finishedInitialize();
    }
  }
  void finishedInitialize() {
    isInitializing = false;
    print('Finished initializing Systme');
    notifyListeners();
  }
}