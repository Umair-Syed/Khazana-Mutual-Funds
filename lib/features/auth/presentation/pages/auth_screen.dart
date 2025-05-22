import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/bloc/auth/auth_event.dart';
import 'package:khazana_mutual_funds/features/auth/presentation/pages/auth_view.dart';
import 'package:khazana_mutual_funds/injection_container.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(CheckAuthStatusEvent()),
      child: const AuthView(),
    );
  }
}
