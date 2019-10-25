import 'package:bloc_provider/bloc_provider.dart';

class MainBloc extends Bloc {
  // PublishSubject<City> _city = PublishSubject<City>();
  // Observable<City> get city => _city.stream;

  void fetchData() async {
    // final response = await service.fetchData();
    // _city.sink.add(response);
  }

  @override
  void dispose() {
    // _city.close();
  }
}
