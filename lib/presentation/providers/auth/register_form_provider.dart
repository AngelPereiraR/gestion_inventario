import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

import '../../../infrastructure/inputs/inputs.dart';
import '../providers.dart';

//! 3 - StateNotifierProvider - consume afuera
final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerUserCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerUserCallback: registerUserCallback);
});

//! 2 - Como implementamos un notifier
class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String) registerUserCallback;

  RegisterFormNotifier({
    required this.registerUserCallback,
  }) : super(RegisterFormState());

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate(
          [newEmail, state.password, state.confirmPassword, state.name]),
    );
  }

  onPasswordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate(
          [newPassword, state.confirmPassword, state.email, state.name]),
    );
  }

  onConfirmPasswordChanged(String value) {
    final newConfirmPassword =
        ConfirmPassword.dirty(state.password.value, value);
    state = state.copyWith(
      confirmPassword: newConfirmPassword,
      isValid: Formz.validate(
          [state.password, newConfirmPassword, state.email, state.name]),
    );
  }

  onNameChanged(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
      name: newName,
      isValid: Formz.validate(
          [newName, state.email, state.password, state.confirmPassword]),
    );
  }

  onFormSubmit() async {
    _touchEveryField();

    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await registerUserCallback(
        state.email.value, state.password.value, state.name.value);

    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final confirmPassword = ConfirmPassword.dirty(
        state.password.value, state.confirmPassword.value);
    final name = Name.dirty(state.name.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
      name: name,
      isValid: Formz.validate([email, password, confirmPassword, name]),
    );
  }
}

//! 1 - State del provider
class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final Email email;
  final Password password;
  final ConfirmPassword confirmPassword;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.name = const Name.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmPassword = const ConfirmPassword.pure(''),
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    ConfirmPassword? confirmPassword,
    Name? name,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        confirmPassword: confirmPassword ?? this.confirmPassword,
        name: name ?? this.name,
      );

  @override
  String toString() {
    return '''
  registerFormState:
    isPosting: $isPosting
    isFormPosted: $isFormPosted
    isValid: $isValid
    email: $email
    password: $password
    confirmPassword: $confirmPassword
    name: $name
''';
  }
}
