import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/cities_list.dart';
import 'package:travel_app/screens/comments.dart';
import 'package:travel_app/screens/favorites.dart';
import 'package:travel_app/screens/logIn.dart';
import 'package:travel_app/screens/search.dart';
import 'package:travel_app/widgets/google_calendar_service_factory.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({
    super.key,
    required this.journeyId,
  });

  final String journeyId;

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  GoogleCalendarService calendarService = GoogleCalendarServiceFactory.create();

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

  @override
  Widget build(BuildContext context) {
    Widget activePage;
    String activePageTitle;

    switch (_selectedPageIndex) {
      case 1:
        activePage = SearchScreen(
          journeyId: widget.journeyId,
        );
        activePageTitle = 'Search';
        break;
      case 2:
        activePage = FavoritesScreen(
          journeyId: widget.journeyId,
        );
        activePageTitle = 'Favorites';
        break;
      case 3:
        activePage = CommentsScreen(
          journeyId: widget.journeyId,
        );
        activePageTitle = 'Comments';
        break;
      default:
        activePage = CitiesList(
          journeyId: widget.journeyId,
        );
        activePageTitle = 'Choose your city';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
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
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: 'Comments',
          ),
        ],
      ),
    );
  }
}
