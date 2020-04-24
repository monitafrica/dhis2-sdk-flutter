
import 'dart:convert';

import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/core/query_builder.dart';
import 'package:dhis2sdk/modules/organisation_unit/organisation_unit.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dio/dio.dart';

class OrganisationUnitModel extends ModelProvider{


  Future<void> initializeOfflineData() async{
    Credential credential = DHIS2.credentials;
    Response<dynamic> response = await this.client.get(credential.url + '/api/organisationUnits.json?fields=lastUpdated,id,href,level,created,name,shortName,code,leaf,path,favorite,dimensionItemType,displayName,displayShortName,externalAccess,openingDate,dimensionItem,path&paging=false');
    List<dynamic> orgUnitMaps = response.data['organisationUnits'];
    for(dynamic ouMap in orgUnitMaps){
      await save(OrganisationUnit.fromJson(ouMap));
      try{

      }catch(e){
        print(e);
      }
    }
    //await Future.wait(orgUnitMaps.map((ouMap)=>save(OrganisationUnit.fromJson(ouMap))));
    notifyListeners();
  }
  Future<List<OrganisationUnit>> getRoots<T>() async {
    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.filter(Filter(left:"parent",operator: 'null'));
    return await getByQuery<OrganisationUnit>(queryBuilder);
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
  Future<List<OrganisationUnit>> getUserRoots<T>() async {
    QueryBuilder queryBuilder = QueryBuilder();
    //DHIS2.User.currentUser.
    queryBuilder.filter(Filter(left:"parent",operator: 'null'));
    return await getByQuery<OrganisationUnit>(queryBuilder);
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
  Future<List<OrganisationUnit>> getChildren(String parentId) async {
    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.filter(Filter(left:"parent",operator: '=', right: parentId));
    return await getByQuery<OrganisationUnit>(queryBuilder);
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
}