import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../models/gear.dart';
import '../../services/gear_service.dart';

class NewGearPage extends StatefulWidget {
  const NewGearPage({Key? key}) : super(key: key);

  @override
  State<NewGearPage> createState() => _NewGearPageState();
}

class _NewGearPageState extends State<NewGearPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _depositController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController(
    text: 'UA',
  );
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  List<TextEditingController> _photoControllers = [];

  String _category = 'camera';
  String _condition = 'excellent';
  bool _depositRequired = false;
  bool _isSaving = false;

  final List<String> _categories = [
    'camera',
    'lens',
    'light',
    'drone',
    'accessory',
  ];
  final List<String> _conditions = [
    'excellent',
    'very_good',
    'good',
    'fair',
    'poor',
  ];

  @override
  void initState() {
    super.initState();
    // start with one photo field to encourage adding images
    _photoControllers = [TextEditingController()];
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _depositController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _latController.dispose();
    _lngController.dispose();
    for (final c in _photoControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addPhotoField() {
    setState(() {
      _photoControllers.add(TextEditingController());
    });
  }

  void _removePhotoField(int index) {
    setState(() {
      _photoControllers[index].dispose();
      _photoControllers.removeAt(index);
    });
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to create a listing')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      final price = num.tryParse(_priceController.text.trim()) ?? 0;
      final deposit = num.tryParse(_depositController.text.trim()) ?? 0;
      final lat = double.tryParse(_latController.text.trim()) ?? 0.0;
      final lng = double.tryParse(_lngController.text.trim()) ?? 0.0;

      final photos = _photoControllers
          .map((c) => c.text.trim())
          .where((s) => s.isNotEmpty)
          .map((url) => {'url': url, 'storagePath': ''})
          .toList();

      final gear = Gear(
        ownerId: user.uid,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        category: _category,
        priceAmount: price,
        priceCurrency: 'EUR',
        depositRequired: _depositRequired,
        depositAmount: _depositRequired ? deposit : 0,
        depositCurrency: 'EUR',
        locationGeo: GeoPoint(lat, lng),
        locationGeohash: '',
        locationCity: _cityController.text.trim(),
        locationCountryCode: _countryController.text.trim(),
        brand: _brandController.text.trim().isEmpty
            ? null
            : _brandController.text.trim(),
        model: _modelController.text.trim().isEmpty
            ? null
            : _modelController.text.trim(),
        condition: _condition,
        availability: {'timezone': 'Europe/Kyiv', 'bookedCount': 0},
        photos: photos,
      );

      final id = await GearService().createGear(gear);

      if (mounted) {
        if (photos.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Listing created without photos — you can add them later',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Listing created')));
        }
        Navigator.of(context).pop(id);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Save failed: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New listing')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Basic'),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 4,
                        validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _category,
                        items: _categories
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _category = v ?? _category),
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Price & Deposit'),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _priceController,
                              decoration: const InputDecoration(
                                labelText: 'Price per day (EUR)',
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            children: [
                              const Text('Deposit'),
                              Switch(
                                value: _depositRequired,
                                onChanged: (val) =>
                                    setState(() => _depositRequired = val),
                              ),
                            ],
                          ),
                        ],
                      ),
                      if (_depositRequired) const SizedBox(height: 8),
                      if (_depositRequired)
                        TextFormField(
                          controller: _depositController,
                          decoration: const InputDecoration(
                            labelText: 'Deposit amount (EUR)',
                          ),
                          keyboardType: TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (v) {
                            if (!_depositRequired) return null;
                            if (v == null || v.trim().isEmpty)
                              return 'Required';
                            return null;
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Location'),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _latController,
                              decoration: const InputDecoration(
                                labelText: 'Latitude',
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _lngController,
                              decoration: const InputDecoration(
                                labelText: 'Longitude',
                              ),
                              keyboardType: TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(labelText: 'City'),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _countryController,
                        decoration: const InputDecoration(
                          labelText: 'Country code (e.g. UA)',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle('Details & Photos'),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _brandController,
                              decoration: const InputDecoration(
                                labelText: 'Brand',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _modelController,
                              decoration: const InputDecoration(
                                labelText: 'Model',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _condition,
                        items: _conditions
                            .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _condition = v ?? _condition),
                        decoration: const InputDecoration(
                          labelText: 'Condition',
                        ),
                      ),

                      const SizedBox(height: 12),
                      const Text('Photos (URLs)'),
                      const SizedBox(height: 8),
                      ..._photoControllers.asMap().entries.map((e) {
                        final idx = e.key;
                        final ctl = e.value;
                        return Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: ctl,
                                decoration: InputDecoration(
                                  labelText: 'Photo ${idx + 1} URL',
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: _photoControllers.length > 1
                                  ? () => _removePhotoField(idx)
                                  : null,
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _addPhotoField,
                          icon: const Icon(Icons.add_a_photo),
                          label: const Text('Add photo URL'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _save,
                      child: _isSaving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Create listing'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
