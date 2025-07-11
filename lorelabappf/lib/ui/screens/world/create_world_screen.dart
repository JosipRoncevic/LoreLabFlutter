import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/world_model.dart';
import 'package:lorelabappf/ui/screens/world/worlds_screen.dart';
import 'package:lorelabappf/ui/viewmodel/world_viewmodel.dart';
import 'package:provider/provider.dart';

class CreatingWorldsScreen extends StatefulWidget {
  final World? world;
  final bool isEditing;
  
  const CreatingWorldsScreen({
    Key? key,
    this.world,
    this.isEditing = false,
  }) : super(key:key);

  @override
  State<CreatingWorldsScreen> createState() => _CreatingWorldsScreenState();
}

class _CreatingWorldsScreenState extends State<CreatingWorldsScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name = '';
  late String _description = '';
  bool _isLoading = false;

  @override
  void initState(){
    super.initState();
    _name = widget.world?.name ?? '';
    _description = widget.world?.description ?? '';
  }

  Future<void> _saveWorld() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        final viewModel = context.read<WorldViewModel>();
        final now = Timestamp.now();

        if (widget.isEditing && widget.world != null) {
          final updated = World(
            id: widget.world!.id,
            name: _name,
            description: _description,
            createdOn: widget.world!.createdOn,
            updatedOn: now,
          );
          await viewModel.updateWorld(updated);
          Navigator.pop(context);
          //Navigator.push(context, MaterialPageRoute(builder: (_) => WorldsScreen()));
        } else {
            await viewModel.createWorld(name: _name,description:_description, createdOn: now, updatedOn: now);
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
        title: Text(widget.isEditing ? 'Edit World' : 'Create World'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'World Name'),
                onSaved: (val) => _name = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a name' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _description,
                maxLines: 5,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (val) => _description = val ?? '',
                validator: (val) =>
                    val == null || val.isEmpty ? 'Enter a description' : null,
              ),
              Spacer(),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text(widget.isEditing ? 'Update' : 'Save'),
                      onPressed: _saveWorld,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}