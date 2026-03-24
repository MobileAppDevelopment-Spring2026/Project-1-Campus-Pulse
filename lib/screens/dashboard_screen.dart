import 'package:flutter/material.dart';
import '../controllers/home_dashboard_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 36),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '🎉 Campus Pulse: Events, Teams & Social Missions',
                    style: GoogleFonts.caveat(
                      color: Colors.white,
                      fontSize: 54,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 80),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Quick Access",
                          style: GoogleFonts.kalam(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.indigo.shade400,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 12,
                          runSpacing: 16,
                          children: [
                            _buildDashboardFeature(
                              context,
                              icon: Icons.event_note,
                              title: "Event Discovery",
                              description:
                                  "Explore events by interests and goals",
                              color: Colors.lightBlue.shade100,
                              onPressed: () {
                                DashboardController.navigateToExpenseEntry(
                                    context);
                              },
                            ),
                            _buildDashboardFeature(
                              context,
                              icon: Icons.groups,
                              title: "Team Collaboration",
                              description: "Join teams and assign event tasks",
                              color: Colors.amber.shade100,
                              onPressed: () {
                                DashboardController.navigateToBudgetSetup(
                                    context);
                              },
                            ),
                            _buildDashboardFeature(
                              context,
                              icon: Icons.flag_circle,
                              title: "Social Missions",
                              description:
                                  "Complete cross-club engagement missions",
                              color: Colors.green.shade100,
                              onPressed: () {
                                DashboardController.navigateToSocialMissions(
                                    context);
                              },
                            ),
                            _buildDashboardFeature(
                              context,
                              icon: Icons.insights,
                              title: "Engagement Reports",
                              description:
                                  "Track streaks, participation and badges",
                              color: Colors.purple.shade100,
                              onPressed: () {
                                DashboardController.navigateToReportsAndCharts(
                                    context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardFeature(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 185,
      child: Column(
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              minimumSize: const Size(180, 95),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              side: const BorderSide(color: Colors.black, width: 1.5),
            ),
            onPressed: onPressed,
            child: Column(
              children: [
                Icon(icon, color: Colors.black, size: 30),
                const SizedBox(height: 6),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kalam(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}
