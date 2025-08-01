// import 'package:flutter/material.dart';
// import 'package:job_board/features/home_jobs/presentation/screens/job_screen.dart';
// import 'package:job_board/features/home_jobs/test.dart';
// import 'package:job_board/features/job_applications/presentation/screens/applications_screen.dart';

// class MainNavigationScreen extends StatefulWidget {
//   final String role;

//   const MainNavigationScreen({required this.role, super.key});

//   @override
//   State<MainNavigationScreen> createState() => _MainNavigationScreenState();
// }

// class _MainNavigationScreenState extends State<MainNavigationScreen> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     final isAdmin = widget.role == 'admin';

//     final screens = isAdmin
//         ? [JobScreen(), Test(), ApplicationsScreen(), Test()]
//         : [JobScreen(), ApplicationsScreen(), Test()];

//     final items = isAdmin
//         ? const [
//             BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
//             BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.assignment),
//               label: 'Applications',
//             ),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//           ]
//         : const [
//             BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
//             BottomNavigationBarItem(
//               icon: Icon(Icons.assignment),
//               label: 'My Applications',
//             ),
//             BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//           ];

//     return Scaffold(
//       body: screens[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         onTap: (i) => setState(() => _currentIndex = i),
//         items: items,
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:job_board/features/home_jobs/presentation/cubit/navigation_cubit/navigation_cubit.dart';
import 'package:job_board/features/home_jobs/presentation/screens/job_screen.dart';
import 'package:job_board/features/home_jobs/test.dart';
import 'package:job_board/features/job_applications/presentation/screens/applications_screen.dart';
import 'package:job_board/features/users/presentation/screens/users_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final String role;

  const MainNavigationScreen({required this.role, super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  // int _currentIndex = 0;
  final selectedColor = const Color(0xFF4F4AD3);

  @override
  Widget build(BuildContext context) {
    final isAdmin = widget.role == 'admin';

    final screens = isAdmin
        ? [JobScreen(), UsersScreen(), ApplicationsScreen(), Test()]
        : [JobScreen(), ApplicationsScreen(), Test()];

    final items = isAdmin
        ? const [
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
            BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Users'),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'Applications',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ]
        : const [
            BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Jobs'),
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              label: 'My Applications',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ];

    return BlocBuilder<MainLayoutCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: screens[currentIndex],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (i) {
              context.read<MainLayoutCubit>().changeTab(i);
            },
            selectedItemColor: selectedColor,
            unselectedItemColor: Colors.grey,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
            showUnselectedLabels: true,
            items: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              return BottomNavigationBarItem(
                icon: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.only(top: 4),
                  child: Icon(
                    (item.icon as Icon).icon,
                    color: isSelected ? selectedColor : Colors.grey,
                    size: isSelected ? 28 : 24,
                  ),
                ),
                label: item.label,
              );
            }),
          ),
        );
      },
    );
  }
}
