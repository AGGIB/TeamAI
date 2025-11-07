import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'home/home_dashboard.dart';
import 'ai_agent/ai_agent_screen.dart';
import 'calendar/calendar_screen.dart';
import 'team/team_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeDashboard(),
    const AIAgentScreen(),
    const CalendarScreen(),
    const TeamScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          selectedItemColor: const Color(0xFF4F9CF9),
          unselectedItemColor: const Color(0xFF9E9E9E),
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: _buildNavIcon('assets/bottomNav/Home.svg', 0),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon('assets/bottomNav/ai_agent.svg', 1),
              label: 'AI Agent',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon('assets/bottomNav/calendar.svg', 2),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: _buildIconWidget(Icons.groups, 3),
              label: 'Team',
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon('assets/bottomNav/user_account.svg', 4),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(String assetPath, int index) {
    final isSelected = _currentIndex == index;
    return Container(
      padding: const EdgeInsets.all(8),
      child: SvgPicture.asset(
        assetPath,
        width: 28,
        height: 28,
        colorFilter: ColorFilter.mode(
          isSelected ? const Color(0xFF4F9CF9) : const Color(0xFF9E9E9E),
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildIconWidget(IconData icon, int index) {
    final isSelected = _currentIndex == index;
    return Container(
      padding: const EdgeInsets.all(8),
      child: Icon(
        icon,
        size: 28,
        color: isSelected ? const Color(0xFF4F9CF9) : const Color(0xFF9E9E9E),
      ),
    );
  }
}
