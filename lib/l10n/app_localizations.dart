import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en')
  ];

  /// No description provided for @language_en.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language_en;

  /// No description provided for @language_de.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get language_de;

  /// No description provided for @labelFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get labelFilter;

  /// No description provided for @labelCalendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get labelCalendar;

  /// No description provided for @labelStatistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get labelStatistics;

  /// No description provided for @labelAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get labelAvailable;

  /// No description provided for @labelUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get labelUnavailable;

  /// No description provided for @labelMissing.
  ///
  /// In en, this message translates to:
  /// **'Missing'**
  String get labelMissing;

  /// No description provided for @labelRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get labelRequired;

  /// No description provided for @labelPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission'**
  String get labelPermission;

  /// No description provided for @labelWelcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get labelWelcome;

  /// No description provided for @labelMiscellaneous.
  ///
  /// In en, this message translates to:
  /// **'Miscellaneous'**
  String get labelMiscellaneous;

  /// No description provided for @labelMoreDetails.
  ///
  /// In en, this message translates to:
  /// **'More Details'**
  String get labelMoreDetails;

  /// No description provided for @labelGeneralAttendence.
  ///
  /// In en, this message translates to:
  /// **'General Attendence'**
  String get labelGeneralAttendence;

  /// No description provided for @labelPersonalAttendence.
  ///
  /// In en, this message translates to:
  /// **'Personal Attendence'**
  String get labelPersonalAttendence;

  /// No description provided for @labelLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get labelLanguage;

  /// No description provided for @labelServerScheme.
  ///
  /// In en, this message translates to:
  /// **'Server Protocol'**
  String get labelServerScheme;

  /// No description provided for @labelServerHost.
  ///
  /// In en, this message translates to:
  /// **'Server Host'**
  String get labelServerHost;

  /// No description provided for @labelServerPort.
  ///
  /// In en, this message translates to:
  /// **'Server Port'**
  String get labelServerPort;

  /// No description provided for @labelClientScheme.
  ///
  /// In en, this message translates to:
  /// **'Client Protocol'**
  String get labelClientScheme;

  /// No description provided for @labelClientHost.
  ///
  /// In en, this message translates to:
  /// **'Client Host'**
  String get labelClientHost;

  /// No description provided for @labelClientPort.
  ///
  /// In en, this message translates to:
  /// **'Client Port'**
  String get labelClientPort;

  /// No description provided for @labelLicense.
  ///
  /// In en, this message translates to:
  /// **'License'**
  String get labelLicense;

  /// No description provided for @labelAuthors.
  ///
  /// In en, this message translates to:
  /// **'Authors'**
  String get labelAuthors;

  /// No description provided for @labelRelease.
  ///
  /// In en, this message translates to:
  /// **'Release'**
  String get labelRelease;

  /// No description provided for @labelVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get labelVersion;

  /// No description provided for @labelBuild.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get labelBuild;

  /// No description provided for @labelPage.
  ///
  /// In en, this message translates to:
  /// **'Page'**
  String get labelPage;

  /// No description provided for @labelTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get labelTotal;

  /// No description provided for @labelSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get labelSubtotal;

  /// No description provided for @labelComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get labelComment;

  /// No description provided for @labelAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get labelAmount;

  /// No description provided for @labelTrue.
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get labelTrue;

  /// No description provided for @labelNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get labelNeutral;

  /// No description provided for @labelFalse.
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get labelFalse;

  /// No description provided for @labelAccount.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get labelAccount;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @labelContact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get labelContact;

  /// No description provided for @labelPersonalBackground.
  ///
  /// In en, this message translates to:
  /// **'Personal Background'**
  String get labelPersonalBackground;

  /// No description provided for @labelPhysicalCharacteristics.
  ///
  /// In en, this message translates to:
  /// **'Physical Characteristics'**
  String get labelPhysicalCharacteristics;

  /// No description provided for @actionSelect.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get actionSelect;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCreate.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get actionCreate;

  /// No description provided for @actionCreateBatch.
  ///
  /// In en, this message translates to:
  /// **'New (Batch)'**
  String get actionCreateBatch;

  /// No description provided for @actionDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get actionDuplicate;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get actionLogin;

  /// No description provided for @actionLogout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get actionLogout;

  /// No description provided for @actionResume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get actionResume;

  /// No description provided for @actionOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get actionOn;

  /// No description provided for @actionOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get actionOff;

  /// No description provided for @actionNone.
  ///
  /// In en, this message translates to:
  /// **'Neither'**
  String get actionNone;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get actionRemove;

  /// No description provided for @actionApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get actionApply;

  /// No description provided for @actionShow.
  ///
  /// In en, this message translates to:
  /// **'Show'**
  String get actionShow;

  /// No description provided for @actionHide.
  ///
  /// In en, this message translates to:
  /// **'Hide'**
  String get actionHide;

  /// No description provided for @actionTest.
  ///
  /// In en, this message translates to:
  /// **'Test'**
  String get actionTest;

  /// No description provided for @actionConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get actionConnect;

  /// No description provided for @actionBookmark.
  ///
  /// In en, this message translates to:
  /// **'Bookmark'**
  String get actionBookmark;

  /// No description provided for @actionRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get actionRead;

  /// No description provided for @actionWrite.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get actionWrite;

  /// No description provided for @actionYes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get actionYes;

  /// No description provided for @actionNo.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get actionNo;

  /// No description provided for @submissionFail.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit the information'**
  String get submissionFail;

  /// No description provided for @submissionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Succeeded to submit the information'**
  String get submissionSuccess;

  /// No description provided for @responseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get responseSuccess;

  /// No description provided for @responseFail.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get responseFail;

  /// No description provided for @isValid.
  ///
  /// In en, this message translates to:
  /// **'is valid'**
  String get isValid;

  /// No description provided for @isInvalid.
  ///
  /// In en, this message translates to:
  /// **'is invalid'**
  String get isInvalid;

  /// No description provided for @dateYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get dateYear;

  /// No description provided for @dateMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get dateMonth;

  /// No description provided for @dateWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get dateWeek;

  /// No description provided for @dateWeekday.
  ///
  /// In en, this message translates to:
  /// **'Weekday'**
  String get dateWeekday;

  /// No description provided for @dateDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dateDay;

  /// No description provided for @dateDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateDate;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get dateTime;

  /// No description provided for @dateDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get dateDuration;

  /// No description provided for @dateHour.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get dateHour;

  /// No description provided for @dateMinute.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get dateMinute;

  /// No description provided for @dateSecond.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get dateSecond;

  /// No description provided for @dateFrame.
  ///
  /// In en, this message translates to:
  /// **'Time Frame'**
  String get dateFrame;

  /// No description provided for @dateFrameBegin.
  ///
  /// In en, this message translates to:
  /// **'Time Frame From'**
  String get dateFrameBegin;

  /// No description provided for @dateFrameEnd.
  ///
  /// In en, this message translates to:
  /// **'Time Frame To'**
  String get dateFrameEnd;

  /// No description provided for @weekdayLongMon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayLongMon;

  /// No description provided for @weekdayLongTue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayLongTue;

  /// No description provided for @weekdayLongWed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayLongWed;

  /// No description provided for @weekdayLongThu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayLongThu;

  /// No description provided for @weekdayLongFri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayLongFri;

  /// No description provided for @weekdayLongSat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdayLongSat;

  /// No description provided for @weekdayLongSun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdayLongSun;

  /// No description provided for @weekdayShortMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayShortMon;

  /// No description provided for @weekdayShortTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayShortTue;

  /// No description provided for @weekdayShortWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayShortWed;

  /// No description provided for @weekdayShortThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayShortThu;

  /// No description provided for @weekdayShortFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayShortFri;

  /// No description provided for @weekdayShortSat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdayShortSat;

  /// No description provided for @weekdayShortSun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdayShortSun;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @undefined.
  ///
  /// In en, this message translates to:
  /// **'Undefined'**
  String get undefined;

  /// No description provided for @defined.
  ///
  /// In en, this message translates to:
  /// **'Defined'**
  String get defined;

  /// No description provided for @pageCalendarMonth.
  ///
  /// In en, this message translates to:
  /// **'Month Calendar Scope'**
  String get pageCalendarMonth;

  /// No description provided for @pageCalendarDay.
  ///
  /// In en, this message translates to:
  /// **'Day Calendar Scope'**
  String get pageCalendarDay;

  /// No description provided for @pageClubManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Clubs'**
  String get pageClubManagement;

  /// No description provided for @pageClubDetails.
  ///
  /// In en, this message translates to:
  /// **'Club Details'**
  String get pageClubDetails;

  /// No description provided for @pageClubEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Club'**
  String get pageClubEdit;

  /// No description provided for @pageClubStatisticMember.
  ///
  /// In en, this message translates to:
  /// **'Club Member Statistics'**
  String get pageClubStatisticMember;

  /// No description provided for @pageClubStatisticTeam.
  ///
  /// In en, this message translates to:
  /// **'Club Team Comparison'**
  String get pageClubStatisticTeam;

  /// No description provided for @pageClubStatisticPresence.
  ///
  /// In en, this message translates to:
  /// **'Presence Statistics'**
  String get pageClubStatisticPresence;

  /// No description provided for @pageClubStatisticOrganisation.
  ///
  /// In en, this message translates to:
  /// **'Club Organisation Statistics'**
  String get pageClubStatisticOrganisation;

  /// No description provided for @pageLocationManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Locations'**
  String get pageLocationManagement;

  /// No description provided for @pageLocationEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Location'**
  String get pageLocationEdit;

  /// No description provided for @pageOrganisationManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Organisations'**
  String get pageOrganisationManagement;

  /// No description provided for @pageOrganisationEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Organisation'**
  String get pageOrganisationEdit;

  /// No description provided for @pageAffiliationManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Affiliations'**
  String get pageAffiliationManagement;

  /// No description provided for @pageAffiliationEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Affiliation'**
  String get pageAffiliationEdit;

  /// No description provided for @pageTeamManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Teams'**
  String get pageTeamManagement;

  /// No description provided for @pageTeamEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Team Details'**
  String get pageTeamEdit;

  /// No description provided for @pageTeamMember.
  ///
  /// In en, this message translates to:
  /// **'Team Members'**
  String get pageTeamMember;

  /// No description provided for @pageTeamRight.
  ///
  /// In en, this message translates to:
  /// **'Team Permissions'**
  String get pageTeamRight;

  /// No description provided for @pageTermManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Membership Terms'**
  String get pageTermManagement;

  /// No description provided for @pageTermEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Membership Terms'**
  String get pageTermEdit;

  /// No description provided for @pagePossessionPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Possessions'**
  String get pagePossessionPersonal;

  /// No description provided for @pagePossessionUser.
  ///
  /// In en, this message translates to:
  /// **'Manage User Possessions'**
  String get pagePossessionUser;

  /// No description provided for @pagePossessionClub.
  ///
  /// In en, this message translates to:
  /// **'Manage Club Loans'**
  String get pagePossessionClub;

  /// No description provided for @pageStockManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Club Stocks'**
  String get pageStockManagement;

  /// No description provided for @pageItemOverview.
  ///
  /// In en, this message translates to:
  /// **'Manage Items'**
  String get pageItemOverview;

  /// No description provided for @pageItemEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Item'**
  String get pageItemEdit;

  /// No description provided for @pageItemcatOverview.
  ///
  /// In en, this message translates to:
  /// **'Manage Item Categories'**
  String get pageItemcatOverview;

  /// No description provided for @pageItemcatEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Item Category'**
  String get pageItemcatEdit;

  /// No description provided for @pageCourseAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available Courses'**
  String get pageCourseAvailable;

  /// No description provided for @pageCourseResponsible.
  ///
  /// In en, this message translates to:
  /// **'Moderated Courses'**
  String get pageCourseResponsible;

  /// No description provided for @pageCourseManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Courses'**
  String get pageCourseManagement;

  /// No description provided for @pageCourseDetails.
  ///
  /// In en, this message translates to:
  /// **'Course Details'**
  String get pageCourseDetails;

  /// No description provided for @pageCourseEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Course'**
  String get pageCourseEdit;

  /// No description provided for @pageCourseClasses.
  ///
  /// In en, this message translates to:
  /// **'Course Classes'**
  String get pageCourseClasses;

  /// No description provided for @pageCourseModerators.
  ///
  /// In en, this message translates to:
  /// **'Course Moderators'**
  String get pageCourseModerators;

  /// No description provided for @pageCourseClub.
  ///
  /// In en, this message translates to:
  /// **'Club Assignment'**
  String get pageCourseClub;

  /// No description provided for @pageCourseRequirements.
  ///
  /// In en, this message translates to:
  /// **'Course Requirements'**
  String get pageCourseRequirements;

  /// No description provided for @pageCourseAttendanceSieves.
  ///
  /// In en, this message translates to:
  /// **'Team Suggestions'**
  String get pageCourseAttendanceSieves;

  /// No description provided for @pageCourseStatisticClasses.
  ///
  /// In en, this message translates to:
  /// **'Class Statistic'**
  String get pageCourseStatisticClasses;

  /// No description provided for @pageCourseStatisticAttendance.
  ///
  /// In en, this message translates to:
  /// **'Attendance Statistics'**
  String get pageCourseStatisticAttendance;

  /// No description provided for @pageEventAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available Events'**
  String get pageEventAvailable;

  /// No description provided for @pageEventDetails.
  ///
  /// In en, this message translates to:
  /// **'Event Details'**
  String get pageEventDetails;

  /// No description provided for @pageEventOwnership.
  ///
  /// In en, this message translates to:
  /// **'Personal Events'**
  String get pageEventOwnership;

  /// No description provided for @pageEventManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Events'**
  String get pageEventManagement;

  /// No description provided for @pageEventCreate.
  ///
  /// In en, this message translates to:
  /// **'Create Event'**
  String get pageEventCreate;

  /// No description provided for @pageEventOwners.
  ///
  /// In en, this message translates to:
  /// **'Event Owners'**
  String get pageEventOwners;

  /// No description provided for @pageEventCourse.
  ///
  /// In en, this message translates to:
  /// **'Course Assignment'**
  String get pageEventCourse;

  /// No description provided for @pageEventAttendanceRegistrations.
  ///
  /// In en, this message translates to:
  /// **'Attendance Registrations'**
  String get pageEventAttendanceRegistrations;

  /// No description provided for @pageEventAttendanceFilters.
  ///
  /// In en, this message translates to:
  /// **'Attendance Suggestions'**
  String get pageEventAttendanceFilters;

  /// No description provided for @pageEventAttendancePresences.
  ///
  /// In en, this message translates to:
  /// **'Attendance Confirmations'**
  String get pageEventAttendancePresences;

  /// No description provided for @pageEventInfo.
  ///
  /// In en, this message translates to:
  /// **'Event Information'**
  String get pageEventInfo;

  /// No description provided for @pageEventStatisticPacklist.
  ///
  /// In en, this message translates to:
  /// **'Packlist Information'**
  String get pageEventStatisticPacklist;

  /// No description provided for @pageEventStatisticOrganisation.
  ///
  /// In en, this message translates to:
  /// **'Organisation Information'**
  String get pageEventStatisticOrganisation;

  /// No description provided for @pageCompetencePersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal Competences'**
  String get pageCompetencePersonal;

  /// No description provided for @pageCompetenceManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Competences'**
  String get pageCompetenceManagement;

  /// No description provided for @pageCompetenceEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Competence'**
  String get pageCompetenceEdit;

  /// No description provided for @pageSkillManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Skills'**
  String get pageSkillManagement;

  /// No description provided for @pageSkillEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Skill'**
  String get pageSkillEdit;

  /// No description provided for @pageUserManagement.
  ///
  /// In en, this message translates to:
  /// **'Manage Users'**
  String get pageUserManagement;

  /// No description provided for @pageUserCreate.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get pageUserCreate;

  /// No description provided for @pageUserDetails.
  ///
  /// In en, this message translates to:
  /// **'User Details'**
  String get pageUserDetails;

  /// No description provided for @pageUserProfile.
  ///
  /// In en, this message translates to:
  /// **'User Profile'**
  String get pageUserProfile;

  /// No description provided for @pageConnection.
  ///
  /// In en, this message translates to:
  /// **'Server Connection'**
  String get pageConnection;

  /// No description provided for @pageSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get pageSettings;

  /// No description provided for @pageAbout.
  ///
  /// In en, this message translates to:
  /// **'Program Information'**
  String get pageAbout;

  /// No description provided for @sessionNew.
  ///
  /// In en, this message translates to:
  /// **'New Session'**
  String get sessionNew;

  /// No description provided for @sessionActiveUser.
  ///
  /// In en, this message translates to:
  /// **'User Session'**
  String get sessionActiveUser;

  /// No description provided for @sessionActiveEvent.
  ///
  /// In en, this message translates to:
  /// **'Event Session'**
  String get sessionActiveEvent;

  /// No description provided for @loginUser.
  ///
  /// In en, this message translates to:
  /// **'User Login'**
  String get loginUser;

  /// No description provided for @loginEvent.
  ///
  /// In en, this message translates to:
  /// **'Event Login'**
  String get loginEvent;

  /// No description provided for @loginCourse.
  ///
  /// In en, this message translates to:
  /// **'Course Login'**
  String get loginCourse;

  /// No description provided for @loginLocation.
  ///
  /// In en, this message translates to:
  /// **'Location Login'**
  String get loginLocation;

  /// No description provided for @club.
  ///
  /// In en, this message translates to:
  /// **'Club'**
  String get club;

  /// No description provided for @clubKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get clubKey;

  /// No description provided for @clubName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get clubName;

  /// No description provided for @clubDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get clubDescription;

  /// No description provided for @clubDisciplines.
  ///
  /// In en, this message translates to:
  /// **'Disciplines'**
  String get clubDisciplines;

  /// No description provided for @clubImageURL.
  ///
  /// In en, this message translates to:
  /// **'Image Filename'**
  String get clubImageURL;

  /// No description provided for @clubChairman.
  ///
  /// In en, this message translates to:
  /// **'Chairman'**
  String get clubChairman;

  /// No description provided for @clubDivision.
  ///
  /// In en, this message translates to:
  /// **'Division'**
  String get clubDivision;

  /// No description provided for @clubDivisions.
  ///
  /// In en, this message translates to:
  /// **'Divisions'**
  String get clubDivisions;

  /// No description provided for @clubDivisionHead.
  ///
  /// In en, this message translates to:
  /// **'Head of the Division'**
  String get clubDivisionHead;

  /// No description provided for @clubAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get clubAddress;

  /// No description provided for @term.
  ///
  /// In en, this message translates to:
  /// **'Membership'**
  String get term;

  /// No description provided for @termUser.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get termUser;

  /// No description provided for @termClub.
  ///
  /// In en, this message translates to:
  /// **'Club'**
  String get termClub;

  /// No description provided for @termDate.
  ///
  /// In en, this message translates to:
  /// **'Date of Interest'**
  String get termDate;

  /// No description provided for @termBegin.
  ///
  /// In en, this message translates to:
  /// **'Date of Entry'**
  String get termBegin;

  /// No description provided for @termEnd.
  ///
  /// In en, this message translates to:
  /// **'Date of Exit'**
  String get termEnd;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @locationKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get locationKey;

  /// No description provided for @locationName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get locationName;

  /// No description provided for @locationDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get locationDescription;

  /// No description provided for @organisation.
  ///
  /// In en, this message translates to:
  /// **'Organisation'**
  String get organisation;

  /// No description provided for @organisationAbbreviation.
  ///
  /// In en, this message translates to:
  /// **'Abbreviation'**
  String get organisationAbbreviation;

  /// No description provided for @organisationName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get organisationName;

  /// No description provided for @affiliation.
  ///
  /// In en, this message translates to:
  /// **'Affiliation'**
  String get affiliation;

  /// No description provided for @affiliationMemberIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Member Identifier'**
  String get affiliationMemberIdentifier;

  /// No description provided for @affiliationPermissionSoloDate.
  ///
  /// In en, this message translates to:
  /// **'Solo Participation Permission (Date)'**
  String get affiliationPermissionSoloDate;

  /// No description provided for @affiliationPermissionTeamDate.
  ///
  /// In en, this message translates to:
  /// **'Team Participation Permission (Date)'**
  String get affiliationPermissionTeamDate;

  /// No description provided for @affiliationResidencyMoveDate.
  ///
  /// In en, this message translates to:
  /// **'Residency in Competing Country Since (Date)'**
  String get affiliationResidencyMoveDate;

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @userKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get userKey;

  /// No description provided for @userSalt.
  ///
  /// In en, this message translates to:
  /// **'Password Entropy'**
  String get userSalt;

  /// No description provided for @userPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get userPassword;

  /// No description provided for @userPasswordChange.
  ///
  /// In en, this message translates to:
  /// **'Change Password (6-50 Characters)'**
  String get userPasswordChange;

  /// No description provided for @userPasswordSince.
  ///
  /// In en, this message translates to:
  /// **'Password Set Since (Date)'**
  String get userPasswordSince;

  /// No description provided for @userEnabled.
  ///
  /// In en, this message translates to:
  /// **'Login Enabled'**
  String get userEnabled;

  /// No description provided for @userActive.
  ///
  /// In en, this message translates to:
  /// **'User Active'**
  String get userActive;

  /// No description provided for @userFirstname.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get userFirstname;

  /// No description provided for @userLastname.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get userLastname;

  /// No description provided for @userNickname.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get userNickname;

  /// No description provided for @userAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get userAddress;

  /// No description provided for @userEmail.
  ///
  /// In en, this message translates to:
  /// **'E-Mail'**
  String get userEmail;

  /// No description provided for @userPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get userPhone;

  /// No description provided for @userBirthDate.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get userBirthDate;

  /// No description provided for @userBirthLocation.
  ///
  /// In en, this message translates to:
  /// **'Place of Birth'**
  String get userBirthLocation;

  /// No description provided for @userNationality.
  ///
  /// In en, this message translates to:
  /// **'Nationality'**
  String get userNationality;

  /// No description provided for @userGender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get userGender;

  /// No description provided for @userHeight.
  ///
  /// In en, this message translates to:
  /// **'Height (cm)'**
  String get userHeight;

  /// No description provided for @userWeight.
  ///
  /// In en, this message translates to:
  /// **'Weight (kg)'**
  String get userWeight;

  /// No description provided for @userAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get userAge;

  /// No description provided for @userAgeEOY.
  ///
  /// In en, this message translates to:
  /// **'Age (End of Year)'**
  String get userAgeEOY;

  /// No description provided for @userBankacc.
  ///
  /// In en, this message translates to:
  /// **'Bank Account'**
  String get userBankacc;

  /// No description provided for @userLicenseMain.
  ///
  /// In en, this message translates to:
  /// **'Main License'**
  String get userLicenseMain;

  /// No description provided for @userLicenseExtra.
  ///
  /// In en, this message translates to:
  /// **'Extra License'**
  String get userLicenseExtra;

  /// No description provided for @userDiscipline.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get userDiscipline;

  /// No description provided for @userNote.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get userNote;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @licenseName.
  ///
  /// In en, this message translates to:
  /// **'License Name'**
  String get licenseName;

  /// No description provided for @licenseNumber.
  ///
  /// In en, this message translates to:
  /// **'License Number'**
  String get licenseNumber;

  /// No description provided for @licenseExpiration.
  ///
  /// In en, this message translates to:
  /// **'Date of Expiration'**
  String get licenseExpiration;

  /// No description provided for @bankaccIban.
  ///
  /// In en, this message translates to:
  /// **'IBAN'**
  String get bankaccIban;

  /// No description provided for @bankaccBic.
  ///
  /// In en, this message translates to:
  /// **'BIC'**
  String get bankaccBic;

  /// No description provided for @bankaccInstitute.
  ///
  /// In en, this message translates to:
  /// **'Institute'**
  String get bankaccInstitute;

  /// No description provided for @occurrenceOccurring.
  ///
  /// In en, this message translates to:
  /// **'Occurring'**
  String get occurrenceOccurring;

  /// No description provided for @occurrenceCanceled.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get occurrenceCanceled;

  /// No description provided for @occurrenceVoided.
  ///
  /// In en, this message translates to:
  /// **'Voided (Hidden)'**
  String get occurrenceVoided;

  /// No description provided for @acceptanceDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get acceptanceDraft;

  /// No description provided for @acceptancePending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get acceptancePending;

  /// No description provided for @acceptanceAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get acceptanceAccepted;

  /// No description provided for @acceptanceRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get acceptanceRejected;

  /// No description provided for @confirmationPositive.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get confirmationPositive;

  /// No description provided for @confirmationNeutral.
  ///
  /// In en, this message translates to:
  /// **'Uncertain'**
  String get confirmationNeutral;

  /// No description provided for @confirmationNegative.
  ///
  /// In en, this message translates to:
  /// **'Decline'**
  String get confirmationNegative;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @teamKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get teamKey;

  /// No description provided for @teamName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get teamName;

  /// No description provided for @teamDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get teamDescription;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @inventoryOwnershipFromClubToUser.
  ///
  /// In en, this message translates to:
  /// **'Give ownership of the club item to the user'**
  String get inventoryOwnershipFromClubToUser;

  /// No description provided for @inventoryOwnershipFromUserToClub.
  ///
  /// In en, this message translates to:
  /// **'Give ownership of the user item to a club'**
  String get inventoryOwnershipFromUserToClub;

  /// No description provided for @inventoryPossessionFromUserToClub.
  ///
  /// In en, this message translates to:
  /// **'Return the item to the club'**
  String get inventoryPossessionFromUserToClub;

  /// No description provided for @inventoryOwnershipFromUserDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete the user item'**
  String get inventoryOwnershipFromUserDelete;

  /// No description provided for @item.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get item;

  /// No description provided for @itemName.
  ///
  /// In en, this message translates to:
  /// **'Item Name'**
  String get itemName;

  /// No description provided for @itemCategory.
  ///
  /// In en, this message translates to:
  /// **'Item Category'**
  String get itemCategory;

  /// No description provided for @itemcat.
  ///
  /// In en, this message translates to:
  /// **'Item Category'**
  String get itemcat;

  /// No description provided for @itemcatName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get itemcatName;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @stockClub.
  ///
  /// In en, this message translates to:
  /// **'Club'**
  String get stockClub;

  /// No description provided for @stockItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get stockItem;

  /// No description provided for @stockStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get stockStorage;

  /// No description provided for @stockOwned.
  ///
  /// In en, this message translates to:
  /// **'Owned'**
  String get stockOwned;

  /// No description provided for @stockLoaned.
  ///
  /// In en, this message translates to:
  /// **'Loaned'**
  String get stockLoaned;

  /// No description provided for @possessionUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get possessionUser;

  /// No description provided for @possessionItem.
  ///
  /// In en, this message translates to:
  /// **'Item'**
  String get possessionItem;

  /// No description provided for @possessionOwned.
  ///
  /// In en, this message translates to:
  /// **'Ownership'**
  String get possessionOwned;

  /// No description provided for @possessionPossessed.
  ///
  /// In en, this message translates to:
  /// **'Possession'**
  String get possessionPossessed;

  /// No description provided for @possessionClub.
  ///
  /// In en, this message translates to:
  /// **'Club'**
  String get possessionClub;

  /// No description provided for @possessionAcquisition.
  ///
  /// In en, this message translates to:
  /// **'Transfer Date'**
  String get possessionAcquisition;

  /// No description provided for @course.
  ///
  /// In en, this message translates to:
  /// **'Course'**
  String get course;

  /// No description provided for @courseKey.
  ///
  /// In en, this message translates to:
  /// **'Course ID'**
  String get courseKey;

  /// No description provided for @courseTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get courseTitle;

  /// No description provided for @courseModerator.
  ///
  /// In en, this message translates to:
  /// **'Moderator'**
  String get courseModerator;

  /// No description provided for @courseActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get courseActive;

  /// No description provided for @coursePublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get coursePublic;

  /// No description provided for @courseRanking.
  ///
  /// In en, this message translates to:
  /// **'Skill Requirement'**
  String get courseRanking;

  /// No description provided for @event.
  ///
  /// In en, this message translates to:
  /// **'Event'**
  String get event;

  /// No description provided for @eventKey.
  ///
  /// In en, this message translates to:
  /// **'Event Key'**
  String get eventKey;

  /// No description provided for @eventPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get eventPassword;

  /// No description provided for @eventPasswordChange.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get eventPasswordChange;

  /// No description provided for @eventTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get eventTitle;

  /// No description provided for @eventBegin.
  ///
  /// In en, this message translates to:
  /// **'Begin of Event'**
  String get eventBegin;

  /// No description provided for @eventEnd.
  ///
  /// In en, this message translates to:
  /// **'End of Event'**
  String get eventEnd;

  /// No description provided for @eventLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get eventLocation;

  /// No description provided for @eventOccurrence.
  ///
  /// In en, this message translates to:
  /// **'Occurrence'**
  String get eventOccurrence;

  /// No description provided for @eventAcceptance.
  ///
  /// In en, this message translates to:
  /// **'Approval Status'**
  String get eventAcceptance;

  /// No description provided for @eventPublic.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get eventPublic;

  /// No description provided for @eventScrutable.
  ///
  /// In en, this message translates to:
  /// **'Scrutable'**
  String get eventScrutable;

  /// No description provided for @eventNote.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get eventNote;

  /// No description provided for @eventOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get eventOwner;

  /// No description provided for @eventParticipant.
  ///
  /// In en, this message translates to:
  /// **'Participant'**
  String get eventParticipant;

  /// No description provided for @eventLeader.
  ///
  /// In en, this message translates to:
  /// **'Leader'**
  String get eventLeader;

  /// No description provided for @eventSupporter.
  ///
  /// In en, this message translates to:
  /// **'Supporter'**
  String get eventSupporter;

  /// No description provided for @eventSpectator.
  ///
  /// In en, this message translates to:
  /// **'Spectator'**
  String get eventSpectator;

  /// No description provided for @eventRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration'**
  String get eventRegistration;

  /// No description provided for @eventPresence.
  ///
  /// In en, this message translates to:
  /// **'Presence'**
  String get eventPresence;

  /// No description provided for @eventAccess.
  ///
  /// In en, this message translates to:
  /// **'Access'**
  String get eventAccess;

  /// No description provided for @eventAccessTrue.
  ///
  /// In en, this message translates to:
  /// **'Invited'**
  String get eventAccessTrue;

  /// No description provided for @eventAccessFalse.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get eventAccessFalse;

  /// No description provided for @eventRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get eventRole;

  /// No description provided for @skill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get skill;

  /// No description provided for @skillKey.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get skillKey;

  /// No description provided for @skillTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get skillTitle;

  /// No description provided for @skillRange.
  ///
  /// In en, this message translates to:
  /// **'Range'**
  String get skillRange;

  /// No description provided for @skillRangeMin.
  ///
  /// In en, this message translates to:
  /// **'Lower Bound'**
  String get skillRangeMin;

  /// No description provided for @skillRangeMax.
  ///
  /// In en, this message translates to:
  /// **'Upper Bound'**
  String get skillRangeMax;

  /// No description provided for @competence.
  ///
  /// In en, this message translates to:
  /// **'Competence'**
  String get competence;

  /// No description provided for @competenceUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get competenceUser;

  /// No description provided for @competenceJudge.
  ///
  /// In en, this message translates to:
  /// **'Judge'**
  String get competenceJudge;

  /// No description provided for @competenceSkill.
  ///
  /// In en, this message translates to:
  /// **'Skill'**
  String get competenceSkill;

  /// No description provided for @competenceSkillRank.
  ///
  /// In en, this message translates to:
  /// **'Skill Rank'**
  String get competenceSkillRank;

  /// No description provided for @competenceSkillRange.
  ///
  /// In en, this message translates to:
  /// **'Skill Range'**
  String get competenceSkillRange;

  /// No description provided for @competenceDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get competenceDate;

  /// No description provided for @trainer.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get trainer;

  /// No description provided for @trainerAccounting.
  ///
  /// In en, this message translates to:
  /// **'Coach accounting'**
  String get trainerAccounting;

  /// No description provided for @trainerTimeStatement.
  ///
  /// In en, this message translates to:
  /// **'I state that I have conducted the training hours according to the schedule for the club {club_name}.'**
  String trainerTimeStatement(Object club_name);

  /// No description provided for @trainerTimeTotal.
  ///
  /// In en, this message translates to:
  /// **'Training hours'**
  String get trainerTimeTotal;

  /// No description provided for @trainerTimePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Duration per unit'**
  String get trainerTimePerUnit;

  /// No description provided for @trainerUnitTotal.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get trainerUnitTotal;

  /// No description provided for @trainerCompensationPerUnit.
  ///
  /// In en, this message translates to:
  /// **'Compensation per unit'**
  String get trainerCompensationPerUnit;

  /// No description provided for @trainerCompensationTotal.
  ///
  /// In en, this message translates to:
  /// **'Total compensation amount'**
  String get trainerCompensationTotal;

  /// No description provided for @trainerCompensationDisbursement.
  ///
  /// In en, this message translates to:
  /// **'Amount to be disbursed'**
  String get trainerCompensationDisbursement;

  /// No description provided for @trainerCompensationDontation.
  ///
  /// In en, this message translates to:
  /// **'Donation portion'**
  String get trainerCompensationDontation;

  /// No description provided for @trainerTimeTable.
  ///
  /// In en, this message translates to:
  /// **'Time table'**
  String get trainerTimeTable;

  /// No description provided for @trainerEventActivity.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get trainerEventActivity;

  /// No description provided for @trainerEventLocation.
  ///
  /// In en, this message translates to:
  /// **'Training location'**
  String get trainerEventLocation;

  /// No description provided for @trainerWaiverStatement.
  ///
  /// In en, this message translates to:
  /// **'Waiver statement'**
  String get trainerWaiverStatement;

  /// No description provided for @trainerWaiverDonationClause.
  ///
  /// In en, this message translates to:
  /// **'I request that the portion of my compensation not disbursed be donated to the club {club_name} and ask for a corresponding donation receipt.'**
  String trainerWaiverDonationClause(Object club_name);

  /// No description provided for @trainerWaiverTaxExemptionClause.
  ///
  /// In en, this message translates to:
  /// **'I hereby state that the tax exemption under § 3 No. 26a EStG has not already been applied to other voluntary activities.'**
  String get trainerWaiverTaxExemptionClause;

  /// No description provided for @trainerTaxExemptionStatement.
  ///
  /// In en, this message translates to:
  /// **'Tax exemption declaration'**
  String get trainerTaxExemptionStatement;

  /// No description provided for @trainerTaxExemptionClause.
  ///
  /// In en, this message translates to:
  /// **'Declaration for compensation accounting using the trainer tax exemption under § 3 No. 26 EstG between the club {club_name}, represented by the chairman {club_chairman}, and the coach.'**
  String trainerTaxExemptionClause(Object club_chairman, Object club_name);

  /// No description provided for @trainerTaxExemptionExplanation.
  ///
  /// In en, this message translates to:
  /// **'It is possible to use the applicable tax exemption amount for compensation accounting, currently up to €3,000 per year. Provided the other requirements for this tax-benefited secondary employment are met, it represents a personal tax exemption that can be applied to compensation arrangements with clubs, associations, and other nonprofit organizations. Eligible training activities are largely exempt from tax and social security contributions.'**
  String get trainerTaxExemptionExplanation;

  /// No description provided for @trainerTaxPartTime.
  ///
  /// In en, this message translates to:
  /// **'I am employed by the club as a coach only on a secondary basis.'**
  String get trainerTaxPartTime;

  /// No description provided for @trainerTaxAssignmentDeclaration.
  ///
  /// In en, this message translates to:
  /// **'For the application of my personal tax exemption in the year {fiscal_year}, I declare:'**
  String trainerTaxAssignmentDeclaration(Object fiscal_year);

  /// No description provided for @trainerTaxAssignmentExclusive.
  ///
  /// In en, this message translates to:
  /// **'I state that, apart from my coaching activities for the club, I do not engage in other eligible activities under § 3 No. 26 EStG. My personal tax exemption has not been partially or fully claimed elsewhere.'**
  String get trainerTaxAssignmentExclusive;

  /// No description provided for @trainerTaxAssignmentShared.
  ///
  /// In en, this message translates to:
  /// **'In addition to my activity for the club, I engage in other coaching activities for the following organization(s). A portion of my personal tax exemption under § 3 No. 26 EStG is already claimed there for compensation.'**
  String get trainerTaxAssignmentShared;

  /// No description provided for @trainerLicenseDeclaration.
  ///
  /// In en, this message translates to:
  /// **'Submission of licenses for the club allowance'**
  String get trainerLicenseDeclaration;

  /// No description provided for @trainerLicenseUsageStatement.
  ///
  /// In en, this message translates to:
  /// **'For the year {fiscal_year}, these licenses should be submitted by the club {club_name} for the club allowance according to sports funding guidelines.'**
  String trainerLicenseUsageStatement(Object club_name, Object fiscal_year);

  /// No description provided for @trainerLicenseUsageFull.
  ///
  /// In en, this message translates to:
  /// **'The license should be used in full for the club.'**
  String get trainerLicenseUsageFull;

  /// No description provided for @trainerLicenseUsageSplit.
  ///
  /// In en, this message translates to:
  /// **'The license should be shared with the club.'**
  String get trainerLicenseUsageSplit;

  /// No description provided for @signatureWithDateAndPlace.
  ///
  /// In en, this message translates to:
  /// **'Place/Date/Signature'**
  String get signatureWithDateAndPlace;

  /// No description provided for @signatureWithDate.
  ///
  /// In en, this message translates to:
  /// **'Date/Signature'**
  String get signatureWithDate;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
