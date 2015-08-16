# Auto Fold package

Fold (and unfold) marked places in a opened file with a single keypress.

![Screenshot](readme.gif)

Keybindings:
 * `alt-a` toggles the fold in the current file

## Markers
Markers tell this package, where it should fold. The following markers are available:
  * `@atom-fold here`: Marks the next line for folding
  * `@atom-fold regex /regex1/ /regex2/ ...`: marks all lines, which match the specified regexes
    * must be on the first commented line in the file!
