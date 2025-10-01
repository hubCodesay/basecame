import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:basecam/ui/theme.dart';
import 'package:basecam/stubs.dart' as stubs;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NewLocationPage extends StatefulWidget {
  const NewLocationPage({Key? key}) : super(key: key);

  @override
  State<NewLocationPage> createState() => _NewLocationPageState();
}

class _NewLocationPageState extends State<NewLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final TextEditingController _descrController = TextEditingController();
  LatLng? _pickedPoint;
  File? _pickedImage;
  bool _saving = false;

  Future<void> _pickImage() async {
    try {
      final picker = stubs.ImagePicker();
      final xfile = await picker.pickImage(
        source: stubs.ImageSource.gallery,
        imageQuality: 80,
      );
      if (xfile == null) return;
      setState(() => _pickedImage = File(xfile.path));
    } catch (e) {
      debugPrint('Image pick failed: $e');
    }
  }

  Future<void> _pickOnMap() async {
    // Open a simple full-screen map picker. If GoogleMap is not configured,
    // fallback to a dialog asking for lat/lng.
    final result = await Navigator.of(
      context,
    ).push<LatLng?>(MaterialPageRoute(builder: (_) => const _MapPointPicker()));
    if (result != null) setState(() => _pickedPoint = result);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      final ownerId = user?.uid ?? 'anonymous';

      // Prepare payload
      final tags = _tagsController.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();

      final data = <String, dynamic>{
        'title': _titleController.text.trim(),
        'tagLoc': tags,
        'descrLoc': _descrController.text.trim(),
        'locatPoint': _pickedPoint != null
            ? GeoPoint(_pickedPoint!.latitude, _pickedPoint!.longitude)
            : null,
        'idUserCreate': ownerId,
        'viewUser': 0,
        'photoLoc': null,
        'createdAt': FieldValue.serverTimestamp(),
      };

      final docRef = await FirebaseFirestore.instance
          .collection('location')
          .add(data);

      // If image picked and Firebase Storage is available, try to upload.
      // We'll attempt a best-effort upload; if it fails we leave photoLoc null.
      // Optional image upload logic can be added here (firebase_storage).

      // Update doc with id for reference
      await docRef.set({'id': docRef.id}, SetOptions(merge: true));

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      debugPrint('Save location failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save location')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create new location')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Enter title' : null,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tagsController,
                  decoration: const InputDecoration(
                    labelText: 'Tags (comma separated)',
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descrController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        _pickedPoint == null
                            ? 'No point selected'
                            : 'Point: ${_pickedPoint!.latitude.toStringAsFixed(5)}, ${_pickedPoint!.longitude.toStringAsFixed(5)}',
                      ),
                    ),
                    TextButton(
                      onPressed: _pickOnMap,
                      child: const Text('Pick on map'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _pickedImage == null
                          ? const Text('No photo')
                          : SizedBox(
                              height: 80,
                              child: Image.file(File(''), fit: BoxFit.cover),
                            ),
                    ),
                    TextButton(
                      onPressed: _pickImage,
                      child: const Text('Pick photo'),
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    child: _saving
                        ? const CircularProgressIndicator()
                        : const Text('Save'),
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

class _MapPointPicker extends StatefulWidget {
  const _MapPointPicker({Key? key}) : super(key: key);

  @override
  State<_MapPointPicker> createState() => _MapPointPickerState();
}

class _MapPointPickerState extends State<_MapPointPicker> {
  LatLng _current = const LatLng(37.4279, -122.0857);
  LatLng? _picked;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick point')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _current, zoom: 14),
            onTap: (latlng) => setState(() => _picked = latlng),
            markers: _picked == null
                ? {}
                : {
                    Marker(
                      markerId: const MarkerId('picked'),
                      position: _picked!,
                    ),
                  },
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: ElevatedButton(
              onPressed: _picked == null
                  ? null
                  : () => Navigator.of(context).pop(_picked),
              child: const Text('Confirm'),
            ),
          ),
        ],
      ),
    );
  }
}
