import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';

class GitHubRemoteDataSource {
  final Dio dio;

  GitHubRemoteDataSource(this.dio);

  Future<List<dynamic>> fetchFlutterRepositories() async {
    final response = await dio.get(
      ApiConstants.searchRepo,
      queryParameters: {
        'q': 'flutter',
        'sort': 'stars',
        'order': 'desc',
        'per_page': 50,
      },
    );

    if (response.statusCode == 200) {
      return response.data['items'];
    } else {
      throw Exception('Failed to fetch repositories');
    }
  }
}
