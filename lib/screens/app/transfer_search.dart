import 'package:flutter/material.dart';
import 'package:material_search/material_search.dart';

const _list = const [
    'Igor Minar',
    'Brad Green',
    'Dave Geddes',
    'Naomi Black',
    'Greg Weber',
    'Dean Sofer',
    'Wes Alvaro',
    'John Scott',
    'Daniel Nadasi',
];

// class TransferSearch extends StatefulWidget {
//   //const TransferSearch({Key key}) : super(key: key);
//   //TransferSearch();
//   @override
//   TransferSearchState createState() => TransferSearchState();
// }

//class TransferSearchState extends State<TransferSearch> {
class TransferSearch extends StatelessWidget {
  //String _selected;
  //@override
  // void initState() {
  //     super.initState();
  //     this._selected = '';
  // }

  @override
  Widget build(BuildContext context) {       
    return 
    Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
                    border: Border(
                    bottom: BorderSide(width: 1, color: Colors.green),
              ),
      ),
      alignment: Alignment.topLeft,
      child:
       //Text('text')
       new MaterialSearch<String>(
        limit: 10,        
        results: _list.map((name) => new MaterialSearchResult<String>(
              value: name, //The value must be of type <String>
              text: name, //String that will be show in the list
              icon: Icons.person,
            )).toList(),
        placeholder: 'Search',
        onSelect: (String selected) {
          print(selected);
           if (selected == null) {            
              return;
          }
          // setState(() {
          // this._selected = selected;
          // });
        },
        //callback when the value is submitted, optional.
        onSubmit: (String value) {
          print(value);
        },
        
      )
    );
   
  }
}