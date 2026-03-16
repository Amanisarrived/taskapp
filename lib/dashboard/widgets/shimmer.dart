import 'package:flutter/material.dart';

class ShimmerLoader extends StatefulWidget {
  const ShimmerLoader({super.key});

  @override
  State<ShimmerLoader> createState() => _ShimmerLoaderState();
}

class _ShimmerLoaderState extends State<ShimmerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(
      begin: -1.5,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _anim,
      builder: (context, _) {
        return CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          slivers: [
            // fake header shimmer
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            const Color(0xFF1E293B),
                            const Color(0xFF334155),
                            const Color(0xFF1E293B),
                          ]
                        : [
                            const Color(0xFFE2E8F0),
                            const Color(0xFFF1F5F9),
                            const Color(0xFFE2E8F0),
                          ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment(_anim.value - 1, 0),
                    end: Alignment(_anim.value + 1, 0),
                  ),
                ),
              ),
            ),

            // fake section label
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
              sliver: SliverToBoxAdapter(
                child: _ShimmerBox(
                  width: 80,
                  height: 12,
                  anim: _anim,
                  isDark: isDark,
                ),
              ),
            ),

            // fake task tiles
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _ShimmerTile(anim: _anim, isDark: isDark),
                  ),
                  childCount: 5,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _ShimmerTile extends StatelessWidget {
  final Animation<double> anim;
  final bool isDark;

  const _ShimmerTile({required this.anim, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF1E293B),
                  const Color(0xFF334155),
                  const Color(0xFF1E293B),
                ]
              : [
                  const Color(0xFFE2E8F0),
                  const Color(0xFFF1F5F9),
                  const Color(0xFFE2E8F0),
                ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment(anim.value - 1, 0),
          end: Alignment(anim.value + 1, 0),
        ),
      ),
      child: Row(
        children: [
          _ShimmerBox(
            width: 24,
            height: 24,
            anim: anim,
            isDark: isDark,
            radius: 6,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ShimmerBox(
                  width: double.infinity,
                  height: 14,
                  anim: anim,
                  isDark: isDark,
                ),
                const SizedBox(height: 8),
                _ShimmerBox(width: 100, height: 10, anim: anim, isDark: isDark),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final Animation<double> anim;
  final bool isDark;
  final double radius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.anim,
    required this.isDark,
    this.radius = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradient(
          colors: isDark
              ? [
                  const Color(0xFF334155),
                  const Color(0xFF475569),
                  const Color(0xFF334155),
                ]
              : [
                  const Color(0xFFCBD5E1),
                  const Color(0xFFE2E8F0),
                  const Color(0xFFCBD5E1),
                ],
          stops: const [0.0, 0.5, 1.0],
          begin: Alignment(anim.value - 1, 0),
          end: Alignment(anim.value + 1, 0),
        ),
      ),
    );
  }
}
