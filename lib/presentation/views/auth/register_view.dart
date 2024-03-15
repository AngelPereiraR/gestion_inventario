import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/providers.dart';
import '../../widgets/widgets.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return OrientationBuilder(builder: (context, orientation) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: PopScope(
          canPop: false,
          child: Scaffold(
            body: GeometricalBackground(
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (!context.canPop()) return;
                              context.pop();
                            },
                            icon: const Icon(Icons.arrow_back_rounded,
                                size: 40, color: Colors.white)),
                        const Spacer(),
                        const Icon(
                          Icons.person_add_alt_1_outlined,
                          color: Colors.white,
                          size: 100,
                        ),
                        const Spacer(),
                        const SizedBox(width: 50),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Container(
                      height: orientation == Orientation.portrait
                          ? size.height - 250
                          : size.height + 225,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(100),
                            topRight: Radius.circular(100)),
                      ),
                      child: const _RegisterForm(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerForm = ref.watch(registerFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text('Nueva cuenta', style: textStyles.titleLarge),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Nombre completo',
            onChanged: ref.read(registerFormProvider.notifier).onNameChanged,
            errorMessage: registerForm.isFormPosted
                ? registerForm.name.errorMessage
                : null,
            keyboardType: TextInputType.name,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Correo',
            onChanged: ref.read(registerFormProvider.notifier).onEmailChange,
            errorMessage: registerForm.isFormPosted
                ? registerForm.email.errorMessage
                : null,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            onChanged:
                ref.read(registerFormProvider.notifier).onPasswordChanged,
            errorMessage: registerForm.isFormPosted
                ? registerForm.password.errorMessage
                : null,
            obscureText: true,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Repita la contraseña',
            onChanged: ref
                .read(registerFormProvider.notifier)
                .onConfirmPasswordChanged,
            onFieldSubmitted: (_) =>
                ref.read(registerFormProvider.notifier).onFormSubmit(),
            errorMessage: registerForm.isFormPosted
                ? registerForm.confirmPassword.errorMessage
                : null,
            obscureText: true,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Crear',
              onPressed: registerForm.isPosting
                  ? null
                  : ref.read(registerFormProvider.notifier).onFormSubmit,
            ),
          ),
        ],
      ),
    );
  }
}
