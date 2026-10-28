import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/index.dart';
import 'providers/app_provider.dart';
import 'screens/index.dart';
import 'widgets/common_widgets.dart';
import 'l10n/generated/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appProvider = AppProvider();
  await appProvider.initialize();
  runApp(LoanManagementApp(appProvider: appProvider));
}

class LoanManagementApp extends StatelessWidget {
  final AppProvider? appProvider;

  const LoanManagementApp({super.key, this.appProvider});

  @override
  Widget build(BuildContext context) {
    final provider = appProvider ?? AppProvider();
    return ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        title: 'Loan Management App',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales:  [
          Locale('en'), // English
          Locale('hi'), // Hindi
          Locale('ta'), // Tamil
          Locale('te'), // Telugu
          Locale('bn'), // Bengali
          Locale('mr'), // Marathi
          Locale('gu'), // Gujarati
          Locale('kn'), // Kannada
          Locale('ml'), // Malayalam
          Locale('pa'), // Punjabi
          Locale('or'), // Odia
          Locale('ur'), // Urdu
          Locale('as'), // Assamese
        ],
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1E3A8A),
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          textTheme: GoogleFonts.interTextTheme(),
          scaffoldBackgroundColor: Colors.white,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late AnimationController _opacityController;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: false);

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await _scaleController.forward();
    await _opacityController.forward();
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const LoginScreen(),
          transitionsBuilder: (_, animation, _, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360 || screenHeight < 640;
    
    final double logoSize = isSmallScreen ? 90 : 120;
    final double iconSize = isSmallScreen ? 45 : 60;
    final double titleFontSize = isSmallScreen ? 26 : 32;
    final double subtitleFontSize = isSmallScreen ? 14 : 16;
    final double progressWidth = screenWidth * 0.7;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1E3A8A),
              Color(0xFF3B82F6),
              Color(0xFF60A5FA),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _rotationController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotationController.value * 2 * 3.14159,
                    child: AnimatedBuilder(
                      animation: _scaleController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleController.value,
                          child: Container(
                            width: logoSize,
                            height: logoSize,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                  colors: [Colors.white, Color(0xFFE0E7FF)],
                              ),
                              borderRadius: BorderRadius.circular(logoSize * 0.25),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: logoSize * 0.25,
                                  offset: Offset(0, logoSize * 0.125),
                                ),
                                BoxShadow(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  blurRadius: logoSize * 0.08,
                                  offset: Offset(-logoSize * 0.04, -logoSize * 0.04),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                Icons.account_balance_rounded,
                                size: iconSize,
                                color: const Color(0xFF1E3A8A),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              )
                  .animate()
                  .scale(duration: 800.ms, curve: Curves.elasticOut)
                  .shimmer(duration: 2000.ms, color: Colors.white.withValues(alpha: 0.3)),

              SizedBox(height: isSmallScreen ? 24 : 32),

              AnimatedBuilder(
                animation: _opacityController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _opacityController.value,
                    child: Column(
                      children: [
                        Text(
                          'Loan Management',
                          style: GoogleFonts.inter(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3),

                        const SizedBox(height: 8),

                        Text(
                          'Smart Financial Solutions',
                          style: GoogleFonts.inter(
                            fontSize: subtitleFontSize,
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withValues(alpha: 0.9),
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.3),
                      ],
                    ),
                  );
                },
              ),

              SizedBox(height: isSmallScreen ? 40 : 60),

              SizedBox(
                width: progressWidth,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 6,
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 800.ms).slideX(begin: -0.5),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _mpinController = TextEditingController();

  bool _isMpinVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _mpinController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (_, _, _) => const MainNavigationScreen(),
              transitionsBuilder: (_, animation, _, child) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: animation,
                    curve: Curves.easeOutCubic,
                  )),
                  child: child,
                );
              },
              transitionDuration: const Duration(milliseconds: 600),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),

                  Text(
                    'Welcome Back',
                    style: GoogleFonts.inter(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1E3A8A),
                      letterSpacing: -0.5,
                    ),
                  ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

                  const SizedBox(height: 8),

                  Text(
                    'Sign in to access your loan dashboard',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideY(begin: -0.3),

                  const SizedBox(height: 48),

                  AppTextField(
                    controller: _nameController,
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    icon: Icons.person_outline_rounded,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                    delay: 100,
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _mobileController,
                    label: 'Mobile Number',
                    hint: 'Enter 10-digit mobile number',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    maxLength: 10,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      }
                      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
                        return 'Enter a valid 10-digit Indian mobile number';
                      }
                      return null;
                    },
                    delay: 200,
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _emailController,
                    label: 'Email ID',
                    hint: 'Enter your email address',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                    delay: 300,
                  ),

                  const SizedBox(height: 20),

                  AppTextField(
                    controller: _mpinController,
                    label: 'M-PIN (6 Digit)',
                    hint: 'Enter your 6-digit M-PIN',
                    icon: Icons.lock_outline_rounded,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    obscureText: !_isMpinVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isMpinVisible
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: Colors.grey[500],
                      ),
                      onPressed: () {
                        setState(() => _isMpinVisible = !_isMpinVisible);
                      },
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your M-PIN';
                      }
                      if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                        return 'M-PIN must be exactly 6 digits';
                      }
                      return null;
                    },
                    delay: 400,
                  ),

                  const SizedBox(height: 32),

                  AppButton(
                    text: 'Sign In',
                    onPressed: _isLoading ? null : _handleLogin,
                    isLoading: _isLoading,
                  ).animate().fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.3),

                  const SizedBox(height: 24),

                  Center(
                    child: Text(
                      'By signing in, you agree to our Terms of Service and Privacy Policy',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[500],
                        height: 1.5,
                      ),
                    ),
                  ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const CustomersListScreen(),
    const LoansListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.people_rounded, 'Customers', 1),
              _buildNavItem(Icons.credit_card_rounded, 'Loans', 2),
              _buildNavItem(Icons.person_rounded, 'Profile', 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;
    return InkWell(
      onTap: () => setState(() => _currentIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? const Color(0xFF1E3A8A) : Colors.grey[400],
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? const Color(0xFF1E3A8A) : Colors.grey[400],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _staggerController;
  bool _showBackupPrompt = false;

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();
    _checkBackupPrompt();
  }

  Future<void> _checkBackupPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenBackupPrompt = prefs.getBool('has_seen_backup_prompt') ?? false;
    if (!hasSeenBackupPrompt && mounted) {
      setState(() => _showBackupPrompt = true);
    }
  }

  Future<void> _dismissBackupPrompt() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_backup_prompt', true);
    if (mounted) {
      setState(() => _showBackupPrompt = false);
    }
  }

  @override
  void dispose() {
    _staggerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final lender = provider.lender;
    final activeLoans = provider.loans.where((l) => l.status == 'active').length;
    final completedLoans = provider.loans.where((l) => l.status == 'completed').length;
    final totalLoanAmount = provider.loans.fold(0.0, (sum, l) => sum + l.totalAmount);
    
    final pendingEMIs = provider.emis.where((e) => e.status == EMIStatus.pending).toList();
    final overdueEMIs = pendingEMIs.where((e) => e.isOverdue).toList();
    final totalEMIDue = pendingEMIs.fold(0.0, (sum, e) => sum + e.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: const Color(0xFF1E3A8A),
                leading: IconButton(
                  icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
                  onPressed: () => _showSettingsSheet(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF1E3A8A),
                          Color(0xFF3B82F6),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _getGreeting(),
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withValues(alpha: 0.8),
                                      ),
                                    ),
                                    Text(
                                      lender?.name ?? 'Welcome',
                                      style: GoogleFonts.inter(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.2),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Loan Overview',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),
                          TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                            label: Text('View All', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                            style: TextButton.styleFrom(foregroundColor: const Color(0xFF1E3A8A)),
                          ),
                        ],
                      ).animate(controller: _staggerController).fadeIn(duration: 600.ms).slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: 'Total Loans',
                              value: 'Rs.${_formatCurrency(totalLoanAmount)}',
                              subtitle: 'Active: $activeLoans | Closed: $completedLoans',
                              icon: Icons.account_balance_wallet_rounded,
                              color: const Color(0xFF1E3A8A),
                              delay: 0,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: StatCard(
                              title: 'EMI Due',
                              value: 'Rs.${_formatCurrency(totalEMIDue)}',
                              subtitle: '${pendingEMIs.length} Pending${overdueEMIs.isNotEmpty ? ' \u2022 ${overdueEMIs.length} Overdue' : ''}',
                              icon: Icons.calendar_today_rounded,
                              color: overdueEMIs.isNotEmpty ? const Color(0xFFDC2626) : const Color(0xFFDC2626),
                              delay: 100,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: StatCard(
                              title: 'Total Customers',
                              value: provider.customers.length.toString(),
                              subtitle: 'Registered',
                              icon: Icons.people_rounded,
                              color: const Color(0xFF7C3AED),
                              delay: 200,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AllPDFsScreen()),
                              ),
                              borderRadius: BorderRadius.circular(20),
                              child: StatCard(
                                title: 'Documents',
                                value: provider.documents.length.toString(),
                                subtitle: 'Generated',
                                icon: Icons.picture_as_pdf_rounded,
                                color: const Color(0xFF059669),
                                delay: 300,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              text: 'Create Loan',
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const CreateLoanScreen()),
                              ),
                              backgroundColor: const Color(0xFF1E3A8A),
                              icon: Icons.add_circle_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              text: 'View All PDFs',
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const AllPDFsScreen()),
                              ),
                              backgroundColor: const Color(0xFF7C3AED),
                              icon: Icons.picture_as_pdf_rounded,
                            ),
                          ),
                        ],
                      ).animate(controller: _staggerController).fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.2),

                      const SizedBox(height: 32),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recent Loans',
                            style: GoogleFonts.inter(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text('View All', style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: const Color(0xFF1E3A8A))),
                          ),
                        ],
                      ).animate(controller: _staggerController).fadeIn(duration: 600.ms, delay: 500.ms).slideY(begin: 0.2),

                      const SizedBox(height: 16),

                      if (provider.loans.isEmpty)
                        EmptyState(
                          icon: Icons.account_balance_wallet_outlined,
                          title: 'No Loans Created Yet',
                          subtitle: 'Create your first loan from the Loans tab',
                          action: AppButton(
                            text: 'Create Loan',
                            onPressed: () {},
                            backgroundColor: const Color(0xFF1E3A8A),
                            width: 200,
                          ),
                        ).animate(controller: _staggerController).fadeIn(duration: 600.ms, delay: 500.ms)
                      else
                        Column(
                          children: provider.loans.take(3).map((loan) {
                            final index = provider.loans.indexOf(loan);
                            final customer = provider.getCustomerById(loan.customerId);
                            final emis = provider.getEMIsByLoan(loan.id);
                            final paidCount = emis.where((e) => e.status == EMIStatus.paid).length;
                            final progress = loan.tenureMonths > 0 ? paidCount / loan.tenureMonths : 0.0;
                            
                            return _buildDashboardLoanCard(
                              loan: loan,
                              customer: customer,
                              progress: progress,
                              color: _getLoanColor(index),
                              delay: 500 + (index * 100),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
          // Backup Prompt Overlay
          if (_showBackupPrompt)
            Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: Center(
                child: Container(
                  margin: const EdgeInsets.all(24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E3A8A).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cloud_upload_rounded, size: 48, color: Color(0xFF1E3A8A)),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Backup Your Data',
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E3A8A),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Secure your loan data by backing it up to Google Drive. You can restore it anytime, even after reinstalling the app.',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _dismissBackupPrompt,
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                side: BorderSide(color: Colors.grey[300]!),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Text(
                                'Later',
                                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                _dismissBackupPrompt();
                                _showSettingsSheet(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF1E3A8A),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Text(
                                'Backup Now',
                                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().scale(duration: 300.ms, curve: Curves.elasticOut),
              ),
            ),
        ],
      ),
    );
  }

  void _showSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SettingsScreen(
            onClose: () => Navigator.pop(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardLoanCard({
    required Loan loan,
    required Customer? customer,
    required double progress,
    required Color color,
    required int delay,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.account_balance_wallet_rounded,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Loan #${loan.id.substring(0, 8).toUpperCase()}',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E3A8A),
                      ),
                    ),
                    Text(
                      customer?.name ?? 'Unknown Customer',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: loan.status == 'active' 
                      ? const Color(0xFF059669).withValues(alpha: 0.1)
                      : Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  loan.status.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: loan.status == 'active' ? const Color(0xFF059669) : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: _buildInfoItem('Loan Amount', 'Rs.${_formatCurrency(loan.principalAmount)}'),
              ),
              Container(height: 40, width: 1, color: Colors.grey[200]),
              Expanded(
                child: _buildInfoItem('Monthly EMI', 'Rs.${_formatCurrency(loan.monthlyEMI)}'),
              ),
              Container(height: 40, width: 1, color: Colors.grey[200]),
              Expanded(
                child: _buildInfoItem('Interest Rate', '${loan.interestRate}% ${loan.interestType.name}'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Repayment Progress',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  Text(
                    '${(progress * 100).toInt()}% completed',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1500),
                    curve: Curves.easeOutCubic,
                    height: 8,
                    width: MediaQuery.of(context).size.width * 0.75 * progress,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color, color.withValues(alpha: 0.7)],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${loan.tenureMonths} months tenure \u2022 ${loan.interestType.name} interest',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate(controller: _staggerController).fadeIn(duration: 600.ms, delay: delay.ms).slideY(begin: 0.2);
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1E3A8A),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  String _formatCurrency(double amount) {
    if (amount >= 10000000) {
      return '${(amount / 10000000).toStringAsFixed(1)} Cr';
    } else if (amount >= 100000) {
      return '${(amount / 100000).toStringAsFixed(1)} L';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)} K';
    }
    return amount.toStringAsFixed(0);
  }

  Color _getLoanColor(int index) {
    final colors = [
      const Color(0xFF1E3A8A),
      const Color(0xFF7C3AED),
      const Color(0xFF059669),
      const Color(0xFFDC2626),
      const Color(0xFFEA580C),
    ];
    return colors[index % colors.length];
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _mobileController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _licenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadLenderData();
  }

  void _loadLenderData() {
    final provider = context.read<AppProvider>();
    final lender = provider.lender;
    if (lender != null) {
      _nameController.text = lender.name;
      _mobileController.text = lender.mobileNumber;
      _emailController.text = lender.email;
      _addressController.text = lender.address;
      _licenseController.text = lender.licenseNumber;
    }
  }

  Future<void> _saveProfile() async {
    final provider = context.read<AppProvider>();
    final lender = Lender(
      id: provider.lender?.id,
      name: _nameController.text.trim(),
      mobileNumber: _mobileController.text.trim(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      licenseNumber: _licenseController.text.trim(),
      createdAt: provider.lender?.createdAt,
    );
    await provider.updateLender(lender);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile updated successfully!', style: GoogleFonts.inter()),
          backgroundColor: const Color(0xFF059669),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _licenseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final lender = provider.lender;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text('Profile', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Header
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Icon(Icons.person_rounded, size: 40, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lender?.name ?? 'Lender',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              lender?.licenseNumber ?? 'License: LM-2024-001',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3),

                const SizedBox(height: 32),

                Text(
                  'Lender Details',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E3A8A),
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 100.ms).slideX(begin: -0.3),

                const SizedBox(height: 20),

                AppCard(
                  child: Column(
                    children: [
                      AppTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        icon: Icons.person_outline_rounded,
                        delay: 100,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: _mobileController,
                        label: 'Mobile Number',
                        hint: 'Enter 10-digit mobile number',
                        icon: Icons.phone_outlined,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        delay: 200,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: _emailController,
                        label: 'Email ID',
                        hint: 'Enter your email address',
                        icon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        delay: 300,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: _addressController,
                        label: 'Office Address',
                        hint: 'Enter your office address',
                        icon: Icons.location_on_outlined,
                        delay: 400,
                      ),
                      const SizedBox(height: 20),
                      AppTextField(
                        controller: _licenseController,
                        label: 'License Number',
                        hint: 'Enter your license number',
                        icon: Icons.badge_rounded,
                        delay: 500,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideY(begin: 0.2),

                const SizedBox(height: 32),

                AppButton(
                  text: 'Save Changes',
                  onPressed: _saveProfile,
                  icon: Icons.save_rounded,
                ).animate().fadeIn(duration: 600.ms, delay: 600.ms).slideY(begin: 0.3),

                const SizedBox(height: 40),

                // Stats
                Text(
                  'Statistics',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1E3A8A),
                  ),
                ).animate().fadeIn(duration: 600.ms, delay: 700.ms).slideX(begin: -0.3),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total Customers',
                        value: provider.customers.length.toString(),
                        subtitle: 'Registered',
                        icon: Icons.people_rounded,
                        color: const Color(0xFF1E3A8A),
                        delay: 800,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Total Loans',
                        value: provider.loans.length.toString(),
                        subtitle: 'Created',
                        icon: Icons.credit_card_rounded,
                        color: const Color(0xFF7C3AED),
                        delay: 900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Active Loans',
                        value: provider.loans.where((l) => l.status == 'active').length.toString(),
                        subtitle: 'In Progress',
                        icon: Icons.trending_up_rounded,
                        color: const Color(0xFF059669),
                        delay: 1000,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: StatCard(
                        title: 'Documents',
                        value: provider.documents.length.toString(),
                        subtitle: 'Generated',
                        icon: Icons.picture_as_pdf_rounded,
                        color: Colors.orange,
                        delay: 1100,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}