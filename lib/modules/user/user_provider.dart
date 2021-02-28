import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'credential.dart';

class UserModel extends ModelProvider {
  User currentUser;
  authenticate() async {
    notifyListeners();
    Credential credentials = DHIS2.credentials;

    try {
      final String _userFields =
          'id,name,displayName,created,lastUpdated,email,firstName,surname,phoneNumber,userGroups[id,name],dataViewOrganisationUnits[id,name,level,parent[id,name]],organisationUnits[id,name,level,parent[id,name]],userCredentials[id,username,disabled,userRoles[id,name,authorities]],attributeValues[value,attribute[id,shortName]]';
      Response<dynamic> response = await this
          .client
          .get(credentials.url + '/api/me.json?fields=$_userFields');
      if (response.statusCode == 200) {
        // If the server did return a 200 OK response,
        // then parse the JSON.
        currentUser = User.fromJson(response.data);
        if (currentUser.attributeValues != null) {
          currentUser.attributeValues.map((e) => AttributeValues.fromJson(e));
        }
        // print('user ${json.encode(currentUser.attributeValues)}');
        await this.save<User>(currentUser);
        await this.save<Credential>(credentials);
        return currentUser;
      } else if (response.statusCode == 404) {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Server ${credentials.url} Not Found');
      } else {
        // If the server did not return a 200 OK response,
        // then throw an exception.
        throw Exception('Failed to load User');
      }
    } catch (e, s) {
      print('Error saving $e');
      if (e.message == 'Http status error [401]') {
        throw new Exception('NOT_AUTHENTICATED');
      } else if (e.message == 'Http status error [404]') {
        throw new Exception(
            'The URL ${credentials.url} was not found. Details:${e.message}');
      } else {
        print('Error saving $e');
        throw new Exception(e.message);
      }
    } finally {
      notifyListeners();
    }
  }

  logout() async {
    currentUser = null;
    await dbClient.deleteDb();
  }
}
