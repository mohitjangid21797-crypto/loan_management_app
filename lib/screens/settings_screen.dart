import 'package:flutter/material.dart' hide Text;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../providers/app_theme_provider.dart';
import '../screens/language_selection_screen.dart';
import '../services/backup_service.dart';
import '../widgets/common_widgets.dart';
import '../widgets/localized_text.dart';

class SettingsScreen extends StatefulWidget {
  final VoidCallback? onClose;

  const SettingsScreen({super.key, this.onClose});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final BackupService _backupService = BackupService();
  bool _isBackingUp = false;
  bool _isRestoring = false;
  bool _isSignedIn = false;
  String? _signedInEmail;
  List<Map<String, dynamic>> _backups = [];

  @override
  void initState() {
    super.initState();
    _checkSignInStatus();
  }

  Future<void> _checkSignInStatus() async {
    _isSignedIn = _backupService.isSignedIn;
    _signedInEmail = _backupService.currentUser?.email;
    if (_isSignedIn) {
      _loadBackups();
    }
    if (mounted) setState(() {});
  }

  Future<void> _loadBackups() async {
    final backups = await _backupService.listBackups();
    if (mounted) {
      setState(() => _backups = backups);
    }
  }

  Future<void> _signInAndBackup() async {
    final signedIn = await _backupService.signIn();
    if (!signedIn) {
      if (mounted) {
        _showSnackBar(
          _signInFailureMessage,
          isError: true,
        );
      }
      return;
    }

    if (mounted) {
      _showBackupPasswordDialog(isBackup: true);
    }
  }

  Future<void> _signInAndRestore() async {
    final signedIn = await _backupService.signIn();
    if (!signedIn) {
      if (mounted) {
        _showSnackBar(
          _signInFailureMessage,
          isError: true,
        );
      }
      return;
    }

    if (mounted) {
      _showBackupPasswordDialog(isBackup: false);
    }
  }

  String get _signInFailureMessage {
    final error = _backupService.lastSignInError;
    if (error == null || error.isEmpty) {
      return 'Google sign-in failed. Check your Google account and OAuth configuration.';
    }
    return 'Google sign-in failed: $error';
  }

  void _showBackupPasswordDialog({required bool isBackup}) {
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    bool showPassword = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            isBackup ? 'Set Backup Password' : 'Enter Backup Password',
            style: GoogleFonts.inter(fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isBackup) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.orange.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: Colors.orange,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'IMPORTANT: This password encrypts your backup. If you forget it, your data CANNOT be recovered. Google cannot help. Write it down and store it safely.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.orange[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Backup Password',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      hintText: localizedUiText(
                        context,
                        'Enter a strong password',
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setDialogState(() => showPassword = !showPassword),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Confirm Password',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      hintText: localizedUiText(context, 'Re-enter password'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Enter the password you used when creating this backup.',
                    style: GoogleFonts.inter(),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: passwordController,
                    obscureText: !showPassword,
                    decoration: InputDecoration(
                      hintText: localizedUiText(context, 'Backup password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          showPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () =>
                            setDialogState(() => showPassword = !showPassword),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: GoogleFonts.inter(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (isBackup) {
                  if (passwordController.text.isEmpty) {
                    _showSnackBar('Please enter a password', isError: true);
                    return;
                  }
                  if (passwordController.text != confirmController.text) {
                    _showSnackBar('Passwords do not match', isError: true);
                    return;
                  }
                  if (passwordController.text.length < 8) {
                    _showSnackBar(
                      'Password must be at least 8 characters',
                      isError: true,
                    );
                    return;
                  }
                }

                Navigator.pop(dialogContext);
                if (isBackup) {
                  await _performBackup(passwordController.text);
                } else {
                  await _performRestore(passwordController.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isBackup
                    ? const Color(0xFF1E3A8A)
                    : const Color(0xFF059669),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                isBackup ? 'Create Backup' : 'Restore',
                style: GoogleFonts.inter(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performBackup(String password) async {
    setState(() => _isBackingUp = true);

    final provider = context.read<AppProvider>();
    final success = await _backupService.backup(provider, password);

    if (mounted) {
      setState(() {
        _isBackingUp = false;
        _isSignedIn = true;
        _signedInEmail = _backupService.currentUser?.email;
      });
      _loadBackups();

      if (success) {
        _showSnackBar(
          'Backup completed successfully! Encrypted and stored in Google Drive app data.',
        );
      } else {
        _showSnackBar('Backup failed', isError: true);
      }
    }
  }

  Future<void> _performRestore(String password) async {
    final provider = context.read<AppProvider>();
    setState(() => _isRestoring = true);

    final decryptedData = await _backupService.restore(password);

    if (decryptedData == null) {
      if (mounted) {
        setState(() => _isRestoring = false);
        _showSnackBar('Invalid password or no backup found', isError: true);
      }
      return;
    }

    final success = await _backupService.restoreBackup(provider, decryptedData);

    if (mounted) {
      setState(() => _isRestoring = false);
      if (success) {
        _showSnackBar('Data restored successfully! Please set a new M-PIN.');
        widget.onClose?.call();
      } else {
        _showSnackBar('Restore failed - data may be corrupted', isError: true);
      }
    }
  }

  Future<void> _signOut() async {
    await _backupService.signOut();
    setState(() {
      _isSignedIn = false;
      _signedInEmail = null;
      _backups = [];
    });
    _showSnackBar('Signed out from Google Drive');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: GoogleFonts.inter()),
        backgroundColor: isError ? Colors.red : const Color(0xFF059669),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<AppThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.inter(fontWeight: FontWeight.w600),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: widget.onClose != null
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: widget.onClose,
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () => Navigator.pop(context),
              ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(
                  'Encrypted Backup',
                  Icons.lock_outline_rounded,
                ),
                const SizedBox(height: 16),

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: _isSignedIn
                                  ? const Color(0xFF059669)
                                        .withValues(alpha: 0.1)
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              _isSignedIn
                                  ? Icons.cloud_done_rounded
                                  : Icons.cloud_off_rounded,
                              color: _isSignedIn
                                  ? const Color(0xFF059669)
                                  : Colors.grey[500],
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _isSignedIn
                                      ? 'Connected to Google Drive'
                                      : 'Not Connected',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: _isSignedIn
                                        ? const Color(0xFF059669)
                                        : const Color(0xFF1E3A8A),
                                  ),
                                ),
                                if (_isSignedIn) ...[
                                  const SizedBox(height: 4),
                                  Text(
                                    _signedInEmail ?? '',
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      if (!_isSignedIn) ...[
                        AppButton(
                          text: 'Connect & Backup',
                          onPressed: _isBackingUp ? null : _signInAndBackup,
                          isLoading: _isBackingUp,
                          icon: Icons.cloud_upload_rounded,
                          backgroundColor: const Color(0xFF1E3A8A),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Sign in with your Google account to create an encrypted backup. Your data is encrypted on your device with AES-256-GCM before upload. Google never sees your unencrypted data.',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ] else ...[
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isNarrow = constraints.maxWidth < 360;
                            if (isNarrow) {
                              return Column(
                                children: [
                                  AppButton(
                                    text: 'Backup Now',
                                    onPressed: _isBackingUp
                                        ? null
                                        : _signInAndBackup,
                                    isLoading: _isBackingUp,
                                    icon: Icons.cloud_upload_rounded,
                                    backgroundColor: const Color(0xFF1E3A8A),
                                  ),
                                  const SizedBox(height: 12),
                                  OutlinedButton.icon(
                                    onPressed: _isRestoring ? null : _signOut,
                                    icon: const Icon(
                                      Icons.logout_rounded,
                                      size: 18,
                                    ),
                                    label: Text(
                                      'Sign Out',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return Row(
                              children: [
                                Expanded(
                                  child: AppButton(
                                    text: 'Backup Now',
                                    onPressed: _isBackingUp
                                        ? null
                                        : _signInAndBackup,
                                    isLoading: _isBackingUp,
                                    icon: Icons.cloud_upload_rounded,
                                    backgroundColor: const Color(0xFF1E3A8A),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: _isRestoring ? null : _signOut,
                                    icon: const Icon(
                                      Icons.logout_rounded,
                                      size: 18,
                                    ),
                                    label: Text(
                                      'Sign Out',
                                      style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        if (_backups.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            'Recent Backups (max 5 kept)',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),
                          const SizedBox(height: 12),
                          ..._backups
                              .take(5)
                              .map((backup) => _buildBackupItem(backup)),
                        ],
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _buildSectionHeader(
                  'Encrypted Restore',
                  Icons.lock_reset_rounded,
                ),
                const SizedBox(height: 16),

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.lock_reset_rounded,
                          color: Color(0xFF1E3A8A),
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Restore from Encrypted Backup',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in with the same Google account. You will need the backup password you set during backup. After restore, you must set a new M-PIN (M-PIN is not stored in backups for security).',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 20),
                      AppButton(
                        text: 'Restore Data',
                        onPressed: _isRestoring ? null : _signInAndRestore,
                        isLoading: _isRestoring,
                        icon: Icons.cloud_download_rounded,
                        backgroundColor: const Color(0xFF059669),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _buildSectionHeader('Appearance', Icons.palette_outlined),
                const SizedBox(height: 16),

                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'App Theme',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SegmentedButton<ThemeMode>(
                        segments: const [
                          ButtonSegment(
                            value: ThemeMode.light,
                            icon: Icon(Icons.light_mode_outlined),
                            label: Text('Light'),
                          ),
                          ButtonSegment(
                            value: ThemeMode.dark,
                            icon: Icon(Icons.dark_mode_outlined),
                            label: Text('Dark'),
                          ),
                        ],
                        selected: {themeProvider.themeMode},
                        onSelectionChanged: (selection) =>
                            _setThemeMode(selection.first),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                _buildSectionHeader('Language', Icons.language_rounded),
                const SizedBox(height: 16),

                AppCard(
                  child: Column(
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Icons.language_rounded,
                            color: colorScheme.primary,
                            size: 24,
                          ),
                        ),
                        title: Text(
                          'App Language',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        subtitle: Text(
                          'Choose your preferred language',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.grey,
                        ),
                        onTap: () async {
                          final selectedLanguage = await Navigator.push<String>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LanguageSelectionScreen(),
                            ),
                          );
                          if (selectedLanguage != null && mounted) {
                            setState(() {});
                            _showSnackBar(
                              'Language updated to ${_getLanguageName(selectedLanguage)}',
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    try {
      await context.read<AppThemeProvider>().setThemeMode(mode);
    } catch (error) {
      if (mounted) {
        _showSnackBar('Could not change app theme: $error', isError: true);
      }
    }
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 500.ms).slideX(begin: -0.3);
  }

  Widget _buildBackupItem(Map<String, dynamic> backup) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.lock_rounded, color: colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  backup['name'] ?? 'Backup',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  '${localizedUiText(context, 'Date')}: ${_formatDate(backup['createdTime'])}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            _formatSize(backup['size']),
            style: GoogleFonts.inter(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.2);
  }

  String _formatDate(String? dateString) {
    if (dateString == null) return 'Unknown';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return 'Unknown';
    }
  }

  String _formatSize(int? bytes) {
    if (bytes == null) return 'Unknown';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getLanguageName(String code) {
    const Map<String, Map<String, String>> languages = {
      'en': {'name': 'English'},
      'hi': {'name': 'Hindi'},
      'ta': {'name': 'Tamil'},
      'te': {'name': 'Telugu'},
      'bn': {'name': 'Bengali'},
      'mr': {'name': 'Marathi'},
      'gu': {'name': 'Gujarati'},
      'kn': {'name': 'Kannada'},
      'ml': {'name': 'Malayalam'},
      'pa': {'name': 'Punjabi'},
      'or': {'name': 'Odia'},
      'ur': {'name': 'Urdu'},
      'as': {'name': 'Assamese'},
      'ne': {'name': 'Nepali'},
    };
    return languages[code]?['name'] ?? code;
  }
}
