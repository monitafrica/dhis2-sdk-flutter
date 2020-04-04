
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

class QueryBuilder {

  List<String> fields = [];
  List<Filter> filters = [];
  Map<String,dynamic> parameters ={};

  String getUrl(){

  }
  SelectQuery getQueryStructure(){
    List<String> where = [];
    List<String> fields = [];
    filters.forEach((element) {
      if(element.operator=='null'){
        where.add(element.left + ' is null');
      }else if(element.right.runtimeType == String){
        where.add("${element.left} ${element.operator} '${element.right}'");
      }else if(element.right.runtimeType == int){
        where.add("${element.left} ${element.operator} ${element.right}");
      }else{

        print(element.right.runtimeType);

      }
    });
    return SelectQuery(where: where,fields: fields);
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