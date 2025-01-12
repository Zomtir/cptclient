# CHANGELOG

## Release v1.2.0 (12 Jan 2024)

- feat: Session recovery overhaul
  - UI shows login key and expiration date
  - Multiple sessions are possible
- feat: PDF accounting
  - Coach accounting
  - Waiver/donation statement
  - List of hours
  - Tax exemption statement
  - License usage statment
- feat: Text wrap list for club disciplines
- feat: Allow alphanumeric license number
- feat: Added location to presence statistics
- feat: Highlight for current day in calendar
- refactor: Merge event class division and event organisation page
- locale: Translate tooltips of the user possession page
- fix: Admin unable to change event passwords
- fix: Insufficient feedback for invalid user names
- fix: Moved navi key to GoRouter to obtain build context

## Release v1.1.0 (21st Dec 2024)

- feat: Improved user bank details
- feat: User licenses
- feat: Extended club info
- feat: Improved About page (layout, release information, authors)
- feat: Improved club stock management layout
- feat: SnackBar messages with global key
- fix: Deletion of club stock resulted in duplication
- chore: Kotlin version update (1.9) and flutter build choice

## Release v1.0.0 (21st Sep 2024)

- feat: Organisations and Affiliations
  - Added classes
  - Added API calls
  - Added pages
  - Added permissions
  - Refactored club and event statistics related to organisations

- feat: Improved stock management
  - Added stockID and stock storage
  - An owned item can no longer have a connection to a stock
  - An item can be restocked on any stock that has the item type

- feat: Use GoRouter
  - Have a loading page with an async online check for a delayed redirect
  - Worked around a flutter issues with cold start double route calls
  - Added the functionality to login as event with key/pwd parameters
  - Improved loading of the cptclient.yaml config file

- feat: Event rework
  - Made event presence more verbose
  - Event registration is now required for being in the presence pool
  - Split owner as seperate status
  - Add leader and supporter next to participant
  - Added a FilterPage to support positive/negative user filters
  - Fixed all event API calls

- feat: Added height and weight to users
- feat: Translate course event statistic headers (#35)
- feat: Add tooltips to common entities such as users
- feat: TextButtons for packlist overview
- feat: Add notes to event management and ownership detail page
- feat: Unicode export
- feat: Hide handout from accidents
- feat: Clickable URL
- feat: Organisation statistic for events and clubs
- feat: Implement RetryClient
- feat: Event owner filter/registration
- feat: Change course assignment for events as owners
- feat: Change course assignment for events as admin
- feat: Course moderator pages
- feat: Admin create events
- feat: Strike-through for canceled events
- feat: Localize acceptance and occurrence
- feat: Export CSV for presence statistics
- feat: Save QR code as image
- feat: Export event credentials
- feat: Course team sieves
- feat: Display event occurrence
- feat: Improve event ownership page
- feat: Event Occurrence and Acceptance
- feat: Compact ConfirmationField
- feat: Confirmation Field
- feat: Redesign app buttons
- feat: Split server connection settings from generic settings
- feat: SkillRank and SkillRange Fields
- feat: Shared Preferences
- feat: Inspect club loans per item
- feat: Enable returning items from user possessions
- feat: More localization on the settings page
- feat: Improve calendar design
- feat: Improved menu design with Cards
- feat: Change language in settings
- feat: Gender Dropdown
- feat: Improved AppInfoRow design
- feat: Event statistic for participant age/gender divisions
- feat: Event item prep page
- feat: Personal possession list
- feat: Show user permissions in profile
- refactor: Call stats with less tuples
- refactor: Improved ownership/possession layout of user items
- refactor: Remove container from dialog action buttons
- refactor: Remove data processing user info
- refactor: DateTime format and parsing without time zone
- refactor: Utility functions and export structure
- refactor: Change leader/supporter order in EnrollPage
- refactor: Restructured api folders
- refactor: Restructure app materials
- refactor: Use WidgetStatePropertyAll
- refactor: Consistent menu labels for administration
- refactor: More card usage over buttons
- refactor: Reworked Gender enum
- refactor: MenuSection for EnrollPage
- refactor: Reorder participant->leader->supporter
- refactor: Consistent gender enum
- remove: Remove AppIconButton
- remove: Remove PanelSwiper
- locale: Use localized name for gender
- locale: Competence localization
- locale: Statistic localization
- fix: Sort items in stock management"
- fix: Add context labels for dropdows in some filters
- fix: PNG/CSV export for Android
- fix: Sort entries in Searchable Panel
- fix: Sort teams in overview
- fix: Organisation stats sorting fix
- fix: Only remove entries from selection if call was successfull
- fix: Show skill title in requirement tile
- fix: Redirect /user to /login before resume
- fix: More responsive and clear session resume
- fix: Adapt course statistics for new user attendence types
- fix: Server preference propagation
- fix: Session resume state missmatch
- fix: Current language not showing in settings
- fix: Wrong gender label in user edit
- fix: Fix event delete API call
- fix: Push to login route
- fix: Improved DataTable visibility
- fix: Sort item categories
- fix: itemcat_edit missing a parameter
- fix: item_edit missing a parameter
- fix: More Flutter web updates
- fix: Updated deprecated flutter web project settings
- chore: Flutter upgrade to 3.24
- chore: Disable tests because of HttpClient
- chore: Update github action flutter version to 3.24
- chore: Exclusive github pages for main
- license: Reformatted license and waiver
- license: Waiver and author restructure

## Release v0.9 (29th April 2024)

- feat: Inventory management
- feat: Course skill requirements
- feat: Club statistics
- feat: Event participant and owner registrations
- fix: Better login hints
- fix: Default user key and pw is random
- chore: Flutter package updates
- docs: Initial super user
- ci: Option to publish to iOS App Store
- ci: Enable upload to GitHub release

## Release v0.8 (29th April 2024)

- feat: Adapt app name
- feat: Club and location administration
- feat: Rework team permissions
- feat: Renamed slot to event
- feat: Calender rework
  - Calendar month overview now shows slots
  - Improved API and caching of events
  - Limited maximum visible events per day to 4 in the month overview
  - Added a daily calendar overview
- feat: Event participant and owner invites/uninvites
- feat: Skill Management Page
- feat: Improved Competence Page
- feat: Added TeamDetailManagementPage
- feat: Bookmarking events
- feat: Introduced the AppField widget
- feat: Deprecating course classes and generalizing events
- feat: Add user nickname filtering
- feat: Add location description
- feat: Add club key
- feat: More searchable panels
- feat: Extend Term from FieldInterface
- feat: Polish competence pages
- feat: Regenerate launch icon
- feat: Improved diacritic compare
- feat: Enable all platforms
- feat: Support Environment variables
- feat: Copy default cptclient.yaml
- test: Ignore all unused elements
- chore: Sanitize Date/DateTime fmt and parse
- chore: Delete SelectionData
- chore: Recreate Web and iOS
- chore: Regenerate Android folder
- fix: Fixed some UTF8 decoding
- fix: Fixed tile removal on SelectionPage
- docs: Adapt README for CI and release versioning
- docs: Readme restructure
- ci: Update upload-pages-artifact to v3
- ci: Build on manual release only
- ci: Always call test before build
- ci: Set up GitHub workflows
- ci: Call test on main push
- ci: Disable tests for format

## Release v0.7 (10th March 2024)

- README updates for getting started
- WAIVER updates for contributing
- AUTHOR updates to include GPG signatures
- Added a Tribox and Bibox widget
- Reworked TilePicker and TileSelector
  - Rewrote the SearchablePanel
  - Deleted the SelectionPanel
  - Deleted the type specific selection pages
  - Added a generic SelectionPage
- Class and course redesign
  - Hierarchy restructure
  - Added Course Participation statistics and inspection
  - Added Owner Participation statistics and inspection
  - Added Course Class statistics and inspection
- Allowed to duplicate teams including members
- Improved creating new Events
- Improved Event ownership and management
- Implemented course class batch create
- Improved the Enroll Page with user, owner and note edit
- Reworked the Slot Edit page
- Slot requirement changes
- Revamped the Team module
- Revamped member landing page
- Changed some theme coloring
- Added Term Administration page
- Split login pages into user, slot, course and location login
- Add more slot attributes
- Support for new active/enabled tags
- Added class team participant invites
- Added class team owner invites
- Fixed rights being null for new teams
- Renamed ranking to competence
- Renamed branch to skill
- Added initial support for Clubs
- Added User nickname
- Introduced a YAML config file
- Started localization for EN and DE
- Improved JSON parsing for some nullable types
- Added diacritic removal for sorting Umlaut in User names
- Improved API calls including NaiveDates and NaiveTimes
- Lowered minimum date to year 1900
- Changed syntax for be lower case for server call functions
- Added a new project logo
- Added the Public Domain logo
- Reworked the credits page
- Updated the Web build favicon
- Improved code analysis options with linter rules
- Increase SDK versions
- Improved Android build
  - Added an Android app icon
  - Improved the Android app name
  - Improved gradle build

## Release v0.6 (5th May 2023)

- Improved asset handling
- Sort users in lists
- Implement session resume
- Implement course login
- Add Number Selector
- Add DatePicker
- Add TimePicker
- Add more user details
- Custom popup dialog
- Improved the calender view
- Implement team members

## Release v0.5 (7th February 2023)

- Custom user salt
- HTTPS support
- Added filtering for users
- Replaced `access` slot attribute with `public`
- Added password input forms
- Improved slot login procedure
- Enabled slot participant handling for classes
- Improved user attribute handling
- Added Location login and login defaults
- Added a User selection panel
- Improved the Course admin page
- Added a Class Admin page

## Release v0.4 (12th January 2023)

- Outsourced course server calls into dedicated files
- Rewired the rights class for users
- Reuse right for team
- Improved the Course admin page
- Added an Inventory icon

## Release v0.3 (15th December 2022)

- Improved the Course management page
- Added Event owners
- Improved Icons
- Improved and fixed flutter routes
- Added a DatePicker
- Added a DateRangePicker
- Preparations for event API calls
- Improved Team management page

## Release v0.2 (9th July 2022)

- Added first scaffold of a calendar
- Standalone slots are now called events
- Added Callbacks functions to update parent pages instead of RouteAware
- Added a customizable initial index for SwipePanel
- Reworked json user attributes
- Added Login feedback to the user

## Release v0.1 (17 Nov 2021)

First public release.

- Basic README
- Public Domain LICENSE
- Most JSON classes for access, branch, course, credentials, location, member, ranking, session, slot, team and user
- Initial pages for Connection, Login, Slot, Team and Ranking management
- Initial artwork for splash screen and module icons
