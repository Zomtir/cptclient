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
