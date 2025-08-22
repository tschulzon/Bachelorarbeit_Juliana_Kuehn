import 'package:flutter/material.dart';
import 'package:plantagotchi/models/friend.dart';
import 'package:plantagotchi/viewmodels/user_viewmodel.dart';
import 'package:plantagotchi/widgets/toggle_switch.dart';
import 'package:provider/provider.dart';

// This is the Friendspage view
// It displays a list of friends and a ranking of users based on their level and XP
// In the future it will also allow users to add friends and view their plants
class Friendspage extends StatefulWidget {
  const Friendspage({super.key});

  @override
  State<Friendspage> createState() => _FriendspageState();
}

class _FriendspageState extends State<Friendspage> {
  int selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final fontstyle = Theme.of(context).textTheme;
    final user = Provider.of<UserViewModel>(context).user;

    final labelNames = ["Freunde", "Rangliste"];

    Widget friendsWidget;

    if (user.friends == null || user.friends!.isEmpty) {
      friendsWidget = Center(
        child: Text(
          "Du hast noch keine Freunde hinzugefügt. Lade deine Freunde ein, um eure Pflanzen gegenseitig betrachten zu können!",
          style: fontstyle.bodyMedium,
          textAlign: TextAlign.center,
        ),
      );
    } else {
      friendsWidget = Expanded(
        child: ListView.builder(
          itemCount: user.friends!.length,
          itemBuilder: (context, index) {
            final friend = user.friends![index];
            return Card(
              elevation: 4.0,
              color: colors.primary,
              surfaceTintColor: colors.onPrimary,
              margin:
                  const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  debugPrint('Tapped on friend: ${friend.name}');
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.onPrimary,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            friend.profileAvatar,
                            width: 70,
                            height: 70,
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            friend.name,
                            style: fontstyle.displayMedium,
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            children: [
                              Icon(
                                Icons.local_florist,
                                color: colors.onPrimary,
                                size: 24,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                friend.plantCount.toString(),
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Icon(
                                Icons.workspace_premium,
                                color: colors.onPrimary,
                                size: 24,
                              ),
                              const SizedBox(width: 5.0),
                              Text(
                                friend.level.toString(),
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(width: 15.0),
                              Image.asset(
                                'assets/images/xp-icon.png',
                                width: 28,
                                height: 28,
                                color: colors.onPrimary,
                              ),
                              Text(
                                friend.xp.toString(),
                                style: TextStyle(
                                  color: colors.onPrimary,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }

    // Create a Friend object for the current user for displaying in the ranking
    // This is used to show the current user's stats alongside friends in the ranking
    final currentUserAsFriend = Friend(
        id: user.id ?? '',
        name: user.username ?? 'Aktueller User',
        profileAvatar:
            user.profilePicture ?? 'assets/images/default-avatar.png',
        plantCount: user.plants?.length ?? 0,
        level: user.level ?? 1,
        xp: user.xp ?? 0);

    final allUsersForRanking = [
      currentUserAsFriend, // Include the current user
      ...?user.friends, // Include friends if they exist
    ];

    // Sort friends by level and then by XP for ranked list
    final sortedFriends = [...allUsersForRanking]..sort((a, b) {
        // First Level descending, then XP descending
        if (b.level != a.level) {
          return b.level.compareTo(a.level);
        } else {
          return b.xp.compareTo(a.xp);
        }
      });

    Widget rankingWidget = Expanded(
      child: ListView.builder(
        itemCount: sortedFriends.length,
        itemBuilder: (context, index) {
          final friend = sortedFriends[index];
          Widget leadingWidget;

          if (index == 0) {
            leadingWidget = Image.asset(
              'assets/images/gold-medal.png',
              width: 50,
              height: 50,
              fit: BoxFit.fitHeight,
            );
          } else if (index == 1) {
            leadingWidget = Image.asset(
              'assets/images/silber-medal.png',
              width: 50,
              height: 50,
              fit: BoxFit.fitHeight,
            );
          } else if (index == 2) {
            leadingWidget = Image.asset(
              'assets/images/bronze-medal.png',
              width: 50,
              height: 50,
              fit: BoxFit.fitHeight,
            );
          } else {
            leadingWidget = Container(
              margin: const EdgeInsets.only(left: 5.0, right: 5.0),
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }
          return Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: colors.primary.withOpacity(0.5),
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: leadingWidget,
                subtitle: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colors.primary,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          friend.profileAvatar,
                          width: 60,
                          height: 60,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          textAlign: TextAlign.left,
                          friend.name,
                          style: TextStyle(
                            color: colors.primary,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            Icon(Icons.workspace_premium,
                                color: colors.primary),
                            const SizedBox(width: 5.0),
                            Text(
                              friend.level.toString(),
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(width: 15.0),
                            Image.asset(
                              'assets/images/xp-icon.png',
                              width: 20,
                              height: 20,
                              color: colors.primary,
                            ),
                            const SizedBox(width: 5.0),
                            Text(
                              friend.xp.toString(),
                              style: TextStyle(
                                color: colors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.diversity_3, color: colors.primary),
                const SizedBox(width: 4),
                Text('Community', style: fontstyle.labelMedium),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Center(
              child: Container(
                width: 300,
                color: colors.primary,
                height: 1.0,
              ),
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: colors.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: CustomToggleSwitch(
                  countSwitches: 2,
                  labels: labelNames,
                  onToggle: (index) {
                    setState(() {
                      selectedTab = index;
                    });
                  },
                  initialLabelIndex: selectedTab,
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (selectedTab == 0) friendsWidget else rankingWidget,
          ],
        ));
  }
}
