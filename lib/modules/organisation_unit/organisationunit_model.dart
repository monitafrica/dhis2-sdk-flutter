
import 'dart:convert';

import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/modules/organisation_unit/organisation_unit.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dio/dio.dart';

class OrganisationUnitModel extends ModelProvider{


  Future<void> initializeOfflineData() async{
    Credential credential = DHIS2.credentials;
    Response<dynamic> response = await this.client.get(credential.url + '/api/organisationUnits.json?fields=*&paging=false');
    List<dynamic> orgUnitMaps = response.data['organisationUnits'];
    for(dynamic ouMap in orgUnitMaps){
      await save(OrganisationUnit.fromJson(ouMap));
    }
    //await Future.wait(orgUnitMaps.map((ouMap)=>save(OrganisationUnit.fromJson(ouMap))));
    notifyListeners();
  }
}