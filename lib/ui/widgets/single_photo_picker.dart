import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:basecam/ui/theme.dart';

class SinglePhotoPicker extends StatefulWidget {
  final XFile? initialFile;
  final ValueChanged<XFile?>? onChanged;

  const SinglePhotoPicker({super.key, this.initialFile, this.onChanged});

  @override
  _SinglePhotoPickerState createState() => _SinglePhotoPickerState();
}

class _SinglePhotoPickerState extends State<SinglePhotoPicker> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _imageFile = widget.initialFile;
  }

  Future<void> _pickImage() async {
    final ImageSource? source = await _showImageSourceDialog(context);
    if (source == null || !mounted) return;

    final pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 90,
      maxWidth: 1920,
      maxHeight: 1920,
    );

    if (pickedFile == null) return;

    setState(() {
      _imageFile = pickedFile;
    });

    if (widget.onChanged != null) {
      widget.onChanged!(pickedFile);
    }
  }

  Future<ImageSource?> _showImageSourceDialog(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () => Navigator.of(context).pop(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () => Navigator.of(context).pop(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }

  void _removeImage() {
    setState(() => _imageFile = null);
    if (widget.onChanged != null) widget.onChanged!(null);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickImage,
      child: DottedBorder(
        options: RoundedRectDottedBorderOptions(
          radius: const Radius.circular(20),
          dashPattern: [4, 4],
          color: ThemeColors.greyColor,
          strokeWidth: 2,
        ),
        child: Container(
          height: 130,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              if (_imageFile != null)
                _AttachedPhoto(
                  filePath: _imageFile!.path,
                  onRemove: _removeImage,
                )
              else
                Container(
                  height: 48,
                  width: 48,
                  decoration: BoxDecoration(
                    color: ThemeColors.grey3Color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.add_photo_alternate_outlined,
                      size: 48),
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  _imageFile == null ? 'Tap to add photo' : 'Photo added',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: ThemeColors.greyColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttachedPhoto extends StatelessWidget {
  final String filePath;
  final VoidCallback onRemove;

  const _AttachedPhoto({required this.filePath, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 8),
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(File(filePath)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: -6,
          right: -6,
          child: IconButton(
            icon: const Icon(Icons.close, color: Colors.red, size: 20),
            onPressed: onRemove,
          ),
        ),
      ],
    );
  }
}
