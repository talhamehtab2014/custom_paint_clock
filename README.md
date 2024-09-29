# Flutter Customizable Analog Clock ⏰

This project is a Flutter application that implements a customizable analog clock with animated transitions. The clock allows users to toggle between circular and rectangular designs, smoothly animating the shape and clock hands in real-time.

## Features

- ⏱️ **Real-Time Clock:** The clock updates every second, reflecting the current time.
- 🔄 **Customizable Shape:** Users can switch between circular and rectangular clock faces.
- 🎨 **Smooth Animations:** Flutter’s `AnimationController` and `Tween` provide seamless shape and clock hand transitions.
- 🖼️ **Dynamic Rendering:** The clock face and hands are rendered using `CustomPainter` for flexibility and performance.

## Screenshots

*Insert screenshots or GIFs showing the animated clock here.*

## How It Works

The main functionality is driven by `AnimationController`, `Tween`, and `CustomPainter`. The clock shape changes based on user interaction, and the hands are animated to show real-time updates.

### Code Breakdown

1. **MyHomePage Widget:**
   - Manages the clock’s state, time updates, and animation controllers.
   - Uses `Timer.periodic` to update the clock every second.

2. **CustomPainter (BackgroundPainter):**
   - Responsible for rendering the clock face and hands.
   - Draws either a circular or rectangular clock based on the user’s selection.

3. **Animations:**
   - Shape and hand transitions are controlled by `AnimationController` and `Tween`.
   - The user can toggle between circular and rectangular shapes, triggering animations.

### Key Classes & Methods

- `MyHomePage`: A stateful widget that manages time updates and shape animations.
- `BackgroundPainter`: Custom painter for drawing the clock and its hands.
- `AnimationController`: Manages the animation durations and progress.
- `Timer.periodic`: Updates the clock time every second.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/flutter-analog-clock.git
   ```
   
2. Navigate to the project directory:
   ```bash
   cd flutter-analog-clock
   ```

3. Install the dependencies:
   ```bash
   flutter pub get
   ```

4. Run the app:
   ```bash
   flutter run
   ```

## Customization
You can customize the following elements:

 - **Shape Transitions:** Toggle between rectangular and circular shapes by modifying the button actions in the MyHomePage widget.
 - **Animation Durations:** Adjust the speed of animations by changing the duration property of AnimationController.
 - **Clock Hand Design:** Modify the drawHand method in the BackgroundPainter class to change the style of the hour, minute, and second hands.
## Requirements
Flutter SDK (v2.0 or later)
Dart language
## Contributing
Contributions are welcome! If you have suggestions for improving the app, feel free to fork the repository, submit issues, or create pull requests.

## License
This project is licensed under the MIT License. See the LICENSE file for more details.

