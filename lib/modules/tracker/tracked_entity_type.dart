
import 'package:dhis2sdk/core/model.dart';

@Model
class TrackedEntityType {
  String lastUpdated;
  String id;
  String href;
  String created;
  String name;
  String displayName;
  String publicAccess;
  String description;
  bool externalAccess;
  bool allowAuditLog;
  String featureType;
  int minAttributesRequiredToSearch;
  String displayDescription;
  int maxTeiCountToReturn;
  bool favorite;
  Access access;
  LastUpdatedBy lastUpdatedBy;
  LastUpdatedBy user;
  List<TrackedEntityTypeAttributes> trackedEntityTypeAttributes;

  TrackedEntityType(
      {this.lastUpdated,
        this.id,
        this.href,
        this.created,
        this.name,
        this.displayName,
        this.publicAccess,
        this.description,
        this.externalAccess,
        this.allowAuditLog,
        this.featureType,
        this.minAttributesRequiredToSearch,
        this.displayDescription,
        this.maxTeiCountToReturn,
        this.favorite,
        this.access,
        this.lastUpdatedBy,
        this.user,
        this.trackedEntityTypeAttributes});

  TrackedEntityType.fromJson(Map<String, dynamic> json) {
    lastUpdated = json['lastUpdated'];
    id = json['id'];
    href = json['href'];
    created = json['created'];
    name = json['name'];
    displayName = json['displayName'];
    publicAccess = json['publicAccess'];
    description = json['description'];
    externalAccess = json['externalAccess'];
    allowAuditLog = json['allowAuditLog'];
    featureType = json['featureType'];
    minAttributesRequiredToSearch = json['minAttributesRequiredToSearch'];
    displayDescription = json['displayDescription'];
    maxTeiCountToReturn = json['maxTeiCountToReturn'];
    favorite = json['favorite'];
    access =
    json['access'] != null ? new Access.fromJson(json['access']) : null;
    lastUpdatedBy = json['lastUpdatedBy'] != null
        ? new LastUpdatedBy.fromJson(json['lastUpdatedBy'])
        : null;
    user =
    json['user'] != null ? new LastUpdatedBy.fromJson(json['user']) : null;
    if (json['trackedEntityTypeAttributes'] != null) {
      trackedEntityTypeAttributes = new List<TrackedEntityTypeAttributes>();
      json['trackedEntityTypeAttributes'].forEach((v) {
        trackedEntityTypeAttributes
            .add(new TrackedEntityTypeAttributes.fromJson(v));
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
    data['displayName'] = this.displayName;
    data['publicAccess'] = this.publicAccess;
    data['description'] = this.description;
    data['externalAccess'] = this.externalAccess;
    data['allowAuditLog'] = this.allowAuditLog;
    data['featureType'] = this.featureType;
    data['minAttributesRequiredToSearch'] = this.minAttributesRequiredToSearch;
    data['displayDescription'] = this.displayDescription;
    data['maxTeiCountToReturn'] = this.maxTeiCountToReturn;
    data['favorite'] = this.favorite;
    if (this.access != null) {
      data['access'] = this.access.toJson();
    }
    if (this.lastUpdatedBy != null) {
      data['lastUpdatedBy'] = this.lastUpdatedBy.toJson();
    }
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    if (this.trackedEntityTypeAttributes != null) {
      data['trackedEntityTypeAttributes'] =
          this.trackedEntityTypeAttributes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Access {
  bool read;
  bool update;
  bool externalize;
  bool delete;
  bool write;
  bool manage;
  Data data;

  Access(
      {this.read,
        this.update,
        this.externalize,
        this.delete,
        this.write,
        this.manage,
        this.data});

  Access.fromJson(Map<String, dynamic> json) {
    read = json['read'];
    update = json['update'];
    externalize = json['externalize'];
    delete = json['delete'];
    write = json['write'];
    manage = json['manage'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['read'] = this.read;
    data['update'] = this.update;
    data['externalize'] = this.externalize;
    data['delete'] = this.delete;
    data['write'] = this.write;
    data['manage'] = this.manage;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  bool read;
  bool write;

  Data({this.read, this.write});

  Data.fromJson(Map<String, dynamic> json) {
    read = json['read'];
    write = json['write'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['read'] = this.read;
    data['write'] = this.write;
    return data;
  }
}

class LastUpdatedBy {
  String id;

  LastUpdatedBy({this.id});

  LastUpdatedBy.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    return data;
  }
}

class TrackedEntityTypeAttributes {
  String lastUpdated;
  String id;
  String created;
  String name;
  String displayName;
  bool mandatory;
  String displayShortName;
  bool externalAccess;
  String valueType;
  bool searchable;
  bool displayInList;
  bool favorite;
  Access access;
  LastUpdatedBy trackedEntityAttribute;
  LastUpdatedBy trackedEntityType;
  List<Null> favorites;
  List<Null> translations;
  List<Null> userGroupAccesses;
  List<Null> attributeValues;
  List<Null> userAccesses;

  TrackedEntityTypeAttributes(
      {this.lastUpdated,
        this.id,
        this.created,
        this.name,
        this.displayName,
        this.mandatory,
        this.displayShortName,
        this.externalAccess,
        this.valueType,
        this.searchable,
        this.displayInList,
        this.favorite,
        this.access,
        this.trackedEntityAttribute,
        this.trackedEntityType,
        this.favorites,
        this.translations,
        this.userGroupAccesses,
        this.attributeValues,
        this.userAccesses});

  TrackedEntityTypeAttributes.fromJson(Map<String, dynamic> json) {
    lastUpdated = json['lastUpdated'];
    id = json['id'];
    created = json['created'];
    name = json['name'];
    displayName = json['displayName'];
    mandatory = json['mandatory'];
    displayShortName = json['displayShortName'];
    externalAccess = json['externalAccess'];
    valueType = json['valueType'];
    searchable = json['searchable'];
    displayInList = json['displayInList'];
    favorite = json['favorite'];
    access =
    json['access'] != null ? new Access.fromJson(json['access']) : null;
    trackedEntityAttribute = json['trackedEntityAttribute'] != null
        ? new LastUpdatedBy.fromJson(json['trackedEntityAttribute'])
        : null;
    trackedEntityType = json['trackedEntityType'] != null
        ? new LastUpdatedBy.fromJson(json['trackedEntityType'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdated'] = this.lastUpdated;
    data['id'] = this.id;
    data['created'] = this.created;
    data['name'] = this.name;
    data['displayName'] = this.displayName;
    data['mandatory'] = this.mandatory;
    data['displayShortName'] = this.displayShortName;
    data['externalAccess'] = this.externalAccess;
    data['valueType'] = this.valueType;
    data['searchable'] = this.searchable;
    data['displayInList'] = this.displayInList;
    data['favorite'] = this.favorite;
    if (this.access != null) {
      data['access'] = this.access.toJson();
    }
    if (this.trackedEntityAttribute != null) {
      data['trackedEntityAttribute'] = this.trackedEntityAttribute.toJson();
    }
    if (this.trackedEntityType != null) {
      data['trackedEntityType'] = this.trackedEntityType.toJson();
    }
    return data;
  }
}
