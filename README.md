- [1. Overview](#1-overview)
  - [1.1. Technology Stack](#11-technology-stack)
- [2. UI structure](#2-ui-structure)
- [3. Compilation as a mobile APP](#3-compilation-as-a-mobile-app)
- [4. How to use this repository](#4-how-to-use-this-repository)
- [5. Some technology details](#5-some-technology-details)
  - [5.1. State management](#51-state-management)
  - [5.2. Pagination](#52-pagination)
  - [5.3. Decoupling of UI and the business logic further](#53-decoupling-of-ui-and-the-business-logic-further)
- [6. Test](#6-test)
- [7. License](#7-license)

# 1. Overview
This repository is developed for [the technical assessment](challenge_for_interview.md) of a job interview, and itself is the frontend part of this project. One instance of this repository has been deployed at https://instapic.club/.

The backend of this repository could be found at [another repository](https://github.com/TristanWYL/instapic-backend.git).

## 1.1. Technology Stack
    Flutter

# 2. UI structure

This frontend UI supports the following features:

1. Sign in
   
![signin](./screenshots/signin.png "Signin page, which is also the default page when you first visits this frontend.")

By clicking on the text button red-circled in the screenshot, you will be directed to the sign-up page.

2. Sign up

!["signup"](./screenshots/signup.png "Signup page, where the user could apply for an account.")

3. Post browsing

!["browse"](./screenshots/browse.png "Browsing page, where the user could browse all posts uploaded. This page is also the default view once the user logs in.")

4. Filtering

!["filter"](./screenshots/filter.png "Filtering page, where the user could filter out posts not concerned.")

5. Uploading

!["upload"](./screenshots/upload.png "Uploading page, where the user could upload her/his own posts.")

# 3. Compilation as a mobile APP

Flutter is cross-platform framework, so with the exactly same codebase, we can compile it into a mobile app of 

* either Android version by running:
  
  `flutter build apk`

* or iOS version by running:

  `flutter build ios`

Considering the limited budget of time and energy for this project, I did not improve the UI to make the build output more mobile-friendly, neither did I publish the mobile app at Google Play or App Store. But if you do want to try the mobile app of this project, you could download the apk file directly with this [link](https://drive.google.com/file/d/1jFpg6f6fLc5IlSlnTViEUhmaEdHsl2to/view?usp=sharing).

I also made some screenshots of the mobile app for your reference.

1. Sign in
   
![signin](./screenshots/signin_app.png "Signin page, which is also the default page when you first visits this frontend.")

By clicking on the text button red-circled in the screenshot, you will be directed to the sign-up page.

2. Sign up

!["signup"](./screenshots/signup_app.png "Signup page, where the user could apply for an account.")

3. Post browsing

!["browse"](./screenshots/browse_app.png "Browsing page, where the user could browse all posts uploaded. This page is also the default view once the user logs in.")

4. Filtering

!["filter"](./screenshots/filter_app.png "Filtering page, where the user could filter out posts not concerned.")

5. Uploading

!["upload"](./screenshots/upload_app.png "Uploading page, where the user could upload her/his own posts.")

6. About

!["about"](./screenshots/about_app.png "About page, where the user could see a brief introduction of this app.")

# 4. How to use this repository

**STEP 1:** Install [Flutter](https://flutter.dev/docs/get-started/install) and clone this repository

**STEP 2:** Tweak the *lib/misc/config.dart* to suit your case

**STEP 3:** Build the web application with the following command:

    > flutter build web

**STEP 4:** Copy all the content of the build output folder *build/web* to the document root of the deployed web server.

<!-- **STEP 5:** Tweak the *web/index.html* file

Open *web/index.html* with an editor, and change the *href* value of the *base* tag from __/__ to another directoy which suit your case, as appropriate. -->
**STEP 5:** Remember to deploy [the restful backend](https://flutter.dev/docs/get-started/install) as well, for this project to work normally.

**STEP 6:** Surf the web

# 5. Some technology details

## 5.1. State management
In the frontend system, different UI pages need to access to different states. In this repository, the [redux package](https://pub.dev/packages/redux) and [flutter_redux package](https://pub.dev/packages/flutter_redux) are used for the state management.

## 5.2. Pagination
The constructor `builder` of ListView widget is applied for lazily loading and displaying small chunks of pictures. The default page size for each post fetching could be set with variable `PAGE_SIZE` of class `Config` in */lib/misc/config.dart*.

```dart
ListView.builder({
    ScrollController? controller,
    required IndexedWidgetBuilder itemBuilder,
    int? itemCount
  })
```
## 5.3. Decoupling of UI and the business logic further

This project applies `Redux` for the state management, so most business logics are separated from the UI. However, few business logics which are not related to `AppState` but needs to update UI should be carefully treated, so that this few business states are more **testable**. 

For example, when the middleware processes `ActionPromptError`, the logic here should update the UI to prompt the user that some errors are happening. In this case the unit test cannot be carried on for the logic only, as UI is involved. To decouple the logic and the UI, `StreamController` is used by creating an async call for the UI update. If no listener is registered for this Stream, then the UI will not update, even if the logic enqueues an error prompting event. In this case, we could test the logic separatedly and gracefully.

# 6. Test

<!-- ## Unit test -->

Run the following command to start testing:

        flutter test

or if you want to run a single test, try:

        flutter test test/{unit_test}.dart

<!-- ## Integration test

1. Launch the WebDriver

    Refer to [this](https://flutter.dev/docs/cookbook/testing/integration/introduction#6b-web) to download the web driver first, and then launch the web driver.

2. Run the following command for starting the test (assume that the browser is chrome):

        flutter drive --target=test_driver/app.dart --browser-name=chrome --browser-dimension 1280,720 --release -d web-server -->

# 7. License
MIT
