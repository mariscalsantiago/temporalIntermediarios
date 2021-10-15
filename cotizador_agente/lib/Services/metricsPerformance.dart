import 'package:http/http.dart';
import 'package:firebase_performance/firebase_performance.dart';

class MetricsPerformance extends BaseClient {
  MetricsPerformance(this._inner, this.urlService, this.methodService);
  final Client _inner;
  final String urlService;
  final HttpMethod methodService;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    final HttpMetric metric =
        FirebasePerformance.instance.newHttpMetric(urlService, methodService);

    await metric.start();

    StreamedResponse response;
    try {
      response = await _inner.send(request);
      metric
        ..responsePayloadSize = response.contentLength
        ..responseContentType = response.headers['Content-Type']
        ..requestPayloadSize = request.contentLength
        ..httpResponseCode = response.statusCode;
    } finally {
      await metric.stop();
    }

    return response;
  }
}
