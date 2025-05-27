import 'package:dio/dio.dart';
import 'package:google_maps/models/auto_complete_data_model.dart';

class FetchAutoCompleteData {
  final dio = Dio();
  final String apiKey = 'AIzaSyAPUkKJnctlmWtswO9epB-4KfbNgNyJy0s';
  final String baseUrl =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?';

  Future<List<Predictions>> getAutoCompleteData(String input) async {
    try {
      final response = await dio.get('${baseUrl}input=$input&key=$apiKey');

      if (response.statusCode == 200) {
        var data = AutoCompleteDataModel.fromJson(response.data);
        return data.predictions ?? [];
      } else {
        throw Exception('Failed to fetch autocomplete data');
      }
    } catch (e) {
      throw Exception('Error fetching autocomplete data: $e');
    }
  }
}
