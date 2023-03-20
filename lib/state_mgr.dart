library state_mgr;

import 'package:flutter/widgets.dart';

/// [StateManager] is used to manage the view state of an object
class StateManager {
  /// The current [State] of the object representation in the tree
  _Stater? _state;

  /// [context] of the current [State]
  BuildContext get context => _state!.context;

  /// Whether this [State] object is currently in a tree
  bool get mounted => _state != null;

  /// Notify the framework that the internal state of this object has changed
  void setState(VoidCallback fn) {
    // ignore: invalid_use_of_protected_member
    if (_state != null) _state!.setState(fn);
  }

  /// Called when object is inserted into the tree
  void initState() {}

  /// Notify the framework that the internal state of this object has changed
  void invalidate() => setState(() {});

  /// Describes the part of the user interface represented by this manager of object
  Widget build() => Container();

  /// Called when the object representation is permanently removed from the tree
  void dispose() {}
}

/// A [Stater] is a widget designed to be embedded in a widget tree
/// and build a state widget
class Stater<T extends StateManager> extends StatefulWidget {
  /// State manager for object representation
  ///
  /// If [manager] is null, a base [StateManager] will be created to represent
  /// the object
  final T Function()? manager;

  /// [State] representation
  ///
  /// If [builder] is null, will be used build of [manager]
  final Widget Function(T)? builder;

  const Stater({super.key, this.manager, this.builder});

  @override
  State<Stater> createState() {
    // ignore: no_logic_in_create_state
    return _Stater<T>(manager == null
        ? StateManager() as T // exception if T is not StateManager
        : manager!());
  }
}

class _Stater<T extends StateManager> extends State<Stater<T>> {
  /// The current view [manager] of the object in the tree
  final T manager;

  _Stater(this.manager);

  @override
  void initState() {
    manager._state = this;
    manager.initState();
    super.initState();
  }

  @override
  void reassemble() {
    manager._state = this;
    super.reassemble();
  }

  @override
  void dispose() {
    manager._state = null;
    manager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder == null ? manager.build() : widget.builder!(manager);
  }
}
