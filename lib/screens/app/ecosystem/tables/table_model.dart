import './index.dart';

class TableModel {
  final String name;
  final String code;
  final String table;
  final String scope;

  TableModel({
    this.name,
    @required this.code,
    @required this.table,
    this.scope,
  });
}
