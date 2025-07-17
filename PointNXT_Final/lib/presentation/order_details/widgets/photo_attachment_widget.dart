import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoAttachmentWidget extends StatefulWidget {
  final List<String> photos;
  final VoidCallback onPhotosChanged;

  const PhotoAttachmentWidget({
    super.key,
    required this.photos,
    required this.onPhotosChanged,
  });

  @override
  State<PhotoAttachmentWidget> createState() => _PhotoAttachmentWidgetState();
}

class _PhotoAttachmentWidgetState extends State<PhotoAttachmentWidget> {
  late List<String> _photos;

  @override
  void initState() {
    super.initState();
    _photos = List.from(widget.photos);
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
            decoration: BoxDecoration(
                color: AppTheme.lightTheme.cardColor,
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16))),
            child: SafeArea(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(2))),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'camera_alt',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24),
                  title: Text('Take Photo',
                      style: AppTheme.lightTheme.textTheme.bodyLarge),
                  onTap: () {
                    Navigator.pop(context);
                    _takePhoto();
                  }),
              ListTile(
                  leading: CustomIconWidget(
                      iconName: 'photo_library',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 24),
                  title: Text('Choose from Gallery',
                      style: AppTheme.lightTheme.textTheme.bodyLarge),
                  onTap: () {
                    Navigator.pop(context);
                    _chooseFromGallery();
                  }),
              SizedBox(height: 16),
            ]))));
  }

  void _takePhoto() {
    HapticFeedback.lightImpact();

    // Simulate adding a new photo
    final String newPhotoUrl =
        "https://images.unsplash.com/photo-1586953208448-b95a79798f07?w=400&h=300&fit=crop&t=${DateTime.now().millisecondsSinceEpoch}";

    setState(() {
      _photos.add(newPhotoUrl);
    });

    widget.onPhotosChanged();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Photo captured and added'),
        behavior: SnackBarBehavior.floating));
  }

  void _chooseFromGallery() {
    HapticFeedback.lightImpact();

    // Simulate adding a new photo from gallery
    final String newPhotoUrl =
        "https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=400&h=300&fit=crop&t=${DateTime.now().millisecondsSinceEpoch}";

    setState(() {
      _photos.add(newPhotoUrl);
    });

    widget.onPhotosChanged();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Photo selected and added'),
        behavior: SnackBarBehavior.floating));
  }

  void _viewPhoto(String photoUrl, int index) {
    showDialog(
        context: context,
        builder: (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(2.w),
            child: Stack(children: [
              Center(
                  child: Container(
                      constraints:
                          BoxConstraints(maxWidth: 90.w, maxHeight: 80.h),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: CustomImageWidget(
                              imageUrl: photoUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain)))),
              Positioned(
                  top: 4.w,
                  right: 4.w,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: CustomIconWidget(
                              iconName: 'close',
                              color: Colors.white,
                              size: 24)))),
              Positioned(
                  bottom: 4.w,
                  right: 4.w,
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deletePhoto(index);
                          },
                          icon: CustomIconWidget(
                              iconName: 'delete',
                              color: Colors.white,
                              size: 24)))),
            ])));
  }

  void _deletePhoto(int index) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
                title: Text('Delete Photo'),
                content: Text('Are you sure you want to delete this photo?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel')),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          _photos.removeAt(index);
                        });
                        widget.onPhotosChanged();
                        HapticFeedback.mediumImpact();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Photo deleted'),
                            backgroundColor:
                                AppTheme.lightTheme.colorScheme.error,
                            behavior: SnackBarBehavior.floating));
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                              AppTheme.lightTheme.colorScheme.error),
                      child: Text('Delete')),
                ]));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: EdgeInsets.all(4.w),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('Photo Attachments',
                    style: AppTheme.lightTheme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600)),
                Text('${_photos.length} photos',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color:
                            AppTheme.lightTheme.colorScheme.onSurfaceVariant)),
              ]),
              SizedBox(height: 3.w),

              if (_photos.isEmpty) ...[
                // Empty State
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.3),
                            style: BorderStyle.solid)),
                    child: Column(children: [
                      CustomIconWidget(
                          iconName: 'add_a_photo',
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          size: 32),
                      SizedBox(height: 2.w),
                      Text('No photos attached',
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                                  color: AppTheme.lightTheme.colorScheme
                                      .onSurfaceVariant)),
                      SizedBox(height: 1.w),
                      Text('Add photos to document this order',
                          style: AppTheme.lightTheme.textTheme.bodySmall
                              ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant
                                      .withValues(alpha: 0.7)),
                          textAlign: TextAlign.center),
                    ])),
              ] else ...[
                // Photo Grid
                GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 2.w,
                        mainAxisSpacing: 2.w,
                        childAspectRatio: 1),
                    itemCount: _photos.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => _viewPhoto(_photos[index], index),
                          child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: AppTheme
                                          .lightTheme.colorScheme.outline
                                          .withValues(alpha: 0.3))),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Stack(fit: StackFit.expand, children: [
                                    CustomImageWidget(
                                        imageUrl: _photos[index],
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover),
                                    Container(
                                        decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                                begin: Alignment.topRight,
                                                end: Alignment.center,
                                                colors: [
                                          Colors.black.withValues(alpha: 0.3),
                                          Colors.transparent,
                                        ]))),
                                    Positioned(
                                        top: 1.w,
                                        right: 1.w,
                                        child: Container(
                                            padding: EdgeInsets.all(1.w),
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withValues(alpha: 0.5),
                                                shape: BoxShape.circle),
                                            child: CustomIconWidget(
                                                iconName: 'fullscreen',
                                                color: Colors.white,
                                                size: 12))),
                                  ]))));
                    }),
              ],

              SizedBox(height: 3.w),

              // Add Photo Button
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                      onPressed: _showPhotoOptions,
                      icon: CustomIconWidget(
                          iconName: 'add_a_photo',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 18),
                      label: Text('Add Photo'),
                      style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 3.w)))),
            ])));
  }
}
