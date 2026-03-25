# Selected Presentation Questions Form

## Course Information
- Course Name: Mobile App Development
- Course Section: CSC 4360
- Instructor: Louis Henry
- Semester/Term: Spring 2026

## Team Information
- Group Name: Sophie Nguyen - Campus Pulse
- App/Project Title: Campus Pulse
- Presentation Date: 20 March, 2026

### Team Member
1. Sophie Nguyen

## Selected Questions

1. Question: What are the key advantages of using Flutter for this cross-platform project?
   - Category: Flutter Framework & Cross-Platform Concepts
   - Answer: Flutter lets me build one app for Android and iOS using one codebase. It saves time, keeps UI consistent, and is fast to develop because of hot reload.
   - Evidence to Show (code file/commit/UI/screenshot): lib/main.dart, README.md (Tech Stack section)

2. Question: Which state management technique did you choose (setState, Provider, Riverpod, BLoC) and why?
   - Category: State Management
   - Answer: I used setState with controller classes. My app is medium-sized, so this is simple, easy to understand, and quick to maintain.
   - Evidence to Show (code file/commit/UI/screenshot): lib/screens/event_discovery_screen.dart (setState calls), lib/controllers/

3. Question: Describe one state-flow interaction from user action to UI update in your app.
   - Category: State Management
   - Answer: In Event Discovery, when the user taps Save Event, the app validates input, writes to SQLite, reloads the event list, then calls setState so the new event appears immediately.
   - Evidence to Show (code file/commit/UI/screenshot): lib/screens/event_discovery_screen.dart (lines 22, 29, 178), lib/controllers/event_discovery_controller.dart (saveExpense method)

4. Question: What state-related challenge did you face, and what fix improved reliability?
   - Category: State Management
   - Answer: A common issue was updating UI after async calls when the screen might already be closed. I fixed this with if (mounted) checks before calling setState.
   - Evidence to Show (code file/commit/UI/screenshot): lib/screens/event_discovery_screen.dart (line 24), lib/screens/team_collaboration_screen.dart (mounted checks in initState)

5. Question: How did you make the interface intuitive and responsive across device sizes/orientations?
   - Category: UI/UX Design
   - Answer: I used SingleChildScrollView, Wrap, and flexible layout widgets so content does not overflow. I also used clear cards, icons, and section titles so users can quickly understand each feature.
   - Evidence to Show (code file/commit/UI/screenshot): lib/screens/dashboard_screen.dart (Wrap layout, SizedBox, responsive spacing), lib/screens/event_discovery_screen.dart (SingleChildScrollView)

6. Question: What usability improvement did you make after testing feedback?
   - Category: UI/UX Design
   - Answer: I added better empty-state messages and snackbars (like "No reserved events yet" or invalid input messages), so users always know what to do next.
   - Evidence to Show (code file/commit/UI/screenshot): lib/screens/event_discovery_screen.dart (empty state container), lib/controllers/event_discovery_controller.dart (SnackBar messages)

7. Question: Explain your local data structure (tables/columns/keys or preference groups).
   - Category: Local Data Persistence (SQLite / SharedPreferences)
   - Answer: I used SQLite with multiple tables: expense_table for events/engagement data (id, amount, date, category, notes, is_reserved), mission_progress_table for mission tracking, team_assignment_table for task assignments, team_membership_table for join state, and budget_table for team capacity.
   - Evidence to Show (code file/commit/UI/screenshot): lib/database/event_database_helper.dart (_createDb method), lib/database/team_budget_database_helper.dart

8. Question: How are CRUD operations implemented and validated in your app?
   - Category: Local Data Persistence (SQLite / SharedPreferences)
   - Answer: I use helper classes (ExpenseDatabaseHelper, BudgetDatabaseHelper) for insert, read, update, and delete. Before saving, I validate user input (like positive numbers and required fields), then show feedback using SnackBar or dialogs.
   - Evidence to Show (code file/commit/UI/screenshot): lib/database/event_database_helper.dart (insertExpense, getExpenseList, deleteExpense methods), lib/controllers/event_discovery_controller.dart (saveExpense validation)

9. Question: Which SDLC approach best matches your team workflow, and why?
   - Category: SDLC Practices
   - Answer: Iterative/Agile style fits best. I built feature by feature (dashboard, events, teams, missions, reports), tested each part, and improved it in small cycles.
   - Evidence to Show (code file/commit/UI/screenshot): lib/screens/ (multiple screen files built incrementally), README.md (Key Features section)

10. Question: If you had one more week, what development-cycle improvement would you prioritize next?
   - Category: SDLC Practices
   - Answer: I would add more automated tests (widget + database tests). That would reduce bugs and make future changes safer and faster.
   - Evidence to Show (code file/commit/UI/screenshot): test/widget_test.dart (existing test structure)

## Final Confirmation
- [x] This form includes the questions selected for our presentation.
- [x] We will submit this form at the same time as our project package.