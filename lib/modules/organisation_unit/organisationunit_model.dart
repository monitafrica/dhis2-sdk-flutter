
import 'dart:convert';

import 'package:dhis2sdk/core/dhis2.dart';
import 'package:dhis2sdk/core/model_provider.dart';
import 'package:dhis2sdk/core/query_builder.dart';
import 'package:dhis2sdk/modules/organisation_unit/organisation_unit.dart';
import 'package:dhis2sdk/modules/user/credential.dart';
import 'package:dhis2sdk/modules/user/user.dart';
import 'package:dio/dio.dart';

class OrganisationUnitModel extends ModelProvider{


  Future<void> initializeOfflineData() async{

  }

  Future downloadAll([onProgress]) async{
    Credential credential = DHIS2.credentials;
    Map<String,dynamic> pager = {
      'page': 0
    };
    do{
      pager['page']++;
      Response<dynamic> response = await this.client.get(credential.url + '/api/organisationUnits.json?fields=lastUpdated,id,href,level,name,shortName,code,path,displayName,openingDate,path,parent,geometry&pageSize=1000&page=${pager['page']}');
      List<dynamic> orgUnitMaps = response.data['organisationUnits'];
      pager = response.data['pager'];
      for(dynamic ouMap in orgUnitMaps){
        await save<OrganisationUnit>(OrganisationUnit.fromJson(ouMap));
      }
      if(onProgress != null){
        onProgress(pager['page'] * pager['pageSize']/pager['total']);
      }
    }while(pager['page'] != pager['pageCount']);
    notifyListeners();
  }
  Future<List<OrganisationUnit>> getRoots<T>() async {
    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.filter(Filter(left:"parent",operator: 'null'));
    return await getByQuery<OrganisationUnit>(queryBuilder);
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
  Future<List<OrganisationUnit>> getUserRoots<T>() async {
    User user = await DHIS2.Credential.loadCredential();
    QueryBuilder queryBuilder = QueryBuilder();
    print(user.organisationUnits);
    queryBuilder.filter(Filter(left:"id",operator: 'in',right: user.organisationUnits.map((e) => e.id)));
    return await getByQuery<OrganisationUnit>(queryBuilder);
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
  Future<List<OrganisationUnit>> getChildren(String parentId) async {
    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.filter(Filter(left:"parent",operator: 'like', right: '%' + parentId + '%'));
    return await getByQuery<OrganisationUnit>(queryBuilder);
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }

  Future<OrganisationUnit> getById(String id) async {
    QueryBuilder queryBuilder = QueryBuilder();
    queryBuilder.filter(Filter(left:"id",operator: '==', right: id));
    List<OrganisationUnit> ous = await getByQuery<OrganisationUnit>(queryBuilder);
    if(ous.length > 0){
      return ous[0];
    }
    return null;
    //return await dbClient.getAllItems(classMirror.simpleName.toLowerCase());
  }
  Future<List<OrganisationUnit>> getAncestors(String id) async {
    OrganisationUnit organisationUnit = await getById(id);
    if(organisationUnit != null){
      QueryBuilder queryBuilder = QueryBuilder();
      queryBuilder.filter(Filter(left:"id",operator: 'in', right: organisationUnit.path.split('/')));
      return await getByQuery<OrganisationUnit>(queryBuilder);
    }else{
      return [];
    }
  }
}