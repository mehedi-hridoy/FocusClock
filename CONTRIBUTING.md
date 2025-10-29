# Contributing to Focus Clock

First off, thank you for considering contributing to Focus Clock! 🎉

It's people like you that make Focus Clock such a great tool. We welcome contributions from everyone, whether it's a bug report, feature suggestion, documentation improvement, or code contribution.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How Can I Contribute?](#how-can-i-contribute)
  - [Reporting Bugs](#reporting-bugs)
  - [Suggesting Features](#suggesting-features)
  - [Code Contributions](#code-contributions)
- [Development Setup](#development-setup)
- [Coding Guidelines](#coding-guidelines)
- [Commit Messages](#commit-messages)
- [Pull Request Process](#pull-request-process)

---

## Code of Conduct

This project and everyone participating in it is governed by our commitment to creating a welcoming and inclusive environment. By participating, you are expected to uphold this code.

**Expected Behavior:**
- Be respectful and inclusive
- Be patient and understanding
- Accept constructive criticism gracefully
- Focus on what is best for the community

**Unacceptable Behavior:**
- Harassment or discriminatory language
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information

---

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates.

**How to Submit a Bug Report:**

1. **Use a clear title** that describes the problem
2. **Provide detailed steps** to reproduce the issue
3. **Include screenshots** if applicable
4. **Mention your environment:**
   - Device model
   - Android version
   - App version
   - Any relevant settings

**Bug Report Template:**

```markdown
## Bug Description
A clear and concise description of the bug.

## Steps to Reproduce
1. Go to '...'
2. Tap on '...'
3. See error

## Expected Behavior
What you expected to happen.

## Actual Behavior
What actually happened.

## Screenshots
If applicable, add screenshots.

## Environment
- Device: [e.g. Samsung Galaxy S21]
- Android Version: [e.g. 12]
- App Version: [e.g. 1.0.0]
```

### Suggesting Features

We love feature suggestions! Here's how to submit one:

1. **Check existing issues** to see if it's already suggested
2. **Use a clear title** describing the feature
3. **Explain the problem** the feature would solve
4. **Describe your proposed solution**
5. **Consider alternatives** you've thought about

**Feature Request Template:**

```markdown
## Feature Description
A clear description of the feature you'd like to see.

## Problem it Solves
What problem does this feature address?

## Proposed Solution
How would you like to see this implemented?

## Alternatives Considered
What other solutions have you thought about?

## Additional Context
Any other context, screenshots, or examples.
```

### Code Contributions

Ready to contribute code? Awesome! Here's how:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/AmazingFeature`)
3. **Make your changes**
4. **Test thoroughly**
5. **Commit with a clear message**
6. **Push to your fork**
7. **Open a Pull Request**

---

## Development Setup

### Prerequisites

- Flutter SDK (3.24.5 or higher)
- Dart SDK (3.5.4 or higher)
- Android Studio or VS Code
- Android device or emulator

### Setup Steps

```bash
# 1. Fork and clone the repository
git clone https://github.com/YOUR_USERNAME/FocusClock.git
cd FocusClock

# 2. Add upstream remote
git remote add upstream https://github.com/mehedi-hridoy/FocusClock.git

# 3. Install dependencies
flutter pub get

# 4. Run the app
flutter run

# 5. Run tests (when available)
flutter test
```

### Project Structure

```
lib/
├── core/           # Constants, services, utilities
├── data/           # Models and data structures
├── state/          # State management (Provider)
└── presentation/   # UI screens and widgets
```

---

## Coding Guidelines

### Flutter/Dart Style

- Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` before committing
- Run `flutter analyze` to check for issues

### Code Quality

- **Write clear, self-documenting code**
- **Add comments for complex logic**
- **Keep functions small and focused**
- **Use meaningful variable names**
- **Follow DRY principle** (Don't Repeat Yourself)

### UI/UX Guidelines

- **Maintain consistent dark theme**
- **Ensure responsive design** (portrait & landscape)
- **Use provided color palette**
- **Add smooth animations** for transitions
- **Test on different screen sizes**

### Example Code Style

```dart
// Good ✅
class TimerProvider extends ChangeNotifier {
  Duration _duration = const Duration(minutes: 5);
  bool _isRunning = false;

  /// Starts the timer countdown
  void start() {
    if (!_isRunning) {
      _isRunning = true;
      _startTimer();
      notifyListeners();
    }
  }
}

// Bad ❌
class TimerProvider extends ChangeNotifier{
  Duration d=Duration(minutes:5);
  bool r=false;
  
  void start(){
    if(!r){r=true;st();notifyListeners();}
  }
}
```

---

## Commit Messages

Write clear, descriptive commit messages following this format:

### Format

```
<type>: <subject>

<body (optional)>

<footer (optional)>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting, missing semicolons, etc.
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance tasks

### Examples

```bash
# Good ✅
feat: add countdown direction toggle for timer
fix: resolve alarm notification not showing on Android 12+
docs: update README with new timer features
refactor: simplify color picker widget logic

# Bad ❌
fix stuff
updated files
changes
```

---

## Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] Code is properly formatted (`dart format`)
- [ ] No analyzer warnings (`flutter analyze`)
- [ ] Tested on multiple devices/screen sizes
- [ ] Screenshots added (for UI changes)
- [ ] Documentation updated (if needed)
- [ ] CHANGELOG.md updated (for significant changes)

### Pull Request Template

```markdown
## Description
Brief description of changes made.

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How was this tested?

## Screenshots
Add screenshots for UI changes.

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed my code
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] No new warnings
- [ ] Tested thoroughly
```

### Review Process

1. Maintainers will review your PR
2. Address any feedback or requested changes
3. Once approved, your PR will be merged
4. Your contribution will be credited!

---

## Development Tips

### Hot Reload
Use `r` in terminal for hot reload during development:
```bash
flutter run
# Press 'r' to hot reload
# Press 'R' to hot restart
```

### Debugging
```dart
// Use debugPrint for logging
debugPrint('Timer started: ${_duration.inSeconds}s');

// Avoid print() in production code
```

### State Management
```dart
// Always call notifyListeners() after state changes
void updateColor(Color color) {
  _selectedColor = color;
  notifyListeners(); // Don't forget this!
}
```

---

## Questions?

Have questions about contributing? Feel free to:
- Open an issue with the `question` label
- Start a [discussion](../../discussions)
- Reach out to the maintainers

---

## Recognition

Contributors will be recognized in:
- README.md acknowledgments
- Release notes
- Project documentation

---

**Thank you for contributing to Focus Clock! 🎉**

*Every contribution, no matter how small, makes a difference.*
