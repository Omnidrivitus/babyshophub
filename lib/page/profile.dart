import 'package:babyshophub/data/repository/auth_repository.dart';
import 'package:babyshophub/data/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  static const String routeName = 'Profile';
  static const String routePath = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PreferencesRepository _preferencesRepository = PreferencesRepository();
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  String _errorMessage = '';

  String _token = '';
  String _userId = '';
  String _name = '';
  String _email = '';
  String _role = '';

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final Map<String, dynamic> profileResponse = await _apiService
          .getMyProfile();

      final Map<String, dynamic> profileData =
          profileResponse['data'] is Map<String, dynamic>
          ? profileResponse['data'] as Map<String, dynamic>
          : profileResponse;

      if (!mounted) return;

      setState(() {
        _userId = (profileData['id'] ?? '').toString();
        _name = (profileData['name'] ?? '').toString();
        _email = (profileData['email'] ?? '').toString();
        _role = (profileData['role'] ?? '').toString();
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _token = _preferencesRepository.getToken() ?? '';
        _isLoading = false;
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _logout() async {
    await _preferencesRepository.clearToken();
    if (!mounted) return;

    setState(() {
      _token = '';
      _userId = '';
      _name = '';
      _email = '';
      _role = '';
    });

    context.go('/login');

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Logged out successfully.')));
  }

  String get _displayUserId => _userId.trim().isEmpty ? 'N/A' : _userId.trim();
  String get _displayName => _name.trim().isEmpty ? 'User' : _name.trim();
  String get _displayEmail => _email.trim().isEmpty ? 'N/A' : _email.trim();
  String get _displayRole => _role.trim().isEmpty ? 'N/A' : _role.trim();
  bool get _isLoggedIn => _token.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const Color accentColor = Color.fromARGB(255, 31, 31, 31);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.surfaceContainerLowest,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Profile'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfileData,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _ProfileHeaderCard(
                    name: _displayName,
                    email: _displayEmail,
                    accent: accentColor,
                  ),
                  const SizedBox(height: 14),
                  if (_errorMessage.isNotEmpty) ...[
                    _ErrorBanner(message: _errorMessage),
                    const SizedBox(height: 14),
                  ],
                  _SectionTitle(
                    title: 'Account Details',
                    icon: Icons.badge_outlined,
                    color: accentColor,
                  ),
                  const SizedBox(height: 8),
                  _InfoCard(
                    children: [
                      _InfoRow(
                        label: 'User ID',
                        value: _displayUserId,
                        icon: Icons.perm_identity_outlined,
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        label: 'Name',
                        value: _displayName,
                        icon: Icons.person_outline,
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        label: 'Email',
                        value: _displayEmail,
                        icon: Icons.email_outlined,
                      ),
                      const Divider(height: 20),
                      _InfoRow(
                        label: 'Role',
                        value: _displayRole,
                        icon: Icons.admin_panel_settings_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const SizedBox(height: 8),
                  _InfoCard(
                    children: [
                      _InfoRow(
                        label: 'Login Status',
                        value: _isLoggedIn ? 'Authenticated' : 'Not logged in',
                        icon: _isLoggedIn
                            ? Icons.verified_user_outlined
                            : Icons.error_outline,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: _loadProfileData,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh Profile'),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _isLoggedIn ? _logout : null,
                      icon: const Icon(Icons.logout),
                      label: const Text('Log Out'),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: colorScheme.onErrorContainer),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  const _ProfileHeaderCard({
    required this.name,
    required this.email,
    required this.accent,
  });

  final String name;
  final String email;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [accent, const Color(0xFF8D9BFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, size: 34, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(email, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.8,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(children: children),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.black54),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
