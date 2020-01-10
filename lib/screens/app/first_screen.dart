import 'package:flutter/material.dart';

class FirstScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'FirstScreen',
      theme: new ThemeData(
        primarySwatch: Colors.teal,
        primaryColor: const Color(0xFF009688),
        accentColor: const Color(0xFF009688),
        canvasColor: const Color(0xFF167622),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const TextStyle optionStyle = TextStyle(color: Colors.white);

    @override
    Widget build(BuildContext context) {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text('Wallet dashboard'),
          backgroundColor: Colors.teal[900],
          leading: Icon(Icons.menu),
          actions: <Widget>[
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  //clicked(context, "Message sent");
                },
          ),
          ],
          ),
        body:
          new Container(
            padding: const EdgeInsets.all(0.0),
            alignment: Alignment.bottomCenter,
            decoration: new BoxDecoration(
            gradient: new LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.teal[900], Colors.lightGreen
              ],

              ),
            
            ),
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: false,
              children: <Widget>[
                Center(
                  child:Container(                 
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 20.0),
                        child:Text(
                            "Avaiable seeds",
                            style: TextStyle(
                              fontFamily: "worksans",
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.white
                            ),
                          ),
                      ),
                           Text(
                            "54.00",
                            style: TextStyle(
                              fontFamily: "worksans",
                              fontSize: 35,
                              //fontWeight: FontWeight.w600,
                              color: Colors.white
                            ),
                           ),
                           OutlineButton(
                              child: Text("Transfer"),
                              textColor: Colors.white,                              
                              onPressed: null,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),   
                              borderSide: BorderSide(
                                      color: Colors.white, style: BorderStyle.solid,width: 5),
                             ),
                    ],
                  )
                ),
                ),
                Container(
                   child: ListTile(title:Text("Bar Graph block")),
                ),
                Container(
                   child: ListTile(title:Text("Harvers block")),
                ),
              ]

            )
          ),
    
        bottomNavigationBar: new BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            new BottomNavigationBarItem(
              //icon: const Icon(Icons.people),
              icon: new Image.asset('assets/images/icon_people.png',width: 30,height: 30),
              title: new Text('People', style: optionStyle),
            ),
    
            new BottomNavigationBarItem(
              icon: new Image.asset('assets/images/icon_market.png',width: 30,height: 30),
              title: new Text('Market', style: optionStyle),
            ),
    
            new BottomNavigationBarItem(
              icon: new Image.asset('assets/images/seeds-logo.png',width: 70,height: 70),
              //icon: ImageIcon(AssetImage("assets/images/seeds-logo.png") ),
              title: new Text(''),
            ),
    
            new BottomNavigationBarItem(
              icon: new Image.asset('assets/images/icon_forum.png',width: 30,height: 30),
              title: new Text('Forum',style:optionStyle),
            ),
    
            new BottomNavigationBarItem(
              icon:new Image.asset('assets/images/icon_coop.png',width: 30,height: 30),
              //icon: const ImageIcon(AssetImage("assets/images/icon_coop.png")),
              title: new Text('Co-op',style: optionStyle),
            )
          ],
         
        //backgroundColor:  const Color(0x309a40),

        ),
      );
    }
}