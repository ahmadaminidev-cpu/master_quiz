import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ShimmerEffect extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerEffect({
    super.key,
    required this.child,
    this.isLoading = true,
  });

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.surface,
                AppColors.primary.withOpacity(0.15),
                AppColors.surface,
              ],
              stops: [
                0.0,
                _controller.value,
                1.0,
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const SkeletonBox({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Header Skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const SkeletonBox(width: 52, height: 52, borderRadius: 26),
                    const SizedBox(width: 14),
                    const SkeletonBox(width: 120, height: 20),
                  ],
                ),
                const SkeletonBox(width: 30, height: 30, borderRadius: 15),
              ],
            ),
            const SizedBox(height: 32),
            // Daily Task Skeleton
            const SkeletonBox(height: 160, borderRadius: 30),
            const SizedBox(height: 36),
            // Categories Title
            const SkeletonBox(width: 150, height: 24),
            const SizedBox(height: 16),
            // Categories Horizontal
            Row(
              children: List.generate(
                4,
                (index) => const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    children: [
                      SkeletonBox(width: 68, height: 68, borderRadius: 22),
                      const SizedBox(height: 10),
                      SkeletonBox(width: 50, height: 12),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 36),
            // Games Title
            const SkeletonBox(width: 120, height: 24),
            const SizedBox(height: 16),
            // Games Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20,
              childAspectRatio: 0.85,
              children: List.generate(
                4,
                (index) => const SkeletonBox(height: 200, borderRadius: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressSkeleton extends StatelessWidget {
  const ProgressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const Align(
              alignment: Alignment.centerRight,
              child: SkeletonBox(width: 30, height: 30, borderRadius: 15),
            ),
            const SizedBox(height: 20),
            // Circle Progress
            const SkeletonBox(width: 160, height: 160, borderRadius: 80),
            const SizedBox(height: 24),
            const SkeletonBox(width: 180, height: 28),
            const SizedBox(height: 8),
            const SkeletonBox(width: 140, height: 16),
            const SizedBox(height: 40),
            // Milestones
            const Align(
              alignment: Alignment.centerLeft,
              child: SkeletonBox(width: 150, height: 24),
            ),
            const SizedBox(height: 16),
            ...List.generate(
              3,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: SkeletonBox(height: 100, borderRadius: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
