
import 'package:dhis2sdk/core/model.dart';

class ColumnMap {
  final Map<String,String> map;
  const ColumnMap({this.map});
}

@Model
class OrganisationUnit {
  String lastUpdated;
  String id;
  String href;
  int level;
  String created;
  String name;
  String shortName;
  String code;
  bool leaf;
  String path;
  bool favorite;
  String dimensionItemType;
  String displayName;
  String displayShortName;
  bool externalAccess;
  String openingDate;
  String dimensionItem;

  @ColumnMap(map: {"id":"parent"})
  OrganisationUnit parent;

  OrganisationUnit(
      {this.lastUpdated,
        this.id,
        this.href,
        this.level,
        this.created,
        this.name,
        this.shortName,
        this.code,
        this.leaf,
        this.path,
        this.favorite,
        this.dimensionItemType,
        this.displayName,
        this.displayShortName,
        this.externalAccess,
        this.openingDate,
        this.dimensionItem,
        this.parent});

  OrganisationUnit.fromJson(Map<String, dynamic> json) {
    lastUpdated = json['lastUpdated'];
    id = json['id'];
    href = json['href'];
    level = json['level'];
    created = json['created'];
    name = json['name'];
    shortName = json['shortName'];
    code = json['code'];
    leaf = json['leaf'];
    path = json['path'];
    favorite = json['favorite'];
    dimensionItemType = json['dimensionItemType'];
    displayName = json['displayName'];
    displayShortName = json['displayShortName'];
    externalAccess = json['externalAccess'];
    openingDate = json['openingDate'];
    dimensionItem = json['dimensionItem'];
    parent =
    json['parent'] != null ? new OrganisationUnit.fromJson(json['parent']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdated'] = this.lastUpdated;
    data['id'] = this.id;
    data['href'] = this.href;
    data['level'] = this.level;
    data['created'] = this.created;
    data['name'] = this.name;
    data['shortName'] = this.shortName;
    data['code'] = this.code;
    data['leaf'] = this.leaf;
    data['path'] = this.path;
    data['favorite'] = this.favorite;
    data['dimensionItemType'] = this.dimensionItemType;
    data['displayName'] = this.displayName;
    data['displayShortName'] = this.displayShortName;
    data['externalAccess'] = this.externalAccess;
    data['openingDate'] = this.openingDate;
    data['dimensionItem'] = this.dimensionItem;
    if (this.parent != null) {
      data['parent'] = this.parent.toJson();
    }
    return data;
  }
}
