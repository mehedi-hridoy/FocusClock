import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';
import '../../core/utils/watch_faces_manager.dart';
import '../../state/settings_provider.dart';
import 'fullscreen_clock_screen.dart';

/// Watch face selection screen
class WatchFaceSelectionScreen extends StatelessWidget {
  const WatchFaceSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Choose Watch Face',
          style: AppTextStyles.title(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SafeArea(
        child: Consumer<SettingsProvider>(
          builder: (context, settingsProvider, child) {
            final selectedWatchFaceId = settingsProvider.selectedWatchFace;

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: WatchFacesManager.allWatchFaces.length,
              itemBuilder: (context, index) {
                final watchFace = WatchFacesManager.allWatchFaces[index];
                final isSelected = watchFace.id == selectedWatchFaceId;

                return GestureDetector(
                  onTap: () async {
                    await settingsProvider.setSelectedWatchFace(watchFace.id);
                    if (context.mounted) {
                      // Navigate to fullscreen clock
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FullscreenClockScreen(),
                        ),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.buttonBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? watchFace.primaryColor
                            : AppColors.secondaryText.withOpacity(0.3),
                        width: isSelected ? 3 : 1.5,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: watchFace.primaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon
                        Icon(
                          watchFace.icon,
                          size: 48,
                          color: isSelected
                              ? watchFace.primaryColor
                              : AppColors.secondaryText,
                        ),
                        const SizedBox(height: 12),
                        // Name
                        Text(
                          watchFace.name,
                          style: AppTextStyles.buttonText(
                            fontSize: 16,
                            color: isSelected
                                ? watchFace.primaryColor
                                : AppColors.secondaryText,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        // Description
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            watchFace.description,
                            style: AppTextStyles.label(
                              fontSize: 11,
                              color: AppColors.secondaryText.withOpacity(0.7),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (isSelected) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: watchFace.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ACTIVE',
                              style: AppTextStyles.label(
                                fontSize: 10,
                                color: watchFace.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
