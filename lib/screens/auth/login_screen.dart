import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF1A1A1A),
                    const Color(0xFF2D2D2D),
                    const Color(0xFF1A1A1A),
                  ]
                : [
                    const Color(0xFFFAF7F5),
                    const Color(0xFFF5EDE8),
                    const Color(0xFFFFFFFF),
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 2),
                
                // Logo and brand
                _buildBranding(context, size),
                
                const Spacer(flex: 2),
                
                // Sign in section
                _buildSignInSection(context),
                
                const Spacer(flex: 1),
                
                // Footer
                _buildFooter(context),
                
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBranding(BuildContext context, Size size) {
    return Column(
      children: [
        // Animated shopping bag icon
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_basket_rounded,
                size: 40,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
        
        const SizedBox(height: 32),
        
        // App name
        Text(
          'Family Shopping',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            letterSpacing: -0.5,
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Tagline
        Text(
          'Shop together, stay organized',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        
        const SizedBox(height: 48),
        
        // Feature highlights
        _buildFeatureRow(
          context,
          icon: Icons.sync_rounded,
          text: 'Real-time sync across devices',
        ),
        const SizedBox(height: 12),
        _buildFeatureRow(
          context,
          icon: Icons.group_rounded,
          text: 'Share lists with family members',
        ),
        const SizedBox(height: 12),
        _buildFeatureRow(
          context,
          icon: Icons.check_circle_rounded,
          text: 'Track what\'s bought or unavailable',
        ),
      ],
    );
  }

  Widget _buildFeatureRow(BuildContext context, {required IconData icon, required String text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 12),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildSignInSection(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return Column(
          children: [
            // Error message
            if (authProvider.error != null) ...[
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppTheme.notAvailableColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline_rounded,
                      color: AppTheme.notAvailableColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        authProvider.error!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.notAvailableColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: authProvider.clearError,
                      icon: const Icon(
                        Icons.close_rounded,
                        size: 18,
                        color: AppTheme.notAvailableColor,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
            
            // Google Sign-In button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () => authProvider.signInWithGoogle(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 2,
                  shadowColor: Colors.black.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: authProvider.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                        : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Google logo
                          Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CustomPaint(
                              painter: _GoogleLogoPainter(),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Continue with Google',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        Text(
          'By signing in, you agree to our',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                // TODO: Show terms of service
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Terms of Service'),
            ),
            Text(
              ' and ',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 12,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Show privacy policy
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Privacy Policy'),
            ),
          ],
        ),
      ],
    );
  }
}

// Custom painter for Google logo
class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = size.width / 2.5;

    // Blue arc (top-right)
    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 5
      ..strokeCap = StrokeCap.butt;
    
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      -0.8,
      1.8,
      false,
      bluePaint,
    );

    // Green arc (bottom-right)
    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 5
      ..strokeCap = StrokeCap.butt;
    
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      1.0,
      1.1,
      false,
      greenPaint,
    );

    // Yellow arc (bottom-left)
    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 5
      ..strokeCap = StrokeCap.butt;
    
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      2.1,
      1.0,
      false,
      yellowPaint,
    );

    // Red arc (top-left)
    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width / 5
      ..strokeCap = StrokeCap.butt;
    
    canvas.drawArc(
      Rect.fromCircle(center: Offset(centerX, centerY), radius: radius),
      3.1,
      1.0,
      false,
      redPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
