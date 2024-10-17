import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/calendar.dart';
import 'package:travel_app/screens/cities_list.dart';
import 'package:travel_app/screens/logIn.dart';
import 'package:travel_app/screens/search.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _goToLoginPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (ctx) => const LogInScreen(),
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      _goToLoginPage(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CitiesList();
    var activePageTitle = 'Choose your city';
    if (_selectedPageIndex == 1) {
      activePage = SearchScreen();
      activePageTitle = 'Search';
    } else if (_selectedPageIndex == 2) {
      activePage = CalendarScreen();
      activePageTitle = 'Calendar';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () {
              signOut();
            },
          )
        ],
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.apps),
            label: 'For You',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
        ],
      ),
    );
  }
}
