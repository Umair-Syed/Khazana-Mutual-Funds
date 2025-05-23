import 'package:get_it/get_it.dart';
import 'package:khazana_mutual_funds/core/utils/funds_data_utils/fund_data_helper.dart';
import 'package:khazana_mutual_funds/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:khazana_mutual_funds/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:khazana_mutual_funds/features/auth/domain/repositories/auth_repository.dart';
import 'package:khazana_mutual_funds/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:khazana_mutual_funds/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:khazana_mutual_funds/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:khazana_mutual_funds/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:khazana_mutual_funds/features/charts/data/datasources/fund_data_source.dart';
import 'package:khazana_mutual_funds/features/charts/data/repositories/fund_repository_impl.dart';
import 'package:khazana_mutual_funds/features/charts/domain/repositories/fund_repository.dart';
import 'package:khazana_mutual_funds/features/charts/domain/usecases/get_all_funds.dart';
import 'package:khazana_mutual_funds/features/charts/presentation/bloc/fund_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:khazana_mutual_funds/features/fund_details/data/datasources/fund_details_data_source.dart';
import 'package:khazana_mutual_funds/features/fund_details/data/repositories/fund_details_repository_impl.dart';
import 'package:khazana_mutual_funds/features/fund_details/domain/repositories/fund_details_repository.dart';
import 'package:khazana_mutual_funds/features/fund_details/domain/usecases/get_fund_details.dart';
import 'package:khazana_mutual_funds/features/fund_details/presentation/bloc/fund_details_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize Supabase
  await Supabase.initialize(
    url:
        'https://oilkbisxnrbwkexellfs.supabase.co', // Replace with your Supabase URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9pbGtiaXN4bnJid2tleGVsbGZzIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc4NDMzNTYsImV4cCI6MjA2MzQxOTM1Nn0.rBNBm26gvFK5bBQMZUa71sZxZmCHZtXIO7JxuAIvq3U', // Replace with your Supabase anon key
  );

  final supabaseClient = Supabase.instance.client;

  // External
  sl.registerLazySingleton<SupabaseClient>(() => supabaseClient);
  sl.registerLazySingleton<FundDataHelper>(() => FundDataHelper());

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      sendOtpUseCase: sl(),
      verifyOtpUseCase: sl(),
      getCurrentUserUseCase: sl(),
      signOutUseCase: sl(),
    ),
  );

  sl.registerFactory(() => FundBloc(getAllFunds: sl()));

  // Fund Details
  // Bloc
  sl.registerFactory(() => FundDetailsBloc(getFundDetails: sl()));

  // Use cases
  sl.registerLazySingleton(() => SendOtpUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOtpUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));

  sl.registerLazySingleton(() => GetAllFunds(sl()));
  sl.registerLazySingleton(() => GetFundDetails(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );
  sl.registerLazySingleton<FundRepository>(
    () => FundRepositoryImpl(dataSource: sl()),
  );
  sl.registerLazySingleton<FundDetailsRepository>(
    () => FundDetailsRepositoryImpl(dataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );
  sl.registerLazySingleton<FundDataSource>(() => FundDataSourceImpl());
  sl.registerLazySingleton<FundDetailsDataSource>(
    () => FundDetailsDataSourceImpl(),
  );
}
