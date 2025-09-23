import 'package:flutter/material.dart';

// Shared ScrollController + anchors
class SharedScroll extends InheritedWidget {
  final ScrollController controller;
  const SharedScroll({super.key, required this.controller, required super.child});

  static ScrollController of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<SharedScroll>();
    return inherited?.controller ?? PrimaryScrollController.maybeOf(context) ?? ScrollController();
  }

  static void jumpToAnchor(BuildContext context, String id) {
    final anchorKey = AnchorState.registry[id];
    final controller = of(context);
    if (anchorKey != null) {
      Scrollable.ensureVisible(
        anchorKey.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      controller.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeOutCubic);
    }
  }

  @override
  bool updateShouldNotify(covariant SharedScroll oldWidget) => oldWidget.controller != controller;
}

class Anchor extends StatefulWidget {
  final String id;
  final Widget child;
  const Anchor({super.key, required this.id, required this.child});

  @override
  State<Anchor> createState() => AnchorState();
}

class AnchorState extends State<Anchor> {
  static final Map<String, GlobalKey> registry = {};

  final _key = GlobalKey();

  @override
  void initState() {
    super.initState();
    registry[widget.id] = _key;
  }

  @override
  void dispose() {
    registry.remove(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(key: _key, child: widget.child);
  }
}

// Sections and cards
class Section extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  const Section({super.key, required this.title, this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                if (subtitle != null) ...[
                  const SizedBox(height: 6),
                  Text(subtitle!, style: const TextStyle(color: Colors.black54)),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  final String buttonText;
  final VoidCallback onPressed;

  const ActionCard({super.key, required this.icon, required this.title, required this.body, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(16),
      decoration: roundedBox(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(body),
          const SizedBox(height: 12),
          FilledButton(onPressed: onPressed, child: Text(buttonText)),
        ],
      ),
    );
  }
}

BoxDecoration roundedBox(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: Colors.black12),
  );
}

void showInfoDialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (c) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [TextButton(onPressed: () => Navigator.pop(c), child: const Text('OK'))],
    ),
  );
}
