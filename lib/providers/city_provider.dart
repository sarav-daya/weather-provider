import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:state_notifier/state_notifier.dart';
import 'package:weather_provider/repositories/city_repository.dart';

enum CityStatus {
  inital,
  loading,
  loaded,
  error,
}

class CityState extends Equatable {
  final String city;
  final CityStatus status;
  CityState({
    required this.city,
    required this.status,
  });

  factory CityState.initial() =>
      CityState(city: 'unknown', status: CityStatus.inital);

  @override
  List<Object> get props => [city, status];

  @override
  String toString() => 'CityState(city: $city, status: $status)';

  CityState copyWith({
    String? city,
    CityStatus? status,
  }) {
    return CityState(
      city: city ?? this.city,
      status: status ?? this.status,
    );
  }
}

class CityProvider extends StateNotifier<CityState> with LocatorMixin {
  CityProvider() : super(CityState.initial());

  Future<void> getCity() async {
    try {
      state = state.copyWith(status: CityStatus.loading);
      Position position = await _determinePosition();
      print('position: $position');
      String city = await read<CityRepository>()
          .fetchCity(position.latitude, position.longitude);
      print('city: $city');
      state = state.copyWith(city: city, status: CityStatus.loaded);
    } catch (e) {
      state = state.copyWith(status: CityStatus.error);
      // print(e);
    }
  }

  void updateCity(String city) {
    state = state.copyWith(city: city);
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  return await Geolocator.getCurrentPosition();
}
