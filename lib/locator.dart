import 'package:get_it/get_it.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

import 'model/config.dart';
import 'provider/app_provider.dart';

import 'provider/auth_provider.dart';
import 'provider/user_provider.dart';
import 'provider/wallet_provider.dart';
import 'services/contract_service.dart';
import 'services/gasprice_service.dart';
import 'services/graphql_service.dart';
import 'services/wallet_services.dart';

final locator = GetIt.instance;

Future<void> init() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  //PROVIDER
  locator.registerLazySingleton<AppProvider>(() => AppProvider(
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  locator.registerLazySingleton<UserProvider>(
      () => UserProvider(locator(), locator()));
  locator.registerLazySingleton<Auth>(
      () => Auth());

  locator.registerLazySingleton<WalletProvider>(() => WalletProvider(
        locator(),
        locator(),
        locator(),
        locator(),
      ));

  //SERVICES
  locator.registerSingleton<ContractService>(ContractService());
  locator.registerLazySingleton<WalletAddress>(() => WalletAddress());

  locator
      .registerLazySingleton<GraphqlService>(() => GraphqlService(GraphQLClient(
            link: HttpLink(graphqlURL),
            cache: GraphQLCache(),
          )));

  locator.registerLazySingleton<GasPriceService>(
      () => GasPriceService(locator(), locator()));

  //CONFIG
  locator.registerLazySingleton<http.Client>(() => http.Client());

  locator
      .registerLazySingleton<Web3Client>(() => Web3Client(rpcURL, locator()));

  //PLUGINS

  locator.registerLazySingleton<SharedPreferences>(() => _prefs);
}
