# adaptative_grid

This package provides a grid that adapts itself according to the available size. Also provides a way to customize the adaptivity.

<br>
<img WIDTH="60%" src="https://user-images.githubusercontent.com/84534787/120998591-a95c6980-c7a1-11eb-9435-7d7587f0b32b.png">
<br>
<br>


## Example

![Grid example](https://user-images.githubusercontent.com/58062436/157809067-a9bfbab4-63a8-4456-b862-3925479b8da2.gif)

Code:

```dart
class GridTest extends StatefulWidget {
  const GridTest({Key? key}) : super(key: key);

  @override
  State<GridTest> createState() => _GridTestState();
}

class _GridTestState extends State<GridTest> {
  final List<int> integers = List.generate(10, (index) => index);

  Axis direction = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Example")),
      body: Center(
        child: AdaptativeGrid.builder(
          mainAxisDirection: direction,
          scrollController: ScrollController(),
          mainAxisSpacing: 20,
          crossAxisSpacing: 10,
          // backgroudColor: Colors.amber,
          // reversedCrossAxisChildren: true,
          // gridLayout: const [[1, 2], [2, 1]],
          // margin: const EdgeInsets.all(3),
          // maxLength: 5,
          // crossAxisLength: 3,
          // crossAxisThickness: 100,
          // fillLastCrossAxis: true,
          // flexMainAxis: const [3, 1, 2],
          // maxNumberOfCrossAxis: 2,
          // thicknessOfEachMainAxis: const [100, 200],
          // thicknessOfEachCrossAxis: const [50, 100, 100],
          // expandLastMainAxis: true,
          itemCount: 10,
          itemBuilder: (context, i) => card(i),
          childrenPerCrossAxisAccordingToSize: direction == Axis.vertical
              ? const [400, 800, 1200, 1600]
              : const [100, 200, 300, 400],
        ),
      ),
    );
  }

  Widget card(int data) {
    return AspectRatio(
      aspectRatio: 3 / 1,
      child: GestureDetector(
        onTap: () {
          setState(() {
            integers[data]++;
          });
        },
        child: Card(
          color: Colors.lightGreen,
          child: Center(
            child: Text(
              integers[data].toString(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
```


## Usage

1. Add the dependency into pubspec.yaml.

```yaml
dependencies:
  adaptative_grid:
    git:
      url: git://github.com/Nicollas1705/adaptative_grid
      ref: main
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


## Some parameters options

The AdaptativeGrid gives some options to customize.

### childrenPerCrossAxisAccordingToSize

It is the main option (which is required) to customize the behavior. It will be used to show a quantity of children  according to the available size.

When [mainAxisDirection] is [Axis.vertical], the size will be compared with the max width. If it is [Axis.horizontal], the size will be compared with the max height.

When the item [double] is compared with the size, it will represent the quantity of children per cross axis.

Comparing if the available size is less than each item:
1. size < childrenPerCrossAxisAccordingToSize[0] => 1 child per cross axis
2. size < childrenPerCrossAxisAccordingToSize[1] => 2 children per cross axis
3. size < childrenPerCrossAxisAccordingToSize[2] => 3 children per cross axis
4. size >= the last [double] => children per cross axis will be [childrenPerCrossAxisAccordingToSize.length] + 1

#### Example:

```dart
childrenPerCrossAxisAccordingToSize: [400],
```

If the available width is < 400: Show just 1 children column.

If the available width is >= 400: Show 2 children column.

<table>
  <tr>
    <th>
      Width size < 400
    </th>
    <th>
      Width size >= 400
    </th>
  </tr>
  <tr>
    <th>
      <img src="https://user-images.githubusercontent.com/58062436/157809494-9989fcfa-ec9c-4ae9-aa23-95d9bca8e3fb.png">
    </th>
    <th>
      <img src="https://user-images.githubusercontent.com/58062436/157810303-4a4b2158-30e5-4bfe-992b-2454c442c28d.png">
    </th>
  </tr>
</table>


### mainAxisDirection

The axis along which the grid grows. Default: [Axis.vertical].

<img height="500px" src="https://user-images.githubusercontent.com/58062436/157811235-96ae4c67-af63-48fb-ada7-362f6d37f819.gif">


### itemBuilder and itemCount

Used in [AdaptativeGrid.builder()] constructor.

itemCount is the total quantity of children.

itemBuilder is the children builder.


### scrollController

A [ScrollController]. Use this to return a scrollable widget. The grid will be scrollable by the [ListView] widget.


### mainAxisSpacing and crossAxisSpacing

These is to set the spacing among the children.

By default, mainAxisSpacing is the vertical spacing.

By default, crossAxisSpacing is the horizontal spacing.


### maxNumberOfCrossAxis and maxLength

Use [maxNumberOfCrossAxis] to set the limit of cross axes.

Use [maxLength] to set the limit of children.


### reversedCrossAxisChildren

If it is true, the cross axis direction will be reversed.

<img height="200px" alt="Reversed example" src="https://user-images.githubusercontent.com/58062436/157812935-c375dd58-78e6-46f7-8d43-e75eb5bd90e2.png">


## flexMainAxis

Expands the in main axis children according to its flex.

Example:

```dart
flexMainAxis: const [3, 1, 2],
```

In this case, the first children column will have flex = 3; the second children column will have flex = 1; the last children column will have flex = 2.

![flexMainAxis example](https://user-images.githubusercontent.com/58062436/157816630-8cb3aa6b-0738-4333-838b-29ef10c06668.png)


## gridLayout

It can be used to customize the layout of each case in [childrenPerCrossAxisAccordingToSize].

Note: The case is according to the quantity of children per cross axis, considering the [childrenPerCrossAxisAccordingToSize] list:
  1. size < childrenPerCrossAxisAccordingToSize[0] => 1 child per cross axis (case 1)
  2. size < childrenPerCrossAxisAccordingToSize[1] => 2 children per cross axis (case 2)
  3. size < childrenPerCrossAxisAccordingToSize[2] => 3 children per cross axis (case 3)
  4. size >= the last [double] => children per cross axis will be [childrenPerCrossAxisAccordingToSize.length] + 1  (case X)

The numbers will be used to compose the number of children in each cross axis. The first number of the first list (1) indicates to the first cross axis to use only 1 child.

Example:

```dart
gridLayout: const [[1, 2], [2, 1]],
```

  1. first case [1, 2]: 1° cross axis with 1 child; 2° cross axis with 2 children; the others will not be specified;
  2. second case [2, 1]: 1° cross axis with 2 children; 2° cross axis with 1 child; the others will not be specified;
  3. the other cases will not be specified.

The lists inside the [gridLayout] can be null to skip some cases (ex: [null, [1, 2]]).

<table>
  <tr>
    <th>
      First case [1, 2]
    </th>
    <th>
      Second case [2, 1]
    </th>
    <th>
      Other cases (default)
    </th>
  </tr>
  <tr>
    <th>
      <img src="https://user-images.githubusercontent.com/58062436/157816892-eba9418f-c1dd-4cce-aba2-c3691e2a8f39.png">
    </th>
    <th>
      <img src="https://user-images.githubusercontent.com/58062436/157817126-061a04c9-ab82-4761-9c99-20d5b70ebb11.png">
    </th>
    <th>
      <img src="https://user-images.githubusercontent.com/58062436/157817274-41aacc18-4efd-4b09-b9e7-1d651c8e3bdc.png">
    </th>
  </tr>
</table>


## Note

This package was developed to be used on any platform, adapting to the window (or available) size.
