import 'index.dart';

class Tables extends StatefulWidget {
  static final List<Provider> devProviders = [
    Provider(
      create: (_) => HttpService()..mockResponse = true,
    ),
  ];

  @override
  _TablesState createState() => _TablesState();
}

class _TablesState extends State<Tables> {
  TableModel chosenTable;
  int x;

  void initState() {
    super.initState();
    setState(() {
      chosenTable = contractTables[0];
    });
  }

  Future fetchTable() async {
    print("fetchTable ${chosenTable.name}");

    return HttpService.of(context).getTableRows(
      code: chosenTable.code,
      scope: chosenTable.scope,
      table: chosenTable.table,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Theme.of(context).canvasColor,
          elevation: 0,
          title: Text(
            "Explore Data".i18n,
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<TableModel>(
              value: chosenTable,
              onChanged: (TableModel value) {
                setState(() {
                  chosenTable = value;
                });
                fetchTable();
              },
              items: contractTables
                  .map<DropdownMenuItem<TableModel>>((TableModel value) {
                return DropdownMenuItem<TableModel>(
                    value: value,
                    child: Text(
                      value.name,
                    ));
              }).toList(),
            ),
            Text(
              "Code ${chosenTable.code}, Scope ${chosenTable.scope}, Table ${chosenTable.table}",
            ),
            FutureBuilder(
              future: fetchTable(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final tableData = snapshot.data;

                  if (tableData != null && tableData.isNotEmpty) {
                    return DataTable(
                      columns: tableData[0]
                          .keys
                          .map<DataColumn>(
                            (key) => DataColumn(label: Text(key)),
                          )
                          .toList(),
                      rows: tableData.map<DataRow>((item) {
                        return DataRow(
                          cells: item.values
                              .map<DataCell>(
                                (value) => DataCell(Text(value.toString())),
                              )
                              .toList(),
                        );
                      }).toList(),
                    );
                  } else {
                    return Text('Table is empty');
                  }
                } else {
                  return LinearProgressIndicator();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
