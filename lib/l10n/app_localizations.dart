import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
    Locale('gu'),
    Locale('hi'),
    Locale('kn'),
    Locale('mr'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @summaryReport.
  ///
  /// In en, this message translates to:
  /// **'SUMMARY REPORT'**
  String get summaryReport;

  /// No description provided for @estimatedCost.
  ///
  /// In en, this message translates to:
  /// **'Estimated Cost'**
  String get estimatedCost;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate This App'**
  String get rateApp;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// No description provided for @shareApp.
  ///
  /// In en, this message translates to:
  /// **'Share This App'**
  String get shareApp;

  /// No description provided for @madeBy.
  ///
  /// In en, this message translates to:
  /// **'Made by Amritdhara'**
  String get madeBy;

  /// No description provided for @geoWaterDataTitle.
  ///
  /// In en, this message translates to:
  /// **'GEO WATER DATA'**
  String get geoWaterDataTitle;

  /// No description provided for @enterPincode.
  ///
  /// In en, this message translates to:
  /// **'Enter Pincode'**
  String get enterPincode;

  /// No description provided for @soil.
  ///
  /// In en, this message translates to:
  /// **'Soil'**
  String get soil;

  /// No description provided for @rainfall.
  ///
  /// In en, this message translates to:
  /// **'Rainfall'**
  String get rainfall;

  /// No description provided for @groundwater.
  ///
  /// In en, this message translates to:
  /// **'Groundwater'**
  String get groundwater;

  /// No description provided for @avgTemp.
  ///
  /// In en, this message translates to:
  /// **'Avg Temp'**
  String get avgTemp;

  /// No description provided for @localAquifer.
  ///
  /// In en, this message translates to:
  /// **'Local Aquifer System'**
  String get localAquifer;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning,'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon,'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening,'**
  String get goodEvening;

  /// No description provided for @tipOfTheDay.
  ///
  /// In en, this message translates to:
  /// **'Tip of the Day'**
  String get tipOfTheDay;

  /// No description provided for @tipOfTheDayBody.
  ///
  /// In en, this message translates to:
  /// **'Check your home for leaks. Even a small drip can waste thousands of litres a year!'**
  String get tipOfTheDayBody;

  /// No description provided for @quickAccess.
  ///
  /// In en, this message translates to:
  /// **'QUICK ACCESS'**
  String get quickAccess;

  /// No description provided for @userInput.
  ///
  /// In en, this message translates to:
  /// **'USER INPUT'**
  String get userInput;

  /// No description provided for @vendor.
  ///
  /// In en, this message translates to:
  /// **'VENDOR'**
  String get vendor;

  /// No description provided for @chatBot.
  ///
  /// In en, this message translates to:
  /// **'CHAT BOT'**
  String get chatBot;

  /// No description provided for @geoWaterData.
  ///
  /// In en, this message translates to:
  /// **'GEOWATER\nDATA'**
  String get geoWaterData;

  /// No description provided for @peopleAlsoAsk.
  ///
  /// In en, this message translates to:
  /// **'PEOPLE ALSO ASK'**
  String get peopleAlsoAsk;

  /// No description provided for @faqTitle1.
  ///
  /// In en, this message translates to:
  /// **'How does rooftop rainwater harvesting help recharge groundwater?'**
  String get faqTitle1;

  /// No description provided for @faqBody1.
  ///
  /// In en, this message translates to:
  /// **'It collects rainwater from your roof and directs it into the ground through specially designed systems like recharge pits or wells. This process actively replenishes underground aquifers, helping to raise the water table.'**
  String get faqBody1;

  /// No description provided for @amritdharaTitle.
  ///
  /// In en, this message translates to:
  /// **'AMRITDHARA'**
  String get amritdharaTitle;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'PROFILE'**
  String get profileTitle;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noFeasibilityData.
  ///
  /// In en, this message translates to:
  /// **'No feasibility data available'**
  String get noFeasibilityData;

  /// No description provided for @feasibility.
  ///
  /// In en, this message translates to:
  /// **'Feasibility'**
  String get feasibility;

  /// No description provided for @harvestPotential.
  ///
  /// In en, this message translates to:
  /// **'Harvest Potential'**
  String get harvestPotential;

  /// No description provided for @litresPerYear.
  ///
  /// In en, this message translates to:
  /// **'Litres/Year'**
  String get litresPerYear;

  /// No description provided for @waterSustainabilityTitle.
  ///
  /// In en, this message translates to:
  /// **'How long can your harvested water last?'**
  String get waterSustainabilityTitle;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @govtSubsidy.
  ///
  /// In en, this message translates to:
  /// **'Government Subsidy'**
  String get govtSubsidy;

  /// No description provided for @subsidyAmount.
  ///
  /// In en, this message translates to:
  /// **'Subsidy Amount'**
  String get subsidyAmount;

  /// No description provided for @jalJeevanMission.
  ///
  /// In en, this message translates to:
  /// **'Jal Jeevan Mission'**
  String get jalJeevanMission;

  /// No description provided for @pmksy.
  ///
  /// In en, this message translates to:
  /// **'PM Krishi Sinchai Yojana (PMKSY)'**
  String get pmksy;

  /// No description provided for @stepsAndInstructions.
  ///
  /// In en, this message translates to:
  /// **'Step & instructions'**
  String get stepsAndInstructions;

  /// No description provided for @saveAsPdf.
  ///
  /// In en, this message translates to:
  /// **'Save as PDF'**
  String get saveAsPdf;

  /// No description provided for @askChatBot.
  ///
  /// In en, this message translates to:
  /// **'Ask chat bot'**
  String get askChatBot;

  /// No description provided for @userInputTitle.
  ///
  /// In en, this message translates to:
  /// **'USER INPUT'**
  String get userInputTitle;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @useLocation.
  ///
  /// In en, this message translates to:
  /// **'Use location'**
  String get useLocation;

  /// No description provided for @areaDetails.
  ///
  /// In en, this message translates to:
  /// **'Area Details'**
  String get areaDetails;

  /// No description provided for @roofArea.
  ///
  /// In en, this message translates to:
  /// **'Roof Area'**
  String get roofArea;

  /// No description provided for @openArea.
  ///
  /// In en, this message translates to:
  /// **'Open Area'**
  String get openArea;

  /// No description provided for @roofMaterialConcrete.
  ///
  /// In en, this message translates to:
  /// **'Concrete'**
  String get roofMaterialConcrete;

  /// No description provided for @roofMaterialTin.
  ///
  /// In en, this message translates to:
  /// **'Tin'**
  String get roofMaterialTin;

  /// No description provided for @roofMaterialTiles.
  ///
  /// In en, this message translates to:
  /// **'Tiles'**
  String get roofMaterialTiles;

  /// No description provided for @roofMaterialOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get roofMaterialOther;

  /// No description provided for @householdDetails.
  ///
  /// In en, this message translates to:
  /// **'Household Details'**
  String get householdDetails;

  /// No description provided for @noOfDwellers.
  ///
  /// In en, this message translates to:
  /// **'No. of Dwellers'**
  String get noOfDwellers;

  /// No description provided for @locationType.
  ///
  /// In en, this message translates to:
  /// **'Location Type'**
  String get locationType;

  /// No description provided for @urban.
  ///
  /// In en, this message translates to:
  /// **'Urban'**
  String get urban;

  /// No description provided for @rural.
  ///
  /// In en, this message translates to:
  /// **'Rural'**
  String get rural;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT'**
  String get submit;

  /// No description provided for @validationEnterPincode.
  ///
  /// In en, this message translates to:
  /// **'Please enter PIN Code'**
  String get validationEnterPincode;

  /// No description provided for @validationPincode6digits.
  ///
  /// In en, this message translates to:
  /// **'PIN Code must be 6 digits'**
  String get validationPincode6digits;

  /// No description provided for @validationEnterRoofArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter roof area'**
  String get validationEnterRoofArea;

  /// No description provided for @validationValidRoofArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid roof area'**
  String get validationValidRoofArea;

  /// No description provided for @validationEnterOpenArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter open area'**
  String get validationEnterOpenArea;

  /// No description provided for @validationValidOpenArea.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid open area (can be 0)'**
  String get validationValidOpenArea;

  /// No description provided for @validationEnterDwellers.
  ///
  /// In en, this message translates to:
  /// **'Please enter the number of dwellers'**
  String get validationEnterDwellers;

  /// No description provided for @validationValidDwellers.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid number of dwellers'**
  String get validationValidDwellers;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @infoDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get infoDialogTitle;

  /// No description provided for @locationFeatureSoon.
  ///
  /// In en, this message translates to:
  /// **'Location feature will be implemented soon!'**
  String get locationFeatureSoon;

  /// No description provided for @vendorsTitle.
  ///
  /// In en, this message translates to:
  /// **'VENDORS'**
  String get vendorsTitle;

  /// No description provided for @activeVendors.
  ///
  /// In en, this message translates to:
  /// **'Active Vendors'**
  String get activeVendors;

  /// No description provided for @roleContractor.
  ///
  /// In en, this message translates to:
  /// **'Contractor'**
  String get roleContractor;

  /// No description provided for @rolePlumber.
  ///
  /// In en, this message translates to:
  /// **'Plumber'**
  String get rolePlumber;

  /// No description provided for @mobileNo.
  ///
  /// In en, this message translates to:
  /// **'Mob. No. -'**
  String get mobileNo;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address -'**
  String get addressLabel;

  /// No description provided for @callNow.
  ///
  /// In en, this message translates to:
  /// **'Call Now'**
  String get callNow;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {userName}'**
  String helloUser(String userName);

  /// No description provided for @whatCanIHelpWith.
  ///
  /// In en, this message translates to:
  /// **'What can I help with?'**
  String get whatCanIHelpWith;

  /// No description provided for @askAnything.
  ///
  /// In en, this message translates to:
  /// **'Ask anything...'**
  String get askAnything;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'EMAIL'**
  String get email;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'hello@example.com'**
  String get emailHint;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'PASSWORD'**
  String get password;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log in'**
  String get logIn;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @logInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Log in with Google'**
  String get logInWithGoogle;

  /// No description provided for @getVendor.
  ///
  /// In en, this message translates to:
  /// **'Get Vendor'**
  String get getVendor;

  /// No description provided for @structureStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'STRUCTURE & STEPS'**
  String get structureStepsTitle;

  /// No description provided for @structureDiagram.
  ///
  /// In en, this message translates to:
  /// **'Structure Diagram'**
  String get structureDiagram;

  /// No description provided for @stepByStepInstructions.
  ///
  /// In en, this message translates to:
  /// **'Step-by-Step Instructions'**
  String get stepByStepInstructions;

  /// No description provided for @step1Title.
  ///
  /// In en, this message translates to:
  /// **'Assess Rooftop Area'**
  String get step1Title;

  /// No description provided for @step1Point1.
  ///
  /// In en, this message translates to:
  /// **'Measure the total catchment area (roof size).'**
  String get step1Point1;

  /// No description provided for @step1Point2.
  ///
  /// In en, this message translates to:
  /// **'Ensure the roof is clean, sloped, and made of non-toxic material.'**
  String get step1Point2;

  /// No description provided for @step2Title.
  ///
  /// In en, this message translates to:
  /// **'Install Gutters and Downpipes'**
  String get step2Title;

  /// No description provided for @step2Point1.
  ///
  /// In en, this message translates to:
  /// **'Fix gutters along roof edges to collect rainwater.'**
  String get step2Point1;

  /// No description provided for @step2Point2.
  ///
  /// In en, this message translates to:
  /// **'Connect downpipes to channel water to the storage or filtration system.'**
  String get step2Point2;

  /// No description provided for @step3Title.
  ///
  /// In en, this message translates to:
  /// **'Fit a Mesh or Leaf Guard'**
  String get step3Title;

  /// No description provided for @step3Point1.
  ///
  /// In en, this message translates to:
  /// **'Place a mesh filter at the top of downpipes to prevent leaves and debris from entering.'**
  String get step3Point1;

  /// No description provided for @step4Title.
  ///
  /// In en, this message translates to:
  /// **'Add a First Flush Diverter'**
  String get step4Title;

  /// No description provided for @step4Point1.
  ///
  /// In en, this message translates to:
  /// **'Install a system to discard the initial, more contaminated rainwater.'**
  String get step4Point1;

  /// No description provided for @step5Title.
  ///
  /// In en, this message translates to:
  /// **'Set Up Filtration System'**
  String get step5Title;

  /// No description provided for @step5Point1.
  ///
  /// In en, this message translates to:
  /// **'Use layers of gravel, sand, and charcoal to purify the water before storage.'**
  String get step5Point1;

  /// No description provided for @step6Title.
  ///
  /// In en, this message translates to:
  /// **'Install Storage Tank'**
  String get step6Title;

  /// No description provided for @step6Point1.
  ///
  /// In en, this message translates to:
  /// **'Choose a tank size based on your rooftop area and local rainfall patterns.'**
  String get step6Point1;

  /// No description provided for @step6Point2.
  ///
  /// In en, this message translates to:
  /// **'Ensure the tank is covered to prevent algae growth and mosquito breeding.'**
  String get step6Point2;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'bn',
        'en',
        'gu',
        'hi',
        'kn',
        'mr',
        'ta',
        'te'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
    case 'kn':
      return AppLocalizationsKn();
    case 'mr':
      return AppLocalizationsMr();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
