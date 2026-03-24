import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/social_missions_catalog.dart';
import '../database/event_database_helper.dart';
import '../models/event_model.dart';
import 'dashboard_screen.dart';
import '../utils/app_screen_widgets.dart';

class SocialMissionsScreenState extends State<SocialMissionsScreen> {
  final ExpenseDatabaseHelper _dbHelper = ExpenseDatabaseHelper();
  final Set<int> _completedMissions = <int>{};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMissionProgress();
  }

  Future<void> _loadMissionProgress() async {
    final Set<int> completedMissionIds =
        await _dbHelper.getCompletedMissionIds();
    if (!mounted) {
      return;
    }

    setState(() {
      _completedMissions
        ..clear()
        ..addAll(completedMissionIds);
      _isLoading = false;
    });
  }

  Future<void> _toggleMissionCompletion(SocialMission mission) async {
    final int missionId = mission.id;
    final bool isCompleted = _completedMissions.contains(missionId);

    if (missionId == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unable to update this mission right now.')),
      );
      return;
    }

    if (isCompleted) {
      final int? linkedExpenseId =
          await _dbHelper.getLinkedExpenseIdForMission(missionId);

      if (syncMissionsToEngagementReports && linkedExpenseId != null) {
        await _dbHelper.unmarkExpenseAsReserved(linkedExpenseId);
      }

      await _dbHelper.upsertMissionProgress(
        missionId: missionId,
        isCompleted: false,
        linkedExpenseId: linkedExpenseId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _completedMissions.remove(missionId);
      });
      return;
    }

    int? linkedExpenseId;
    if (syncMissionsToEngagementReports) {
      final int? existingLinkedExpenseId =
          await _dbHelper.getLinkedExpenseIdForMission(missionId);
      if (existingLinkedExpenseId != null) {
        await _dbHelper.markExpenseAsReserved(existingLinkedExpenseId);
        linkedExpenseId = existingLinkedExpenseId;
      } else {
        linkedExpenseId = await _dbHelper.insertExpense(
          Expense(
            amount: mission.points,
            date: DateTime.now(),
            category: socialMissionsCategory,
            notes: 'Mission completed: ${mission.title}',
            isReserved: true,
          ),
        );
      }
    }

    await _dbHelper.upsertMissionProgress(
      missionId: missionId,
      isCompleted: true,
      linkedExpenseId: linkedExpenseId,
    );

    if (!mounted) {
      return;
    }

    setState(() {
      _completedMissions.add(missionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Missions',
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
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: socialMissions.length,
                  itemBuilder: (context, index) {
                    final SocialMission mission = socialMissions[index];
                    final int missionId = mission.id;
                    final bool isCompleted =
                        _completedMissions.contains(missionId);

                    return Card(
                      color: isCompleted
                          ? Colors.green.shade100
                          : Colors.white.withOpacity(0.92),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mission.title,
                              style: GoogleFonts.archivo(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mission.description,
                              style: GoogleFonts.rubik(fontSize: 16),
                            ),
                            if (syncMissionsToEngagementReports) ...[
                              const SizedBox(height: 6),
                              Text(
                                'Engagement points: ${mission.points.toStringAsFixed(0)}',
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isCompleted
                                      ? Colors.green.shade300
                                      : Colors.lightBlue.shade100,
                                  side: const BorderSide(
                                      color: Colors.black, width: 1.2),
                                ),
                                onPressed: () =>
                                    _toggleMissionCompletion(mission),
                                child: Text(
                                  isCompleted
                                      ? 'Completed (Tap to Undo)'
                                      : 'Mark as Completed',
                                  style: GoogleFonts.ibmPlexSansArabic(
                                    color: Colors.black,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
