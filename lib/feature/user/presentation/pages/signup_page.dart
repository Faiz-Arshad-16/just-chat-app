import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_chat_app/feature/app/routes/on_generate_route.dart';
import 'package:just_chat_app/feature/user/presentation/cubit/auth_cubit/auth_cubit.dart';
import '../../../app/theme/style.dart';
import '../widgets/name_text_field.dart';
import '../widgets/reusable_text_field.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
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
              top: 60,
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
                  const SizedBox(height: 60),
                  Text(
                    "Please sign up to continue",
                    style: GoogleFonts.comfortaa(
                      fontSize: 18,
                      color: AppColors.secondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 40),
                  NameTextField(
                    isFirstName: true,
                    onChanged:
                        (value) => setState(() {
                          _firstName = value;
                        }),
                  ),
                  const SizedBox(height: 20),
                  NameTextField(
                    isFirstName: false,
                    onChanged:
                        (value) => setState(() {
                          _lastName = value;
                        }),
                  ),
                  const SizedBox(height: 20),
                  ReusableTextField(
                    isEmail: true,
                    onChanged:
                        (value) => setState(() {
                          _email = value;
                        }),
                  ),
                  const SizedBox(height: 20),
                  ReusableTextField(
                    isEmail: false,
                    onChanged:
                        (value) => setState(() {
                          _password = value;
                        }),
                  ),
                  const SizedBox(height: 40),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                            context.read<AuthCubit>().signup(_email, _password, '$_firstName $_lastName');
                          }
                        },
                        child: isLoading ? const CircularProgressIndicator() : Text(
                          "Create account",
                          style: GoogleFonts.comfortaa(
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        ),
                      );
                      }
                    ),
                  ),
                  const SizedBox(height: 130),
                  RichText(
                    text: TextSpan(
                      text: "Already have an account?",
                      style: GoogleFonts.comfortaa(
                        fontSize: 18,
                        color: AppColors.secondaryTextColor,
                      ),
                      children: [
                        TextSpan(
                          text: " Sign in",
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
                                    PageConst.login,
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
