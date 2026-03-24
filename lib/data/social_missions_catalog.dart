class SocialMission {
  final int id;
  final String title;
  final String description;
  final double points;

  const SocialMission({
    required this.id,
    required this.title,
    required this.description,
    required this.points,
  });
}

const bool syncMissionsToEngagementReports = true;
const String socialMissionsCategory = 'Social Missions';

const List<SocialMission> socialMissions = [
  SocialMission(
    id: 1,
    title: 'Cross-Club Connector',
    description:
        'Attend one event hosted by a club you have never joined before.',
    points: 40,
  ),
  SocialMission(
    id: 2,
    title: 'Mission Study Circle',
    description:
        'Collaborate with classmates from two different academic tracks.',
    points: 45,
  ),
  SocialMission(
    id: 3,
    title: 'Campus Impact Sprint',
    description: 'Join a community service event and bring one new teammate.',
    points: 50,
  ),
  SocialMission(
    id: 4,
    title: 'Green Hour Challenge',
    description: 'Spend one hour in a campus sustainability activity.',
    points: 35,
  ),
  SocialMission(
    id: 5,
    title: 'Peer Mentor Moment',
    description: 'Help a junior student with one academic or campus question.',
    points: 38,
  ),
  SocialMission(
    id: 6,
    title: 'Wellness Buddy Walk',
    description: 'Invite a friend for a 30-minute wellness walk around campus.',
    points: 32,
  ),
  SocialMission(
    id: 7,
    title: 'Culture Exchange Table',
    description:
        'Join a conversation table with students from different cultures.',
    points: 44,
  ),
  SocialMission(
    id: 8,
    title: 'Skill Share Spotlight',
    description: 'Teach one practical skill to at least two classmates.',
    points: 47,
  ),
  SocialMission(
    id: 9,
    title: 'Volunteer Relay',
    description: 'Participate in two short volunteer tasks in the same week.',
    points: 52,
  ),
  SocialMission(
    id: 10,
    title: 'Community Story Capture',
    description: 'Collect and share one impact story from a campus initiative.',
    points: 42,
  ),
];
