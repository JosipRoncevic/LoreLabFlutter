import 'package:flutter/material.dart';
import 'package:lorelabappf/data/models/character_model.dart';
import 'package:lorelabappf/ui/themes/cosmic_them.dart';

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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: CosmicTheme.backgroundDecoration.copyWith(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select Characters',
              style: CosmicTheme.headingStyle,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              child: Column(
                children: widget.characters.map((character) {
                  final isSelected = _localSelectedIds.contains(character.id);
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    decoration: CosmicTheme.listItemDecoration2,
                    child: CheckboxListTile(
                      title: Text(
                        character.name,
                        style: CosmicTheme.bodyStyle,
                      ),
                      activeColor: CosmicTheme.galaxyPink,
                      checkColor: CosmicTheme.starWhite,
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
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, widget.selectedIds),
                  child: Text(
                    'Cancel',
                    style: CosmicTheme.bodyStyle.copyWith(
                      color: CosmicTheme.deleteRed,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, _localSelectedIds),
                  child: Text(
                    'Done',
                    style: CosmicTheme.bodyStyle.copyWith(
                      color: CosmicTheme.editGreen,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
