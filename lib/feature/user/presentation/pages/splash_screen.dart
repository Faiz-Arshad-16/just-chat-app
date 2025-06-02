import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_chat_app/feature/app/theme/style.dart';
import '../../../../main.dart';
import '../../../app/routes/on_generate_route.dart';
import '../cubit/auth_cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().checkAuthStatus();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          if (ModalRoute.of(context)?.settings.name != PageConst.home) {
            navigatorKey.currentState!.pushReplacementNamed(PageConst.home);
          }
        } else if (state is Unauthenticated) {
          if (ModalRoute.of(context)?.settings.name != PageConst.login) {
            navigatorKey.currentState!.pushNamedAndRemoveUntil(
              PageConst.login,
                  (Route<dynamic> route) => false,
            );
          }
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.backgroundColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Just Chat",
                    style: GoogleFonts.comfortaa(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (state is AuthLoading)
                    const CircularProgressIndicator(color: AppColors.textColor),
                  if (state is AuthError)
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.comfortaa(
                        fontSize: 14,
                        color: Colors.red,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}