import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/character_model.dart';

class CharacterSelectionDialog extends StatefulWidget {
  final List<Character> characters;
  final List<String> selectedIds;

  const CharacterSelectionDialog({
    Key? key,
    required this.characters,
    required this.selectedIds,
  }) : super(key: key);

  @override
  State<CharacterSelectionDialog> createState() => _CharacterSelectionDialogState();
}

class _CharacterSelectionDialogState extends State<CharacterSelectionDialog> {
  late List<String> _localSelectedIds;

  @override
  void initState() {
    super.initState();
    _localSelectedIds = List.from(widget.selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select Characters'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.characters.map((character) {
            final isSelected = _localSelectedIds.contains(character.id);
            return CheckboxListTile(
              title: Text(character.name),
              value: isSelected,
              onChanged: (selected) {
                setState(() {
                  if (selected == true) {
                    _localSelectedIds.add(character.id);
                  } else {
                    _localSelectedIds.remove(character.id);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, widget.selectedIds),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _localSelectedIds),
          child: Text('Done'),
        ),
      ],
    );
  }
}
