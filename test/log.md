Launching lib/main.dart on ONEPLUS A5010 in debug mode...
/Users/rasal/college project/tap2eat/tap2eat_app/android/app/src/debug/AndroidManifest.xml Error:
	uses-sdk:minSdkVersion 21 cannot be smaller than version 23 declared in library [com.google.firebase:firebase-auth:23.2.1] /Users/rasal/.gradle/caches/8.12/transforms/b989efa963ce219d3913eb2634c39032/transformed/jetified-firebase-auth-23.2.1/AndroidManifest.xml as the library might be using APIs not available in 21
	Suggestion: use a compatible library with a minSdk of at most 21,
		or increase this project's minSdk version to at least 23,
		or use tools:overrideLibrary="com.google.firebase.auth" to force usage (may lead to runtime failures)

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:processDebugMainManifest'.
> Manifest merger failed : uses-sdk:minSdkVersion 21 cannot be smaller than version 23 declared in library [com.google.firebase:firebase-auth:23.2.1] /Users/rasal/.gradle/caches/8.12/transforms/b989efa963ce219d3913eb2634c39032/transformed/jetified-firebase-auth-23.2.1/AndroidManifest.xml as the library might be using APIs not available in 21
  	Suggestion: use a compatible library with a minSdk of at most 21,
  		or increase this project's minSdk version to at least 23,
  		or use tools:overrideLibrary="com.google.firebase.auth" to force usage (may lead to runtime failures)

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.

BUILD FAILED in 1s
Error: Gradle task assembleDebug failed with exit code 1

Exited (1).