import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PlacePhoto extends StatefulWidget {
  const PlacePhoto({super.key, required this.placeId});

  final String placeId;

  @override
  State<PlacePhoto> createState() => _PlacePhotoState();
}

class _PlacePhotoState extends State<PlacePhoto> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    getImage(widget.placeId);
  }

  Future<void> getImage(String id) async {
    final url = Uri.parse(
        'https://www.wikidata.org/w/rest.php/wikibase/v0/entities/items/$id');

    final headers = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiJmYmI1ZDk1ZTJiYTg3NDBmYmYwOWZiMTlkZWRjYjkwNyIsImp0aSI6IjE3OGZjYjUwYWFlNjc5NWI2OWE5ODQzOTBmZmVmZTg1NTQzZDc5OGM2ZDkxZmVjZTg1OGFlMzMzMjQ1ODYyZWYyYTMwZDRlNDQwMGMzMWMzIiwiaWF0IjoxNzI5NjA1NjExLjM5MTY3LCJuYmYiOjE3Mjk2MDU2MTEuMzkxNjc2LCJleHAiOjMzMjg2NTE0NDExLjM4NDQzNCwic3ViIjoiNzY3NzUzMDAiLCJpc3MiOiJodHRwczovL21ldGEud2lraW1lZGlhLm9yZyIsInJhdGVsaW1pdCI6eyJyZXF1ZXN0c19wZXJfdW5pdCI6NTAwMCwidW5pdCI6IkhPVVIifSwic2NvcGVzIjpbImJhc2ljIiwiaGlnaHZvbHVtZSIsInZpZXdteXdhdGNobGlzdCIsImVkaXRteXdhdGNobGlzdCIsImNoZWNrdXNlci10ZW1wb3JhcnktYWNjb3VudCJdfQ.lAZZ_mYuU2UqIc4ZyU6iZ6-coT1U6ltziDJk_9znO0DHG5EMrbYlrtlKPhM7Ft0KL7fnu-qJ3Hkuw3YIjgG_VEbmUJtIr350w8Qp0zIpc4Gx2FB6od18UMnHZE21fHBQDWnCR0EHXnj31HPDLM0CTGYhAP77fOOpE2ADJHpVEQU3FqjTTTE37sev-_BoslGg_fCDARc1Vsq9rZ7rjNGP3liGsTjzT4LZE2BiZWaTY_qHuHybomNncnpYe0VFhsSHu8QfjkF89TweEszBGrDKNS3uHXc6T8MBZa3RTCrCmWGe2U6fd9pv3jWacxbc-nfCgEo-R4Ud96mNygSAoL7yKy61KJMLSfR_QwMOa9r0MZDSqy_3UuOE8EuvwddFzRma3esAni6f8h25GLPv6_pyh3NsF8u59nC2AI3jOIdP2US_kvz8L80YlUSvGSedJk5wbXAFwd5ZlJA9Lv7Jlh67oA-0tEA7cuivtSsG9Kjyv9ifE1v-0ik8j80cqSBkspYVUnlMP9Fk9BnFyHyIymEko6c-COjD1icy7ci8DXWmRboS63MYZpyymI2ux804NakH3Jy3_hPagAVm99aZd4Ykis8POk3EQI-LfiYKF7Pw5GJpeTdI_P8YtaoJvBSzvm0VPxJOmH_QcCz51B4xV7ZzJp3mJN-F4FIzsL7dkRfkqD8', // Customize this as necessary
    };

    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> listData = json.decode(response.body);
      if (listData.containsKey('statements')) {
        var statements = listData['statements'];
        if (statements.containsKey('P18')) {
          String imageFileName = statements['P18'][0]['value']['content'];
          String encodedImageFileName = Uri.encodeComponent(imageFileName);
          print(encodedImageFileName);
          String imageUrl =
              'https://commons.wikimedia.org/wiki/Special:FilePath/$encodedImageFileName';

          setState(() {
            this.imageUrl = imageUrl;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: imageUrl != null
          ? Image.network(imageUrl!)
          // : CircularProgressIndicator(),
          : Text(''),
    );
  }
}
