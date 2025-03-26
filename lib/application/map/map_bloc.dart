

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:osm_nominatim/osm_nominatim.dart';

part 'map_event.dart';

part 'map_state.dart';

part 'map_bloc.freezed.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  Timer? timer;

  MapBloc() : super(const MapState()) {
    on<SetQuery>(setQuery);

    on<SearchLocations>(searchLocations);

    on<SetMapController>(setMapController);

    on<SetChoosing>(setChoosing);

    on<GoToLocation>(goToLocation);

    on<GoToMyLocation>(goToMyLocation);

    on<GoToTappedLocation>(goToTappedLocation);

    on<SetTitle>(setTitle);

    on<ClearSearchField>(clearSearchField);

    on<SaveLocalAddress>(saveLocalAddress);

    on<FetchLocationName>(fetchLocationName);
  }

  setQuery(event, emit) {
    if (state.textController?.text.trim().isNotEmpty ?? false) {
      if (timer?.isActive ?? false) {
        timer?.cancel();
      }
      timer = Timer(
        const Duration(milliseconds: 500),
        () {
          add(const MapEvent.searchLocations());
        },
      );
    }
  }

  searchLocations(event, emit) async {
    emit(state.copyWith(isSearching: true, isSearchLoading: true));
    try {
      final result = await Nominatim.searchByName(
        query: state.textController?.text.trim() ?? '',
        limit: 5,
        addressDetails: true,
        extraTags: true,
        nameDetails: true,
      );
      emit(state.copyWith(searchedPlaces: result, isSearchLoading: false));
    } catch (e) {
      debugPrint('===> search location error $e');
      emit(state.copyWith(isSearchLoading: false));
    }
  }

  setMapController(event, emit) {
    emit(state.copyWith(mapController: event.controller));
  }

  setChoosing(event, emit) {
    emit(state.copyWith(isChoosing: event.value, isSearching: false));
  }

  goToLocation(event, emit) {
    emit(state.copyWith(
        location: LatLng(event.place.lat, event.place.lon),
        isSearching: false,
        textController: TextEditingController(text: event.place.displayName),
        mapController: state.mapController
          ?..animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 0,
                target: LatLng(event.place.lat, event.place.lon),
                tilt: 0,
                zoom: 17,
              ),
            ),
          )));
  }

  goToMyLocation(event, emit) async {
    emit(state.copyWith(searchedPlaces: [], isSearching: false));
    Place? place;
    try {
      place = await Nominatim.reverseSearch(
        lat: event.location.latitude,
        lon: event.location.longitude,
        addressDetails: true,
        extraTags: true,
        nameDetails: true,
      );
      emit(state.copyWith(
          textController: TextEditingController(text: place.displayName)));
    } catch (e) {
      emit(state.copyWith(textController: TextEditingController(text: "")));
    }
    if (place != null) {
      emit(state.copyWith(
          location: LatLng(place.lat, place.lon),
          mapController: state.mapController
            ?..animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  bearing: 0,
                  target: LatLng(place.lat, place.lon),
                  tilt: 0,
                  zoom: 17,
                ),
              ),
            )));
    }
  }

  goToTappedLocation(event, emit) async {
    emit(state.copyWith(searchedPlaces: [], isSearching: false));
    Place? place;
    try {
      place = await Nominatim.reverseSearch(
        lat: event.latLng.latitude,
        lon: event.latLng.longitude,
        addressDetails: true,
        extraTags: true,
        nameDetails: true,
      );
      emit(state.copyWith(
          textController: TextEditingController(text: place.displayName)));
    } catch (e) {
      emit(state.copyWith(textController: TextEditingController(text: "")));
    }

    emit(state.copyWith(
        location: LatLng(event.latLng.latitude, event.latLng.longitude),
        mapController: state.mapController
          ?..animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                bearing: 0,
                target: event.latLng,
                tilt: 0,
                zoom: 17,
              ),
            ),
          )));
  }

  setTitle(event, emit) {
    emit(state.copyWith(title: event.title));
  }

  clearSearchField(event, emit) {
    emit(state.copyWith(
        searchedPlaces: [],
        isSearching: false,
        textController: TextEditingController()));
  }

  saveLocalAddress(event, emit) {
    add(const MapEvent.clearSearchField());
    emit(state.copyWith(mapController: state.mapController?..dispose()));
  }

  fetchLocationName(event, emit) async {
    emit(state.copyWith(location: event.latLng));
    Place? place;
    try {
      place = await Nominatim.reverseSearch(
          lat: event.latLng?.latitude,
          lon: event.latLng?.longitude,
          addressDetails: true,
          extraTags: true,
          nameDetails: true,
          language: "en");
      emit(state.copyWith(
          textController: TextEditingController(text: place.displayName)));
    } catch (e) {
      emit(state.copyWith(textController: TextEditingController(text: "")));
    }
  }
}
