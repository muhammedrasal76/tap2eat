rasal@Rasals-MacBook-Air tap2eat_app % firebase deploy --only functions

=== Deploying to 'tap2eat-7642c'...

i  deploying functions
i  functions: preparing codebase default for deployment
i  functions: ensuring required API cloudfunctions.googleapis.com is enabled...
i  functions: ensuring required API cloudbuild.googleapis.com is enabled...
i  artifactregistry: ensuring required API artifactregistry.googleapis.com is enabled...
⚠  functions: package.json indicates an outdated version of firebase-functions. Please upgrade using npm install --save firebase-functions@latest in your functions directory.
⚠  functions: Please note that there will be breaking changes when you upgrade.
i  functions: Loading and analyzing source code for codebase default to determine what to deploy
Serving at port 8225

TypeError: functions.pubsub.schedule is not a function
    at Object.<anonymous> (/Users/rasal/college project/tap2eat/tap2eat_app/functions/index.js:400:6)
    at Module._compile (node:internal/modules/cjs/loader:1761:14)
    at Object..js (node:internal/modules/cjs/loader:1893:10)
    at Module.load (node:internal/modules/cjs/loader:1481:32)
    at Module._load (node:internal/modules/cjs/loader:1300:12)
    at TracingChannel.traceSync (node:diagnostics_channel:328:14)
    at wrapModuleLoad (node:internal/modules/cjs/loader:245:24)
    at Module.require (node:internal/modules/cjs/loader:1504:12)
    at require (node:internal/modules/helpers:152:16)
    at loadModule (/Users/rasal/college project/tap2eat/tap2eat_app/functions/node_modules/firebase-functions/lib/runtime/loader.js:40:16)


Error: Functions codebase could not be analyzed successfully. It may have a syntax or runtime error