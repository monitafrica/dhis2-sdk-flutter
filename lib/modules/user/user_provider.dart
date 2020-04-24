
import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:dio/dio.dart';

import 'credential.dart';

class UserModel extends ModelProvider{
  bool isAuthenticating = false;
  User currentUser;
  authenticate() async {
    isAuthenticating = true;
    notifyListeners();
    Credential credentials = DHIS2.credentials;

    try{
      Response<dynamic> response = await this.client.get(credentials.url + '/api/me');
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        currentUser = User.fromJson(response.data);
        await this.save<User>(currentUser);
        return currentUser;
      } else if(response.statusCode == 404){
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Server ${credentials.url} Not Found');
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load User');
      }
    }catch(e){
      if(e.message == 'Http status error [401]'){
        throw new Exception('NOT_AUTHENTICATED');
      } else if(e.message == 'Http status error [404]'){
        throw new Exception('The URL ${credentials.url} was not found. Details:${e.message}');
      } else {
        throw new Exception(e.message);
      }
    }finally{
      isAuthenticating = false;
      notifyListeners();
    }
  }

  logout() async {
    currentUser = null;
    await dbClient.deleteDb();
  }

}