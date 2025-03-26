import 'package:get_it/get_it.dart';
import 'package:google_place/google_place.dart';
import 'package:goshops/app_constants.dart';

// import 'package:google_place/google_place.dart';
import 'package:goshops/domain/interface/address.dart';
import 'package:goshops/domain/interface/auth.dart';
import 'package:goshops/domain/interface/banner.dart';
import 'package:goshops/domain/interface/blog.dart';
import 'package:goshops/domain/interface/brands.dart';
import 'package:goshops/domain/interface/cart.dart';
import 'package:goshops/domain/interface/category.dart';
import 'package:goshops/domain/interface/chat.dart';
import 'package:goshops/domain/interface/gallery.dart';
import 'package:goshops/domain/interface/order.dart';
import 'package:goshops/domain/interface/parcel.dart';
import 'package:goshops/domain/interface/payments.dart';
import 'package:goshops/domain/interface/products.dart';
import 'package:goshops/domain/interface/review.dart';
import 'package:goshops/domain/interface/settings.dart';
import 'package:goshops/domain/interface/shop.dart';
import 'package:goshops/domain/interface/user.dart';
import 'package:goshops/infrastructure/service//http_service.dart';
import 'package:goshops/infrastructure/repository/address_repository.dart';
import 'package:goshops/infrastructure/repository/auth_repository.dart';
import 'package:goshops/infrastructure/repository/banners_repository.dart';
import 'package:goshops/infrastructure/repository/blogs_repository.dart';
import 'package:goshops/infrastructure/repository/brands_repository.dart';
import 'package:goshops/infrastructure/repository/cart_repository.dart';
import 'package:goshops/infrastructure/repository/categories_repository.dart';
import 'package:goshops/infrastructure/repository/chat_repository.dart';
import 'package:goshops/infrastructure/repository/gallery_repository.dart';
import 'package:goshops/infrastructure/repository/order_repository.dart';
import 'package:goshops/infrastructure/repository/parcel_repository.dart';
import 'package:goshops/infrastructure/repository/payments_repository.dart';
import 'package:goshops/infrastructure/repository/products_repository.dart';
import 'package:goshops/infrastructure/repository/review_repository.dart';
import 'package:goshops/infrastructure/repository/settings_repository.dart';
import 'package:goshops/infrastructure/repository/shops_repository.dart';
import 'package:goshops/infrastructure/repository/user_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setUpDependencies() async {
  getIt.registerSingleton<HttpService>(HttpService());
  getIt.registerLazySingleton<SettingsInterface>(() => SettingsRepository());
  getIt.registerLazySingleton<AuthInterface>(() => AuthRepository());
  getIt.registerLazySingleton<CategoryInterface>(() => CategoryRepository());
  getIt.registerLazySingleton<BannersInterface>(() => BannersRepository());
  getIt.registerLazySingleton<ProductsInterface>(() => ProductsRepository());
  getIt.registerLazySingleton<BlogInterface>(() => BlogsRepository());
  getIt.registerLazySingleton<ShopsInterface>(() => ShopsRepository());
  getIt.registerLazySingleton<BrandsInterface>(() => BrandsRepository());
  getIt.registerLazySingleton<GalleryInterface>(() => GalleryRepository());
  getIt.registerLazySingleton<UserInterface>(() => UserRepository());
  getIt.registerLazySingleton<ChatInterface>(() => ChatRepository());
  getIt.registerLazySingleton<AddressInterface>(() => AddressRepository());
  getIt.registerLazySingleton<CartInterface>(() => CartRepository());
  getIt.registerLazySingleton<ParcelInterface>(() => ParcelRepository());

  getIt.registerLazySingleton<GooglePlace>(
      () => GooglePlace(AppConstants.googleApiKey));
  getIt.registerLazySingleton<PaymentsInterface>(() => PaymentsRepository());
  getIt.registerLazySingleton<OrderInterface>(() => OrderRepository());
  getIt.registerLazySingleton<ReviewInterface>(() => ReviewRepository());
}

final settingsRepository = getIt.get<SettingsInterface>();
final dioHttp = getIt.get<HttpService>();
final authRepository = getIt.get<AuthInterface>();
final categoriesRepository = getIt.get<CategoryInterface>();
final bannersRepository = getIt.get<BannersInterface>();
final productsRepository = getIt.get<ProductsInterface>();
final blogsRepository = getIt.get<BlogInterface>();
final shopsRepository = getIt.get<ShopsInterface>();
final brandsRepository = getIt.get<BrandsInterface>();
final galleryRepository = getIt.get<GalleryInterface>();
final userRepository = getIt.get<UserInterface>();
final chatRepository = getIt.get<ChatInterface>();
final addressRepository = getIt.get<AddressInterface>();
final cartRepository = getIt.get<CartInterface>();
final googlePlace = getIt.get<GooglePlace>();
final paymentsRepository = getIt.get<PaymentsInterface>();
final ordersRepository = getIt.get<OrderInterface>();
final reviewRepository = getIt.get<ReviewInterface>();
final parcelRepository = getIt.get<ParcelInterface>();
