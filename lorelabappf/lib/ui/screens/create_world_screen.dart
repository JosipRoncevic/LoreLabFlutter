import 'package:flutter/material.dart';
import 'package:lorelabappf/ui/viewmodel/world_viewmodel.dart';
import 'package:provider/provider.dart';

class CreatingWorldsScreen extends StatefulWidget {
  const CreatingWorldsScreen({super.key});

  @override
  State<CreatingWorldsScreen> createState() => _CreatingWorldsScreenState();
}

class _CreatingWorldsScreenState extends State<CreatingWorldsScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  bool _isLoading = false;

  Future<void> _saveWorld() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() => _isLoading = true);

      try {
        await context
            .read<WorldViewModel>()
            .createWorld(_name.trim(), _description.trim());

        Navigator.pop(context);
      } catch (e) {
        setState(() => _isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving world: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New World')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'World Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _name = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                onSaved: (value) => _description = value ?? '',
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter a description'
                    : null,
              ),
              const SizedBox(height: 24),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      onPressed: _saveWorld,
                      icon: const Icon(Icons.save),
                      label: const Text('Save'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
