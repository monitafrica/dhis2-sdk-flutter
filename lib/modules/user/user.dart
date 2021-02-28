import 'dart:convert';

import 'package:dhis2sdk/core/model.dart';
import 'package:dhis2sdk/modules/organisation_unit/organisation_unit.dart';

@Model
class User implements ModelInterface {
  @PrimaryKey()
  String id;
  String lastUpdated;
  String href;
  String created;
  String name;
  String birthday;
  String education;
  String gender;
  String displayName;
  String jobTitle;
  String surname;
  String employer;
  String introduction;
  String email;
  String languages;
  String lastCheckedInterpretations;
  String firstName;
  String phoneNumber;
  String nationality;
  String interests;
  @Column()
  List<AttributeValues> attributeValues;
  @Column()
  UserCredentials userCredentials;

  @Column()
  List<OrganisationUnit> organisationUnits;

  User(
      {this.lastUpdated,
      this.id,
      this.href,
      this.created,
      this.name,
      this.birthday,
      this.education,
      this.gender,
      this.displayName,
      this.jobTitle,
      this.surname,
      this.employer,
      this.introduction,
      this.email,
      this.languages,
      this.lastCheckedInterpretations,
      this.firstName,
      this.phoneNumber,
      this.nationality,
      this.interests,
      this.attributeValues,
      this.userCredentials});

  User.fromJson(Map<String, dynamic> json) {
    lastUpdated = json['lastUpdated'];
    id = json['id'];
    href = json['href'];
    created = json['created'];
    name = json['name'];
    birthday = json['birthday'];
    education = json['education'];
    gender = json['gender'];
    displayName = json['displayName'];
    jobTitle = json['jobTitle'];
    surname = json['surname'];
    employer = json['employer'];
    introduction = json['introduction'];
    email = json['email'];
    languages = json['languages'];
    lastCheckedInterpretations = json['lastCheckedInterpretations'];
    firstName = json['firstName'];
    phoneNumber = json['phoneNumber'];
    nationality = json['nationality'];
    interests = json['interests'];
    if (json['attributeValues'] != null) {
      attributeValues = new List<AttributeValues>();
      json['attributeValues'].forEach(
          (attr) => {attributeValues.add(new AttributeValues.fromJson(attr))});
    }
    if (json['userCredentials'].runtimeType == String) {
      json['userCredentials'] = jsonDecode(json['userCredentials']);
    }
    userCredentials = json['userCredentials'] != null
        ? new UserCredentials.fromJson(json['userCredentials'])
        : null;
    if (json['organisationUnits'] != null) {
      organisationUnits = new List<OrganisationUnit>();
      json['organisationUnits'].forEach((v) {
        organisationUnits.add(new OrganisationUnit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdated'] = this.lastUpdated;
    data['id'] = this.id;
    data['href'] = this.href;
    data['created'] = this.created;
    data['name'] = this.name;
    data['birthday'] = this.birthday;
    data['education'] = this.education;
    data['gender'] = this.gender;
    data['displayName'] = this.displayName;
    data['jobTitle'] = this.jobTitle;
    data['surname'] = this.surname;
    data['employer'] = this.employer;
    data['introduction'] = this.introduction;
    data['email'] = this.email;
    data['languages'] = this.languages;
    data['lastCheckedInterpretations'] = this.lastCheckedInterpretations;
    data['firstName'] = this.firstName;
    data['phoneNumber'] = this.phoneNumber;
    data['nationality'] = this.nationality;
    data['interests'] = this.interests;
    if (this.attributeValues != null) {
      data['attributeValues'] = this.attributeValues.map((e) => e.toJson());
    }
    if (this.userCredentials != null) {
      data['userCredentials'] = this.userCredentials.toJson();
    }
    if (this.organisationUnits != null) {
      data['organisationUnits'] =
          this.organisationUnits.map((v) => v.toJson()).toList();
    }
    return data;
  }

  getValue(attribute) {
    return this
        .attributeValues
        .firstWhere((attr) => attr.attribute == attribute)
        .value;
  }
}

@Model
class AttributeValues {
  @PrimaryKey()
  String attribute;
  String value;

  AttributeValues({this.attribute, this.value});
  AttributeValues.fromJson(json) {
    if (json['attribute'] is Map) {
      attribute = json['attribute']['id'];
      value = json['value'];
    } else {
      attribute = json['attribute'];
      value = json['value'];
    }
  }

  toJson() {
    return {
      'attribute': {'id': this.attribute},
      'value': this.value
    };
  }
}

@Model
class UserCredentials {
  String code;
  String lastUpdated;
  String id;
  String created;
  String name;
  String lastLogin;
  String displayName;
  bool externalAuth;
  bool externalAccess;
  bool disabled;
  bool twoFA;
  String passwordLastUpdated;
  bool invitation;
  bool selfRegistered;
  bool favorite;
  String username;

  UserCredentials({
    this.code,
    this.lastUpdated,
    this.id,
    this.created,
    this.name,
    this.lastLogin,
    this.displayName,
    this.externalAuth,
    this.externalAccess,
    this.disabled,
    this.twoFA,
    this.passwordLastUpdated,
    this.invitation,
    this.selfRegistered,
    this.favorite,
    this.username,
  });

  UserCredentials.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    lastUpdated = json['lastUpdated'];
    id = json['id'];
    created = json['created'];
    name = json['name'];
    lastLogin = json['lastLogin'];
    displayName = json['displayName'];
    externalAuth = json['externalAuth'];
    externalAccess = json['externalAccess'];
    disabled = json['disabled'];
    twoFA = json['twoFA'];
    passwordLastUpdated = json['passwordLastUpdated'];
    invitation = json['invitation'];
    selfRegistered = json['selfRegistered'];
    favorite = json['favorite'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['lastUpdated'] = this.lastUpdated;
    data['id'] = this.id;
    data['created'] = this.created;
    data['name'] = this.name;
    data['lastLogin'] = this.lastLogin;
    data['displayName'] = this.displayName;
    data['externalAuth'] = this.externalAuth;
    data['externalAccess'] = this.externalAccess;
    data['disabled'] = this.disabled;
    data['twoFA'] = this.twoFA;
    data['passwordLastUpdated'] = this.passwordLastUpdated;
    data['invitation'] = this.invitation;
    data['selfRegistered'] = this.selfRegistered;
    data['favorite'] = this.favorite;
    data['username'] = this.username;
    return data;
  }
}

class UserInfo {
  String id;

  UserInfo({this.id});

  UserInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}
