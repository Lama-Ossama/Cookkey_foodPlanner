import 'package:flutter/material.dart';
import 'package:food_planner_app/models/meal_summary_model.dart';
import 'package:food_planner_app/helper/favorites_database.dart';
import 'package:food_planner_app/helper/plan_database.dart';
import 'package:food_planner_app/models/planned_meal_model.dart';
import 'package:food_planner_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class MealTile extends StatefulWidget {
  final MealSummary meal;

  const MealTile({super.key, required this.meal});

  @override
  State<MealTile> createState() => _MealTileState();
}

class _MealTileState extends State<MealTile> {

  late Future<bool> _isFavFuture;

  @override
  void initState() {
    super.initState();
    _isFavFuture = FavoritesDatabaseHelper.instance.isFavorite(widget.meal.id);
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              'mealDetails_screen',
              arguments: widget.meal.id,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.brown.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(2, 2),
                )
              ],
            ),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    widget.meal.thumbnail,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    widget.meal.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: FutureBuilder<bool>(
            future: _isFavFuture,
            builder: (context, snapshot) {
              final isFav = snapshot.data ?? false;
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.grey,
                ),
                onPressed: toggleFavorite,
              );

            },
          ),
        ),
        Positioned(
          bottom: 8,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.brown),
            onPressed: () => showDayPicker(context,widget.meal),
          ),
        ),


      ],
    );
  }
  void showDayPicker(BuildContext context, MealSummary meal) async {
    if (!mounted) return;

    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    await authProvider.checkLoginStatus();

    if (authProvider.isGuest || !authProvider.isFirebaseUserLoggedIn) {
      showLoginRequiredDialog();
      return;
    }

    final days = ['Saturday', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
    final bookedDays = <String>[];

    for (final day in days) {
      final isBooked = await PlanDatabaseHelper.instance.isDayBooked(day);
      if (isBooked) bookedDays.add(day);
    }

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Pick a day for this meal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...days.map((day) => ListTile(
              title: Text(day),
              trailing: bookedDays.contains(day) ? const Icon(Icons.check) : null,
              onTap: bookedDays.contains(day)
                  ? null
                  : () async {
                final plannedMeal = PlannedMeal(
                  id: meal.id,
                  name: meal.name,
                  thumbnail: meal.thumbnail,
                  day: day,
                );
                await PlanDatabaseHelper.instance.insertPlannedMeal(plannedMeal);

                if (mounted) {
                  Navigator.of(sheetContext).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${meal.name} added to $day\'s plan')),
                  );
                }
              },
            )),
          ],
        );
      },
    );
  }
  void toggleFavorite() async {
    if (!mounted) return;

    final authProvider = Provider.of<MyAuthProvider>(context, listen: false);
    await authProvider.checkLoginStatus();

    if (authProvider.isGuest || !authProvider.isFirebaseUserLoggedIn) {
      showLoginRequiredDialog();
      return;
    }

    final isFav = await FavoritesDatabaseHelper.instance.isFavorite(widget.meal.id);
    if (isFav) {
      await FavoritesDatabaseHelper.instance.removeFavorite(widget.meal.id);
    } else {
      await FavoritesDatabaseHelper.instance.insertFavorite(widget.meal);
    }

    if (mounted) {
      setState(() {
        _isFavFuture = FavoritesDatabaseHelper.instance.isFavorite(widget.meal.id);
      });
    }
  }

  void showLoginRequiredDialog() {
    // Check if widget is mounted before showing dialog
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (dialogContext) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text('This action requires you to login first.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Use dialogContext here
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
