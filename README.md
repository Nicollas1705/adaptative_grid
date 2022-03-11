# adaptative_grid

This package provides a grid that adapts itself according to the available size. Also provides a way to costumize the adaptivity.

<br>
<img WIDTH="60%" src="https://user-images.githubusercontent.com/84534787/120998591-a95c6980-c7a1-11eb-9435-7d7587f0b32b.png">
<br>
<br>

# TODO README

* Add example
* Add dependency


## Example

![Grid example](C:\Users\nicol\Desktop\Grid.gif)


## Usage

1. Add the dependency into pubspec.yaml.

```dart
dependencies:
  ...
```

2. Import the library:

```dart
import 'package:adaptative_grid/adaptative_grid.dart';
```

3. Use the AdaptativeGrid:

```dart
AdaptativeGrid.builder(
  itemCount: 10,
  itemBuilder: (context, i) => AspectRatio(
    aspectRatio: 3 / 1,
    child: Card(
      color: Colors.lightGreen,
      child: Center(child: Text(i.toString())),
    ),
  ),
  childrenPerCrossAxisAccordingToSize: const [400, 800, 1200, 1600],
),
```


## Options

The AdaptativeGrid gives some options to customize.

### childrenPerCrossAxisAccordingToSize

It is the main option (which is required) to costumize the behave. It will be used to show a children quantity according to the available size.

When [mainAxisDirection] is [Axis.vertical], the size will be compared with the max width. If it is [Axis.horizontal], the size will be compared with the max height.

When the item [double] is compared with the size, it will represents the children quantity per cross axis.

Comparing if the available size is less than each item:
1. size < childrenPerCrossAxisAccordingToSize[0] => 1 child per cross axis
2. size < childrenPerCrossAxisAccordingToSize[1] => 2 children per cross axis
3. size < childrenPerCrossAxisAccordingToSize[2] => 3 children per cross axis
4. size >= the last [double] => children per cross axis will be [childrenPerCrossAxisAccordingToSize.length] + 1

#### Example:

childrenPerCrossAxisAccordingToSize: [400],

If the available width is < 400: Show just 1 children column

If the available width is >= 400: Show 2 children column







          mainAxisDirection: direction,
          scrollController: ScrollController(),
          // backgroudColor: Colors.amber,
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          // reversedCrossAxisChildren: true,
          // gridLayout: [[1, 2], [2, 1]],
          // margin: const EdgeInsets.all(3),
          // maxLength: 5,
          // crossAxisLength: 3,
          // crossAxisThickness: 100,
          // fillLastCrossAxis: true,
          // flexMainAxis: [3, 1, 2],
          // maxNumberOfCrossAxis: 2,
          // thicknessOfEachMainAxis: [100, 200],
          // thicknessOfEachCrossAxis: [50, 100, 100],
          // expandLastMainAxis: true,
          itemCount: 10,
          itemBuilder: (context, i) => card(i),
          childrenPerCrossAxisAccordingToSize: direction == Axis.vertical
              ? const [400, 800, 1200, 1600]
              : const [400, 500, 600, 700],




### Multiple masks (automatically updated according to the text size)

```dart
final controller = TextMaskingController(
  masks: ["000.000.000-00", "00.000.000/0000-00"],
);
```

### Costumizing the filters

To set a Map filter, use the key (example: "_") and the regex pattern (example: r'[01]').

```dart
final controller = TextMaskingController(
  mask: "_ _ _ _",
  filters: {"_": r'[01]'}, // Binary code
);
```

### Initializing a text

```dart
final controller = TextMaskingController(
  masks: ["(00) 00000-0000"],
  initialText: "12345678901", // Result: (12) 34567-8901
);
```

### Completing the mask quickly

It will complete the mask as quick as possible:

Mask example: "00--00".

When input only 2 numbers ("12"), the result will be: "12--|" (the cursor will go to the final).

Note: The cursor is represented by this character: "|" (pipe).

```dart
final controller = TextMaskingController(
  mask: "+00 (00) 00000-0000",
  maskAutoComplete: MaskAutoComplete.quick,
  initialText: "1234", // Result: +12 (34) 
);
```


## Methods

### Update to another single mask or masks

Use the "mask" parameter to update to a single mask.

Use the "masks" parameter to update to a multiple masks.

```dart
controller.updateMask(mask: "000-000");
```

### Update the thext using updateText() method
```dart
controller.updateText("123456");
```

### Get the default filters (it is an static method)
```dart
Map<String, String> defaultFilters = TextMaskingController.defaultFilters;
```

### Get the current mask

It will returns the mask being used by the current text.

It can be null because the "mask" and "masks" parameters can be null.

```dart
String? mask = controller.currentMask;
```

### Get the clean text (without the mask)

Mask example: "00-00-00".

Input example: "123456" (resulting: "12-34-56").

The unmasked text will be: "123456".

```dart
String text = controller.unmaskedText;
```

### Check if the current mask is properly filled

Masks example: ["00-00", "0000-0000"].

Input example: "1234" (resulting: "12-34"). This is filled.

Input example: "123456" (resulting: "1234-56"). This is not filled.

```dart
bool filled = controller.isFilled;
```


## Default filters

<table>
  <tr>
    <th>Key</th>
    <th>Regex pattern</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>0</td>
    <td>[0-9]</td>
    <td>Only numbers</td>
  </tr>
  <tr>
    <td>A</td>
    <td>[A-Z]</td>
    <td>Upper case letters</td>
  </tr>
  <tr>
    <td>a</td>
    <td>[a-z]</td>
    <td>Lower case letters</td>
  </tr>
  <tr>
    <td>@</td>
    <td>[a-zA-Z]</td>
    <td>Any case letters</td>
  </tr>
  <tr>
    <td>*</td>
    <td>.*</td>
    <td>Any character</td>
  </tr>
</table>


## Example masks

```dart
final cpfAndCnpj = TextMaskingController(
  masks: ["000.000.000-00", "00.000.000/0000-00"],
);

final brazilianPhones = TextMaskingController(
  masks: 
    "+00 (00) 00000-0000",
    "+00 (00) 0000-0000",
    "(00) 00000-0000",
    "(00) 0000-0000",
    "00000-0000",
    "0000-0000",
  ],
);

final date = TextMaskingController(mask: "00/00/0000");
```


## Note

This package was developed based on [flutter_masked_text2](https://pub.dev/packages/flutter_masked_text2) and [mask_text_input_formatter](https://pub.dev/packages/mask_text_input_formatter) packages.


## Main differences

### Can use multiple masks easily

Just set the "masks" parameter to update the mask according to the text size.

### This package saves the user cursor

The cursor will be saved even if it changes the mask from masks parameter.

Masks example: ["00-00", "000-000", "0000-0000"].

Note: The cursor will be represented by this character: "|" (pipe).

Result text from an input: "12-|34". If the user add some number (example: "123"), the result will be: "1212-3|34".

Adding each character ("123"):
<table>
  <tr>
    <th>Text</th>
    <th>Input</th>
    <th>Result</th>
  </tr>
  <tr>
    <td>"12-|34"</td>
    <td>"1"</td>
    <td>"121-|34"</td>
  </tr>
  <tr>
    <td>"121-|34"</td>
    <td>"2"</td>
    <td>"121-2|34"</td>
  </tr>
  <tr>
    <td>"121-2|34"</td>
    <td>"3"</td>
    <td>"1212-3|34"</td>
  </tr>
</table>


## TODO

### [ ] Convert lower-upper case inputs

Nowadays, the code doesn't convert the letter case.

Example:

```dart
final controller = TextMaskingController(
  mask: "AAA",
);
```

If the user types "abc" (lower case), the text will not be insert. It will only be insert if the user type upper case letters.


### [ ] Make a way to update the mask automatically based on the first digits (not only by the text size).

Example:

```dart
final controller = TextMaskingController(
  masks: ["A-00", "B-0000", "C-000000"],
  filters: {
    "A": r'[A]', 
    "B": r'[B]', 
    "C": r'[C]', 
    "0": r'[0-9]',
  },
);
```

If the user starts typing "A", it will be only able to type 2 more numbers. If starts with "B", 4 more numbers. If starts with "C", 6 more numbers.
