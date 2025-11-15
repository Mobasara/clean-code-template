// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Auth)
const authProvider = AuthProvider._();

final class AuthProvider
    extends $AsyncNotifierProvider<Auth, Either<Failure, UserEntity?>> {
  const AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();
}

String _$authHash() => r'1f9e74cfb01081ec60dfcd956c6f634de206a6b0';

abstract class _$Auth extends $AsyncNotifier<Either<Failure, UserEntity?>> {
  FutureOr<Either<Failure, UserEntity?>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<Either<Failure, UserEntity?>>,
              Either<Failure, UserEntity?>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Either<Failure, UserEntity?>>,
                Either<Failure, UserEntity?>
              >,
              AsyncValue<Either<Failure, UserEntity?>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
