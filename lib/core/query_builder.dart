
class Filter {
  String left;
  String operator;
  dynamic right;
  Filter({this.left,this.operator,this.right});
}

class SelectQuery {
  List<String> fields;
  List<String> where;
  SelectQuery({this.fields,this.where});
}
class OnlineQuery {
  String endpoint;
  String resultField;
  String fields;
  String where;
  Map<String,dynamic> parameters ={};
  OnlineQuery({this.fields,this.where,this.endpoint, this.resultField, this.parameters});
}

class WhereClauseException implements Exception {
  String msg;
  WhereClauseException(this.msg);
  String errMsg() => msg;
}
class QueryBuilder {

  List<String> fields = [];
  List<Filter> filters = [];
  OnlineQuery sOnlineQuery;

  OnlineQuery getOnlineQuery(){
    if(sOnlineQuery != null){
      return sOnlineQuery;
    }
    return OnlineQuery();
  }
  SelectQuery getQueryStructure(){
    List<String> where = [];
    List<String> fields = [];
    filters.forEach((element) {
      if(element.operator=='null'){
        where.add(element.left + ' is null');
      } else if(element.operator=='in'){
        where.add("${element.left} ${element.operator} ('${element.right.join("','")}')");
      } else if(element.right.runtimeType == String){
        where.add("${element.left} ${element.operator} '${element.right}'");
      }else if(element.right.runtimeType == int){
        where.add("${element.left} ${element.operator} ${element.right}");
      }else if(element.right.runtimeType == bool){
        where.add("${element.left} = ${element.right?1:0}");
      }else{
        throw WhereClauseException('Where clause of type ${element.right.runtimeType.toString()} does not exist');
      }
    });
    return SelectQuery(where: where,fields: fields);
  }

  QueryBuilder onlineQuery(OnlineQuery sOQ){
    sOnlineQuery = sOQ;
    return this;
  }
  QueryBuilder filter(Filter sFilter){
    filters.add(sFilter);
    return this;
  }

  QueryBuilder addField(String field){
    fields.add(field);
    return this;
  }
}