

import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc/bloc.dart';
import 'package:goshops/domain/di/dependency_manager.dart';
import 'package:goshops/infrastructure/model/model/currency_model.dart';
import 'package:goshops/infrastructure/model/model/referral_model.dart';
import 'package:goshops/infrastructure/model/model/translation_model.dart';
import 'package:goshops/infrastructure/model/request/update_profile_model.dart';
import 'package:goshops/infrastructure/model/model/user_model.dart';
import 'package:goshops/infrastructure/model/response/help_response.dart';
import 'package:goshops/infrastructure/model/response/languages_response.dart';
import 'package:goshops/infrastructure/service/services.dart';
import 'package:goshops/infrastructure/local_storage/local_storage.dart';
import 'package:goshops/infrastructure/model/response/digital_list_response.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'profile_event.dart';

part 'profile_state.dart';

part 'profile_bloc.freezed.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  int all = 0;

  ProfileBloc() : super(const ProfileState()) {
    on<FetchDigitalList>(fetchDigitalList);

    on<UpdateImagePath>(updateImagePath);

    on<SetProgress>(setProgress);

    on<ShowPassword>(showPassword);

    on<ShowConfirmPassword>(showConfirmPassword);

    on<FetchProfile>(fetchProfile);

    on<UpdateUser>(updateUser);

    on<UpdatePassword>(updatePassword);

    on<GetLanguage>(getLanguage);

    on<GetCurrency>(getCurrency);

    on<FetchReferral>(fetchReferral);

    on<GetHelps>(getHelps);

    on<UpdateLan>(updateLan);

    on<GetPolicy>(getPolicy);

    on<GetTerm>(getTerm);
  }

  fetchDigitalList(event, emit) async {
    if (event.isRefresh ?? false) {
      event.controller?.resetNoData();
      all = 0;
      emit(state.copyWith(digitalList: [], isDigitalLoading: true));
    }
    final res = await userRepository.getDigitalList(page: ++all);
    res.fold((l) {
      List<DigitalProduct> list = List.from(state.digitalList);
      list.addAll(l.data ?? []);
      emit(state.copyWith(
        isDigitalLoading: false,
        digitalList: list,
      ));
      if (event.isRefresh ?? false) {
        event.controller?.refreshCompleted();
        return;
      } else if (l.data?.isEmpty ?? true) {
        event.controller?.loadNoData();
        return;
      }
      event.controller?.loadComplete();
      return;
    }, (r) {
      emit(state.copyWith(isDigitalLoading: false));
      if (event.isRefresh ?? false) {
        event.controller?.refreshFailed();
      }
      event.controller?.loadFailed();

      AppHelpers.errorSnackBar(
        context: event.context,
        message: r,
        
      );
    });
  }

  updateImagePath(event, emit) {
    emit(state.copyWith(imagePath: event.imagePath));
  }

  setProgress(event, emit) {
    List<DownloadModel> list = List.from(state.progressList);
    for (int i = 0; i < list.length; i++) {
      if (list[i].taskId == event.taskId) {
        list.removeAt(i);
        list.insert(
            i,
            list[i].copyWith(
              progress: event.progress,
            ));
        emit(state.copyWith(progressList: list));
        return;
      }
    }

    list.add(
        DownloadModel(progress: 0, taskId: event.taskId, index: event.index));
    emit(state.copyWith(progressList: list));
  }

  showPassword(event, emit) {
    emit(state.copyWith(showNewPassword: !state.showNewPassword));
  }

  showConfirmPassword(event, emit) {
    emit(state.copyWith(showConfirmPassword: !state.showConfirmPassword));
  }

  fetchProfile(event, emit) async {
    emit(state.copyWith(isLoading: true));
    await userRepository.getProfileDetails(event.context);
    emit(state.copyWith(isLoading: false));
  }

  updateUser(event, emit) async {
    emit(state.copyWith(isLoading: true));
    String? imageUrl;
    if (state.imagePath != null) {
      final res = await galleryRepository.uploadImage(
          state.imagePath ?? "", UploadType.users);
      res.fold(
          (l) => imageUrl = l.imageData?.title,
          (r) => AppHelpers.errorSnackBar(
              context: event.context, message: r.toString()));
    }
    final res = await userRepository.updateProfile(
        updateProfile: UpdateProfileModel(
            firstName: event.firstName,
            lastName: event.lastName,
            imageUrl: imageUrl,
            phone: event.phone,
            email: event.email));

    res.fold(
      (l) {
        LocalStorage.setUser(l.data);
        emit(state.copyWith(isLoading: false));
        event.onSuccess?.call();
      },
      (r) {
        AppHelpers.errorSnackBar(
          context: event.context,
          message: r.toString(),
        );
        emit(state.copyWith(isLoading: false));
      },
    );
  }

  updatePassword(event, emit) async {
    emit(state.copyWith(isPasswordLoading: true));

    final res = await userRepository.updatePassword(
      password: event.newPassword,
      passwordConfirmation: event.confirmPassword,
    );

    res.fold((l) {
      emit(state.copyWith(isPasswordLoading: false));
      event.onSuccess?.call();
    }, (r) {
      emit(state.copyWith(isPasswordLoading: false));
      AppHelpers.errorSnackBar(context: event.context, message: r.toString());
    });
  }

  getLanguage(event, emit) async {
    emit(state.copyWith(isLanguage: state.languages.isEmpty));
    final res = await settingsRepository.getLanguages();
    res.fold(
      (l) {
        emit(state.copyWith(
          isLanguage: false,
          languages: l.data ?? [],
        ));
      },
      (r) {
        emit(state.copyWith(isLanguage: false));
        return AppHelpers.errorSnackBar(
          context: event.context,
          message: r.toString(),
        );
      },
    );
  }

  getCurrency(event, emit) async {
    emit(state.copyWith(isCurrency: state.currency.isEmpty));
    final res = await settingsRepository.getCurrencies();
    res.fold(
      (l) {
        emit(state.copyWith(
          isCurrency: false,
          currency: l.data ?? [],
        ));
      },
      (r) {
        emit(state.copyWith(isCurrency: false));
        return AppHelpers.errorSnackBar(
          context: event.context,
          message: r.toString(),
        );
      },
    );
  }

  fetchReferral(event, emit) async {
    emit(state.copyWith(isReferralLoading: state.referralData == null));
    final res = await userRepository.getReferralDetails();
    res.fold(
      (l) {
        emit(state.copyWith(
          isReferralLoading: false,
          referralData: l,
        ));
      },
      (r) {
        emit(state.copyWith(isReferralLoading: false));
        return AppHelpers.errorSnackBar(
          context: event.context,
          message: r.toString(),
        );
      },
    );
  }

  getHelps(event, emit) async {
    emit(state.copyWith(isHelpLoading: state.helps.isEmpty));
    final res = await settingsRepository.getFaq();
    res.fold(
      (l) {
        emit(state.copyWith(
          isHelpLoading: false,
          helps: l.data ?? [],
        ));
      },
      (r) {
        emit(state.copyWith(isHelpLoading: false));
        return AppHelpers.errorSnackBar(
          context: event.context,
          message: r.toString(),
        );
      },
    );
  }

  updateLan(event, emit) async {
    emit(state.copyWith(isLoading: true));
    emit(state.copyWith(isLoading: false));
  }

  getPolicy(event, emit) async {
    emit(state.copyWith(isHelpLoading: state.policy == null));
    final res = await settingsRepository.getPolicy();
    res.fold(
      (l) {
        emit(state.copyWith(isHelpLoading: false, policy: l));
      },
      (r) {
        emit(state.copyWith(isHelpLoading: false));
        return AppHelpers.errorSnackBar(
          context: event.context,
          message: r.toString(),
        );
      },
    );
  }

  getTerm(event, emit) async {
    emit(state.copyWith(isHelpLoading: state.term == null));
    final res = await settingsRepository.getTerm();
    res.fold(
      (l) {
        emit(state.copyWith(isHelpLoading: false, term: l));
      },
      (r) {
        emit(state.copyWith(isHelpLoading: false));
        return AppHelpers.errorSnackBar(
          context: event.context,
          message: r.toString(),
        );
      },
    );
  }
}
