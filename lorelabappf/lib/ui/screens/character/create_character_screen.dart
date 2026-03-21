import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/data/models/world_model.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';
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
  State<CreatingCharacterScreen> createState() =>
      _CreatingCharacterScreenState();
}

class _CreatingCharacterScreenState extends State<CreatingCharacterScreen> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _backstory = '';

  DocumentReference? _worldRef;
  String? _selectedWorldId;

  bool _isLoading = false;

  final userId = FirebaseAuth.instance.currentUser?.uid ?? '';

  List<World> _worlds = [];

  @override
  void initState() {
    super.initState();

    _name = widget.character?.name ?? '';
    _backstory = widget.character?.backstory ?? '';

    _loadWorlds();
  }

  Future<void> _loadWorlds() async {
    final worldVM = context.read<WorldViewModel>();

    await worldVM.loadWorlds();

    setState(() {
      _worlds = worldVM.worlds;

      if (widget.character != null) {
        _selectedWorldId = widget.character!.worldRef?.id;
        _worldRef = widget.character!.worldRef;
      } else {
        _selectedWorldId = null;
        _worldRef = null;
      }
    });
  }

  Future<void> _saveCharacter() async {
    if (!_formKey.currentState!.validate()) return;

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not authenticated')),
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
          worldRef: _worldRef,
          createdOn: widget.character!.createdOn,
          updatedOn: now,
          userId: userId,
        );

        await viewModel.updateCharacter(updated);

        Navigator.pop(context, true);
      } else {
        await viewModel.createCharacter(
          name: _name,
          backstory: _backstory,
          worldRef: _worldRef,
          createdOn: now,
          updatedOn: now,
          userId: userId,
        );

        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
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
              const SizedBox(height: 16),

              /// CHARACTER NAME
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Character Name'),
                onSaved: (val) => _name = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a name' : null,
              ),

              const SizedBox(height: 16),

              /// BACKSTORY
              TextFormField(
                initialValue: _backstory,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'Backstory'),
                onSaved: (val) => _backstory = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a backstory' : null,
              ),

              const SizedBox(height: 16),

              /// WORLD DROPDOWN
              DropdownButtonFormField<String?>(
                value: _selectedWorldId,
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      "No World",
                      style: CosmicTheme.bodyStyle,
                    ),
                  ),
                  ..._worlds.map((world) {
                    return DropdownMenuItem<String?>(
                      value: world.id,
                      child: Text(
                        world.name,
                        style: CosmicTheme.bodyStyle,
                      ),
                    );
                  }).toList(),
                ],
                onChanged: (value) {
  setState(() {
    _selectedWorldId = value;

    if (value == null) {
      _worldRef = null;
    } else {
      _worldRef = context
          .read<WorldViewModel>()
          .getWorldReference(value);
    }
  });
},
                decoration: InputDecoration(
                  labelText: 'Select World',
                  labelStyle: CosmicTheme.bodyStyle,
                  filled: true,
                  fillColor: CosmicTheme.cosmicPurple.withOpacity(0.2),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CosmicTheme.galaxyPink, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: CosmicTheme.galaxyPink, width: 1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                dropdownColor: CosmicTheme.cosmicPurple,
                iconEnabledColor: CosmicTheme.galaxyPink,
                style: CosmicTheme.bodyStyle,
              ),

              const Spacer(),

              /// SAVE BUTTON
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: const Icon(Icons.save),
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