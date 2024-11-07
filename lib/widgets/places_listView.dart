import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:travel_app/widgets/filtered_places.dart';

class PlacesListview extends StatefulWidget {
  const PlacesListview({
    super.key,
    required this.selectedCategory,
    required this.xCor,
    required this.yCor,
    required this.journeyId,
  });

  final String? selectedCategory;
  final double xCor;
  final double yCor;
  final String journeyId;

  @override
  State<PlacesListview> createState() => _PlacesListviewState();
}

class _PlacesListviewState extends State<PlacesListview> {
  final List<dynamic> _allPlaces = [];
  final List<dynamic> _places = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMorePlaces = true;
  int offset = 0;
  final int limit = 150;
  final int displayLimit = 10;

  final String apiKey = '731dfd7dfb0d4ebb99295e0cfe811177';

  @override
  void initState() {
    super.initState();
    _fetchPlaces();
  }

  void _fetchPlaces() {
    if (widget.selectedCategory != null && _hasMorePlaces) {
      getPlacesByCategory(
          widget.selectedCategory!, widget.xCor, widget.yCor, limit, offset);
    }
  }

  @override
  void didUpdateWidget(covariant PlacesListview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      setState(() {
        _allPlaces.clear();
        _places.clear();
        offset = 0;
        _hasMorePlaces = true;
        _isLoading = true;
      });
      _fetchPlaces();
    }
  }

  void getPlacesByCategory(String selectedCategory, double xCor, double yCor,
      int limit, int offset) async {
    final url = Uri.parse(
        'https://api.geoapify.com/v2/places?categories=$selectedCategory&filter=circle:$xCor,$yCor,2000&limit=$limit&offset=$offset&apiKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<dynamic> newPlaces = listData['features'];
      setState(() {
        if (newPlaces.isNotEmpty) {
          _allPlaces.addAll(newPlaces);
          _loadMorePlaces();
          offset += newPlaces.length;
        } else {
          _hasMorePlaces = false;
          if (_places.isEmpty) {
            _places.clear();
          }
        }
        _isLoading = false;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _isLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  void _loadMorePlaces() {
    if (_places.length < _allPlaces.length) {
      final nextPlaces =
          _allPlaces.skip(_places.length).take(displayLimit).toList();
      setState(() {
        _places.addAll(nextPlaces);
      });
    } else {
      _hasMorePlaces = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!_isLoadingMore &&
            _hasMorePlaces &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          setState(() {
            _isLoadingMore = true;
          });
          _loadMorePlaces();
          _fetchPlaces();
        }
        return false;
      },
      child: ListView.builder(
        itemCount: _places.length + (_isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _places.length && _isLoadingMore) {
            return const Center(child: CircularProgressIndicator());
          }

          final place = _places[index]['properties'];
          final placeData = {
            'name': place['address_line1'] ?? 'Unknown',
            'location': place['address_line2'] ?? 'Unknown',
            'wikiPlaceId': place['datasource']['raw']['wikidata'] ?? '',
            'placeId': place['place_id'] ?? '',
            'fee': place['datasource']['raw']['fee'] ?? 'No fee info',
            'phone': place['contact']?['phone'] ?? 'No phone info',
            'website': place['website'] ?? 'No website info',
            'openingHours':
                place['datasource']['raw']['opening_hours'] ?? 'No info',
            'journeyId': widget.journeyId,
          };

          return FilteredPlaces(placeData: placeData);
        },
      ),
    );
  }
}
