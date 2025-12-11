import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimens.dart';
import '../../../../core/theme/app_typography.dart';

/// Login Screen - The Portal
/// Goal: Reduce friction. Entry must be instantaneous.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOut),
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundSecondary,
              AppColors.backgroundPrimary,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.spaceLg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      // Logo/Brand
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentPrimary,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentPrimary.withOpacity(0.3),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.architecture,
                          size: 60,
                          color: AppColors.accentPrimary,
                        ),
                      ),
                      const SizedBox(height: AppDimens.spaceLg),
                      Text(
                        'ARCHITECT NEXUS',
                        style: AppTypography.h1.copyWith(
                          color: AppColors.accentPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimens.spaceSm),
                      Text(
                        'Flow State Learning',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: AppDimens.spaceXxl),
                
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // GitHub Sign In
                        _AuthButton(
                          icon: Icons.code,
                          label: 'Continue with GitHub',
                          backgroundColor: AppColors.backgroundSecondary,
                          foregroundColor: AppColors.textPrimary,
                          borderColor: AppColors.accentPrimary,
                          onPressed: () {
                            // TODO: Implement GitHub OAuth
                          },
                        ),
                        
                        const SizedBox(height: AppDimens.spaceMd),
                        
                        // Google Sign In
                        _AuthButton(
                          icon: Icons.g_mobiledata,
                          label: 'Continue with Google',
                          backgroundColor: AppColors.backgroundSecondary,
                          foregroundColor: AppColors.textPrimary,
                          borderColor: AppColors.accentSecondary,
                          onPressed: () {
                            // TODO: Implement Google OAuth
                          },
                        ),
                        
                        const SizedBox(height: AppDimens.spaceMd),
                        
                        // Email Sign In
                        _AuthButton(
                          icon: Icons.email_outlined,
                          label: 'Continue with Email',
                          backgroundColor: AppColors.accentPrimary,
                          foregroundColor: AppColors.backgroundPrimary,
                          onPressed: () {
                            // TODO: Navigate to email sign in
                          },
                        ),
                        
                        const SizedBox(height: AppDimens.spaceXl),
                        
                        Text(
                          'By continuing, you agree to our Terms of Service',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
  final VoidCallback onPressed;

  const _AuthButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    this.borderColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.spaceLg,
          vertical: AppDimens.spaceMd,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusMd),
          side: borderColor != null
              ? BorderSide(color: borderColor!, width: 2)
              : BorderSide.none,
        ),
        elevation: 0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppDimens.iconMd),
          const SizedBox(width: AppDimens.spaceMd),
          Text(
            label,
            style: AppTypography.button,
          ),
        ],
      ),
    );
  }
}
