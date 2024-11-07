import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:travel_app/screens/cities_list.dart';
import 'package:travel_app/screens/comments.dart';
import 'package:travel_app/screens/favorites.dart';
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
  String journeyName = '';

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _getName() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("journeys");

    DatabaseEvent event = await ref.once();

    if (event.snapshot.exists) {
      var journeys = event.snapshot.value as Map?;
      journeys?.forEach((journeyId, journeyData) {
        if (journeyId == widget.journeyId) {
          String fetchedJourneyName = journeyData['journeyName'];
          setState(() {
            journeyName = fetchedJourneyName;
          });
        }
      });
    } else {
      print('No data available');
    }
  }

  @override
  void initState() {
    _getName();
    super.initState();
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
        activePageTitle = journeyName;
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
