import './index.dart';

class TablesExplorer extends StatefulWidget {
  @override
  _TablesExplorerState createState() => _TablesExplorerState();
}

class _TablesExplorerState extends State<TablesExplorer> {
  TableModel chosenTable;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<TableModel>(
          value: chosenTable,
          onChanged: (TableModel value) {
            setState(() {
              chosenTable = value;
            });
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
      ],
    );
  }
}
