import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/data/models/world_model.dart';
import 'package:lorelabappf/ui/viewmodel/character_viewmodel.dart';
import 'package:lorelabappf/ui/viewmodel/world_viewmodel.dart';
import 'package:provider/provider.dart';

class CreatingCharacterScreen extends StatefulWidget {
  final Character? character;
  final bool isEditing;

  const CreatingCharacterScreen({
    Key? key,
    this.character,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<CreatingCharacterScreen> createState() => _CreatingCharacterScreenState();
}

class _CreatingCharacterScreenState extends State<CreatingCharacterScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _backstory;
  DocumentReference? _worldRef;
  String? _selectedWorldId;
  bool _isLoading = false;

  List<World> _worlds = [];

  @override
  void initState() {
    super.initState();

    _name = widget.character?.name ?? '';
    _backstory = widget.character?.backstory ?? '';

    final worldVM = context.read<WorldViewModel>();
    worldVM.loadWorlds().then((_) {
      setState(() {
        _worlds = worldVM.worlds;

        if (widget.character != null) {
          _selectedWorldId = widget.character!.worldRef.id;
          _worldRef = widget.character!.worldRef;
        } else if (_worlds.isNotEmpty) {
          _selectedWorldId = _worlds.first.id;
          _worldRef = FirebaseFirestore.instance.collection('worlds').doc(_selectedWorldId);
        }
      });
    });
  }

  Future<void> _saveCharacter() async {
    if (_formKey.currentState!.validate()) {
      if (_worldRef == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a world')),
        );
        return;
      }

      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        final viewModel = context.read<CharacterViewmodel>();
        final now = Timestamp.now();
        
        if (widget.isEditing && widget.character != null) {
          final updated = Character(
            id: widget.character!.id,
            name: _name,
            backstory: _backstory,
            worldRef: _worldRef!,
            createdOn: widget.character!.createdOn,
            updatedOn: now,

          );
          await viewModel.updateCharacter(updated);
           Navigator.pop(context, true);
        } else {
          await viewModel.createCharacter(name:_name, backstory:_backstory, worldRef:_worldRef!, createdOn: now, updatedOn: now);
           Navigator.pop(context);
        }

      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Character' : 'Create Character'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 16),
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Character Name'),
                onSaved: (val) => _name = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _backstory,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Backstory'),
                onSaved: (val) => _backstory = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a backstory' : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedWorldId,
                items: _worlds.map((world) {
                  return DropdownMenuItem(
                    value: world.id,
                    child: Text(world.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedWorldId = value;
                    _worldRef = FirebaseFirestore.instance
                        .collection('worlds')
                        .doc(value);
                  });
                },
                decoration: InputDecoration(labelText: 'Select World'),
                validator: (value) =>
                    value == null ? 'Please select a world' : null,
              ),
              Spacer(),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text(widget.isEditing ? 'Update' : 'Save'),
                      onPressed: _saveCharacter,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
