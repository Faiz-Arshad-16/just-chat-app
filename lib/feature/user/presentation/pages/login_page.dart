import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_chat_app/feature/app/routes/on_generate_route.dart';
import 'package:just_chat_app/feature/user/presentation/cubit/auth_cubit/auth_cubit.dart';
import '../../../app/theme/style.dart';
import '../widgets/reusable_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 80,
              bottom: 20,
              left: 20,
              right: 20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Just Chat",
                    style: GoogleFonts.comfortaa(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textColor,
                    ),
                  ),
                  SizedBox(height: 80),
                  Text(
                    "Please login to continue",
                    style: GoogleFonts.comfortaa(
                      fontSize: 18,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  SizedBox(height: 40),
                  ReusableTextField(
                    isEmail: true,
                    onChanged:
                        (value) => setState(() {
                          _email = value;
                        }),
                  ),
                  SizedBox(height: 30),
                  ReusableTextField(
                    isEmail: false,
                    onChanged:
                        (value) => setState(() {
                          _password = value;
                        }),
                  ),
                  SizedBox(height: 40),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 50,
                    child: BlocConsumer<AuthCubit, AuthState>(
                      listener: (context, state) {
                        if (state is Authenticated) {
                          Navigator.pushReplacementNamed(context, PageConst.home);
                        } else if (state is AuthError) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(state.message)),
                          );
                        }
                      },
                      builder:(context, state){
                        final isLoading = state is AuthLoading;
                        return ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthCubit>().login(_email, _password);
                          }
                        },
                        child: isLoading ? CircularProgressIndicator() : Text(
                          "Login",
                          style: GoogleFonts.comfortaa(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      );
                      }
                    ),
                  ),
                  SizedBox(height: 130), // Responsive spacing
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account?",
                      style: GoogleFonts.comfortaa(
                        fontSize: 18,
                        color: AppColors.secondaryTextColor,
                      ),
                      children: [
                        TextSpan(
                          text: " Sign up",
                          style: GoogleFonts.comfortaa(
                            fontSize: 18,
                            color: AppColors.sendMessageColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    PageConst.signUp,
                                  );
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
