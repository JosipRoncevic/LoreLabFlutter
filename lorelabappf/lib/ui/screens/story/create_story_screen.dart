import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/data/models/story_model.dart';
import 'package:lorelabappf/data/models/world_model.dart';
import 'package:lorelabappf/ui/dialogs/character_selection_dialog.dart';
import 'package:lorelabappf/ui/screens/story/story_screen.dart';
import 'package:lorelabappf/ui/viewmodel/character_viewmodel.dart';
import 'package:lorelabappf/ui/viewmodel/story_viewmodel.dart';
import 'package:lorelabappf/ui/viewmodel/world_viewmodel.dart';
import 'package:provider/provider.dart';

class CreatingStoryScreen extends StatefulWidget {
  final Story? story;
  final bool isEditing;

  const CreatingStoryScreen({
    Key? key,
    this.story,
    this.isEditing = false,
  }) : super(key: key);

  @override
  State<CreatingStoryScreen> createState() => _CreatingStoryScreenState();
}

class _CreatingStoryScreenState extends State<CreatingStoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;
  DocumentReference? _worldRef;
  String? _selectedWorldId;
  bool _isLoading = false;

  List<World> _worlds = [];
  List<Character> _characters = [];
  List<String> _selectedCharacterIds = [];

  @override
  void initState() {
    super.initState();

    _title = widget.story?.title ?? '';
    _content = widget.story?.content ?? '';

    final worldVM = context.read<WorldViewModel>();
    final charVM = context.read<CharacterViewmodel>();

    worldVM.loadWorlds().then((_) {
      setState(() {
        _worlds = worldVM.worlds;
        if (widget.story != null) {
          _selectedWorldId = widget.story!.worldRef.id;
          _worldRef = widget.story!.worldRef;
        } else if (_worlds.isNotEmpty) {
          _selectedWorldId = _worlds.first.id;
          _worldRef = FirebaseFirestore.instance.collection('worlds').doc(_selectedWorldId);
        }
      });
    });

    charVM.loadCharacters().then((_) {
      setState(() {
        _characters = charVM.characters;
        if (widget.story != null) {
          _selectedCharacterIds = widget.story!.characterRefs.map((ref) => ref.id).toList();
        }
      });
    });
  }

  void _showCharacterSelectionDialog() async {
    if (_selectedWorldId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have to choose a world first.")),
      );
      return;
    }

    final filteredCharacters = _characters
        .where((char) => char.worldRef.id == _selectedWorldId)
        .toList();

    if (filteredCharacters.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No characters in this world.")),
      );
      return;
    }

    final selected = await showDialog<List<String>>(
      context: context,
      builder: (_) => CharacterSelectionDialog(
        characters: filteredCharacters,
        selectedIds: _selectedCharacterIds,
      ),
    );

    if (selected != null) {
      setState(() {
        _selectedCharacterIds = selected;
      });
    } 
  }

  Future<void> _saveStory() async {
    if (_formKey.currentState!.validate()) {
      if (_worldRef == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a world')),
        );
        return;
      }

      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      final characterRefs = _selectedCharacterIds
        .map((id) => FirebaseFirestore.instance.collection('characters').doc(id))
        .toList();

    try {
      final viewModel = context.read<StoryViewmodel>();
      final now = Timestamp.now();

      if (widget.isEditing && widget.story != null) {
        final updated = Story(
          id: widget.story!.id,
          title: _title,
          content: _content,
          worldRef: _worldRef!,
          characterRefs: characterRefs,
          createdOn: widget.story!.createdOn,
          updatedOn: now,
        );
        await viewModel.updateStory(updated);
        Navigator.pop(context, true);

      } else {
        await viewModel.createStory(  title: _title,content: _content,worldRef: _worldRef!,characterRefs: characterRefs,createdOn: now,updatedOn: now,);
        Navigator.pop(context, true);
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
        title: Text(widget.isEditing ? 'Edit Story' : 'Create Story'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Story Title'),
                onSaved: (val) => _title = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a title' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _content,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Content'),
                onSaved: (val) => _content = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter content' : null,
              ),
              SizedBox(height: 16),
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
              SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Characters', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              ElevatedButton(
                onPressed: _showCharacterSelectionDialog,
                child: Text('Choose Characters (${_selectedCharacterIds.length})'),
              ),
              Spacer(),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text(widget.isEditing ? 'Update' : 'Save'),
                      onPressed: _saveStory,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
