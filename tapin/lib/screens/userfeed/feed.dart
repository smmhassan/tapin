
import 'package:tapin/screens/userfeed/swipe.dart';
import 'package:flutter/material.dart';
import 'package:tapin/widgets/tabbedwindow/UserSettingsTabbed.dart';


void main() => runApp(new Feed());

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: new Center(
        child: MyHomePage(title: 'Tap-in main feed'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}
int _selectedIndex = 0;

class _MyHomePageState extends State<MyHomePage> {

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
          child: Tinder()
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        elevation: 0,
        selectedFontSize: 20,
        unselectedIconTheme: IconThemeData(color: Colors.purpleAccent[100], size: 30),
        unselectedItemColor: Colors.purpleAccent[100],
        selectedIconTheme: IconThemeData(color: Colors.purpleAccent[100], size: 40),
        selectedItemColor: Colors.purpleAccent[100],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',

          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}