import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../database/event_database_helper.dart';
import '../models/event_model.dart';
import 'dashboard_screen.dart';
import '../utils/app_screen_widgets.dart';

class BudgetSetupScreenState extends State<BudgetSetupScreen> {
  final ExpenseDatabaseHelper _dbHelper = ExpenseDatabaseHelper();
  final List<Map<String, dynamic>> _teams = [];
  final List<Expense> _reservedEvents = [];
  bool _isLoadingEvents = true;

  static const List<String> _roleOptions = <String>[
    'Team Lead',
    'Logistics Coordinator',
    'Outreach Coordinator',
    'Mission Captain',
    'Volunteer',
  ];

  void _showSnackBar(String message) {
    if (!mounted) {
      return;
    }
    final ScaffoldMessengerState? messenger =
        ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  void initState() {
    super.initState();
    _seedDefaultTeams();
    _loadReservedEvents();
    _loadTeamMemberships();
    _loadSavedAssignments();
  }

  Future<void> _loadTeamMemberships() async {
    final Map<String, bool> membershipByTeam =
        await _dbHelper.getAllTeamMemberships();

    for (final Map<String, dynamic> team in _teams) {
      final String teamName = team['name'] as String;
      team['joined'] = membershipByTeam[teamName] ?? false;
    }

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _loadSavedAssignments() async {
    for (final Map<String, dynamic> team in _teams) {
      final String teamName = team['name'] as String;
      final List<Map<String, dynamic>> rows =
          await _dbHelper.getTeamAssignmentsByTeamName(teamName);

      final List<Map<String, dynamic>> parsedAssignments = rows
          .map((row) => {
                'eventId': row['event_id'],
                'eventTitle': row['event_title'] ?? 'Reserved Event',
                'eventDate': DateTime.tryParse(row['event_date'] ?? '') ??
                    DateTime.now(),
                'member': row['member_name'] ?? '',
                'role': row['role'] ?? '',
                'responsibility': row['responsibility'] ?? '',
              })
          .toList();

      team['assignments'] = parsedAssignments;
    }

    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Future<void> _loadReservedEvents() async {
    final List<Expense> reserved = await _dbHelper.getReservedExpenseList();
    if (!mounted) {
      return;
    }

    setState(() {
      _reservedEvents
        ..clear()
        ..addAll(reserved);
      _isLoadingEvents = false;
    });
  }

  void _seedDefaultTeams() {
    _teams.clear();
    _teams.addAll(<Map<String, dynamic>>[
      {
        'name': 'Event Ops Crew',
        'joined': false,
        'members': <String>['Avery', 'Jordan', 'Taylor'],
        'assignments': <Map<String, dynamic>>[],
      },
      {
        'name': 'Mission Makers',
        'joined': false,
        'members': <String>['Casey', 'Riley', 'Morgan'],
        'assignments': <Map<String, dynamic>>[],
      },
      {
        'name': 'Campus Connectors',
        'joined': false,
        'members': <String>['Parker', 'Sam', 'Jamie'],
        'assignments': <Map<String, dynamic>>[],
      },
      {
        'name': 'Sponsorship Strategists',
        'joined': false,
        'members': <String>['Dakota', 'Harper', 'Skyler'],
        'assignments': <Map<String, dynamic>>[],
      },
      {
        'name': 'Experience Designers',
        'joined': false,
        'members': <String>['Quinn', 'Emerson', 'Rowan'],
        'assignments': <Map<String, dynamic>>[],
      },
      {
        'name': 'Impact Analytics',
        'joined': false,
        'members': <String>['Blake', 'Kendall', 'Reese'],
        'assignments': <Map<String, dynamic>>[],
      },
    ]);
  }

  Future<void> _toggleJoinTeam(int index) async {
    final bool nextJoinedState = !(_teams[index]['joined'] as bool);
    final String teamName = _teams[index]['name'] as String;

    setState(() {
      _teams[index]['joined'] = nextJoinedState;
      if (!nextJoinedState) {
        (_teams[index]['assignments'] as List<Map<String, dynamic>>).clear();
      }
    });

    await _dbHelper.upsertTeamMembership(
      teamName: teamName,
      isJoined: nextJoinedState,
    );

    if (!nextJoinedState) {
      await _dbHelper.deleteTeamAssignmentsByTeamName(teamName);
    }
  }

  Future<void> _assignTask(int index) async {
    if (!(_teams[index]['joined'] as bool)) {
      _showSnackBar('Join this team before assigning roles.');
      return;
    }

    if (_reservedEvents.isEmpty) {
      _showSnackBar(
        'No reserved events yet. Reserve an event first, then assign team responsibilities.',
      );
      return;
    }

    final Map<String, dynamic> team = _teams[index];
    final List<String> members = List<String>.from(team['members'] as List);
    final List<Map<String, dynamic>> existingAssignments =
        List<Map<String, dynamic>>.from(team['assignments'] as List);
    final Set<String> assignedMembers = existingAssignments
        .map((assignment) => (assignment['member'] ?? '').toString())
        .where((member) => member.isNotEmpty)
        .toSet();
    final List<String> availableMembers =
        members.where((member) => !assignedMembers.contains(member)).toList();
    final List<Expense> selectableReservedEvents =
        _reservedEvents.where((event) => event.id != null).toList();

    if (selectableReservedEvents.isEmpty) {
      _showSnackBar('No valid reserved events available for assignment.');
      return;
    }

    if (availableMembers.isEmpty) {
      _showSnackBar(
        'All team members are already assigned. Clear assignments or leave and rejoin to reassign.',
      );
      return;
    }

    int? selectedEventId = selectableReservedEvents.first.id;
    String selectedRole = _roleOptions.first;
    String selectedMember = availableMembers.first;
    String responsibilityInput = '';
    String? dialogError;

    final Map<String, dynamic>? assignmentDraft =
        await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, dialogSetState) {
            return AlertDialog(
              title: Text(
                'Assign Responsibility',
                style: GoogleFonts.archivo(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: MediaQuery.of(dialogContext).size.width * 0.82,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      DropdownButtonFormField<int>(
                        value: selectedEventId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Reserved Event',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          dialogSetState(() {
                            selectedEventId = value;
                          });
                        },
                        selectedItemBuilder: (BuildContext context) {
                          return selectableReservedEvents
                              .map<Widget>((Expense event) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                event.notes.isEmpty
                                    ? 'Reserved Event'
                                    : event.notes,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList();
                        },
                        items: selectableReservedEvents
                            .map<DropdownMenuItem<int>>((Expense event) {
                          return DropdownMenuItem<int>(
                            value: event.id!,
                            child: Text(
                              event.notes.isEmpty
                                  ? 'Reserved Event'
                                  : event.notes,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedMember,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Team Member',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          dialogSetState(() {
                            selectedMember = value ?? selectedMember;
                          });
                        },
                        items: members
                            .map<DropdownMenuItem<String>>((String member) {
                          final bool isAlreadyAssigned =
                              assignedMembers.contains(member);
                          return DropdownMenuItem<String>(
                            value: member,
                            enabled: !isAlreadyAssigned,
                            child: Text(
                              isAlreadyAssigned ? '$member (Assigned)' : member,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: selectedRole,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Role',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          dialogSetState(() {
                            selectedRole = value ?? selectedRole;
                          });
                        },
                        items: _roleOptions
                            .map<DropdownMenuItem<String>>((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: Text(
                              role,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        onChanged: (value) {
                          responsibilityInput = value;
                          if (dialogError != null) {
                            dialogSetState(() {
                              dialogError = null;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          hintText:
                              'Responsibility (e.g., Check-in desk setup)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      if (dialogError != null) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            dialogError!,
                            style: TextStyle(
                              color: Theme.of(dialogContext).colorScheme.error,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    final String responsibility = responsibilityInput.trim();
                    if (responsibility.isEmpty) {
                      dialogSetState(() {
                        dialogError = 'Please enter a responsibility task.';
                      });
                      return;
                    }
                    if (selectedEventId == null) {
                      dialogSetState(() {
                        dialogError = 'Please select a reserved event.';
                      });
                      return;
                    }

                    Navigator.of(dialogContext).pop({
                      'eventId': selectedEventId,
                      'member': selectedMember,
                      'role': selectedRole,
                      'responsibility': responsibility,
                    });
                  },
                  child: const Text('Assign'),
                ),
              ],
            );
          },
        );
      },
    );

    if (assignmentDraft == null) {
      return;
    }

    final int selectedEventValue = assignmentDraft['eventId'] as int;
    final Expense event = selectableReservedEvents.firstWhere(
      (item) => item.id == selectedEventValue,
    );

    await _dbHelper.insertTeamAssignment(
      teamName: team['name'] as String,
      eventId: event.id,
      eventTitle: event.notes.isEmpty ? 'Reserved Event' : event.notes,
      eventDate: event.date,
      member: assignmentDraft['member'] as String,
      role: assignmentDraft['role'] as String,
      responsibility: assignmentDraft['responsibility'] as String,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      (team['assignments'] as List<Map<String, dynamic>>).add({
        'eventId': event.id,
        'eventTitle': event.notes.isEmpty ? 'Reserved Event' : event.notes,
        'eventDate': event.date,
        'member': assignmentDraft['member'] as String,
        'role': assignmentDraft['role'] as String,
        'responsibility': assignmentDraft['responsibility'] as String,
      });
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showSnackBar('Responsibility assigned and saved.');
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Team Collaboration',
          style: GoogleFonts.kalam(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo.shade400,
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 12),
                Text(
                  'Reserved Events Ready for Team Planning',
                  style: GoogleFonts.archivo(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (_isLoadingEvents)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator(),
                  )
                else if (_reservedEvents.isEmpty)
                  Text(
                    'No reserved events yet. Reserve events from Event Discovery or Social Missions first.',
                    style: GoogleFonts.rubik(fontSize: 14),
                  )
                else
                  SizedBox(
                    height: 260,
                    child: Scrollbar(
                      thumbVisibility: true,
                      child: ListView.builder(
                        itemCount: _reservedEvents.length,
                        itemBuilder: (context, index) {
                          final Expense event = _reservedEvents[index];
                          return Card(
                            color: Colors.white.withOpacity(0.9),
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: const Icon(Icons.event_available),
                              title: Text(
                                event.notes.isEmpty
                                    ? 'Reserved Event'
                                    : event.notes,
                                style: GoogleFonts.rubik(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                '${event.category} • ${DateFormat.yMMMd().format(event.date)}',
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                Text(
                  'Join and manage teams for upcoming campus events:',
                  style: GoogleFonts.rubik(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                ...List.generate(_teams.length, (index) {
                  final Map<String, dynamic> team = _teams[index];
                  final List<Map<String, dynamic>> assignments =
                      List<Map<String, dynamic>>.from(
                    team['assignments'] as List,
                  );
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    color: Colors.white.withOpacity(0.93),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            team['name'] as String,
                            style: GoogleFonts.archivo(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (team['joined'] as bool)
                                ? 'Status: Joined'
                                : 'Status: Not Joined',
                            style: GoogleFonts.rubik(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Members: ${(team['members'] as List<String>).join(', ')}',
                            style: GoogleFonts.rubik(fontSize: 13),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal.shade100,
                                ),
                                onPressed: () => _toggleJoinTeam(index),
                                child: Text((team['joined'] as bool)
                                    ? 'Leave'
                                    : 'Join'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange.shade100,
                                ),
                                onPressed: () => _assignTask(index),
                                child: const Text('Assign Role Task'),
                              ),
                            ],
                          ),
                          if ((team['joined'] as bool) &&
                              assignments.isNotEmpty)
                            const SizedBox(height: 10),
                          ...((team['joined'] as bool)
                                  ? assignments
                                  : const <Map<String, dynamic>>[])
                              .map(
                            (assignment) => Container(
                              margin: const EdgeInsets.only(bottom: 7),
                              padding: const EdgeInsets.all(9),
                              decoration: BoxDecoration(
                                color: Colors.blueGrey.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.black12),
                              ),
                              child: Text(
                                '${assignment['member']} (${assignment['role']})\n'
                                'Event: ${assignment['eventTitle']} (${DateFormat.yMd().format(assignment['eventDate'] as DateTime)})\n'
                                'Task: ${assignment['responsibility']}',
                                style: GoogleFonts.rubik(fontSize: 13),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
