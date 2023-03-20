library state_mgr;

import 'package:flutter/widgets.dart';

class StateManager {

  _Stater? _state;

  BuildContext get context => _state!.context;

  bool get mounted => _state != null;

  void setState(VoidCallback fn) {
    // ignore: invalid_use_of_protected_member
    if(_state!=null) _state!.setState(fn);
  }

  void initState() { }

  void invalidate() => setState(() { });

  Widget build() => Container();

  void dispose() { }

}


class Stater<T extends StateManager> extends StatefulWidget {

  final T Function()? manager;
  final Widget Function(T)? builder;

  const Stater({super.key, this.manager, this.builder});

  @override
  State<Stater> createState() {
    // ignore: no_logic_in_create_state
    return _Stater<T>(manager == null
        ? StateManager() as T // exception if T is not StateContext
        : manager!());
  }

}


class _Stater<T extends StateManager> extends State<Stater<T>> {

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
    return widget.builder == null
        ? manager.build()
        : widget.builder!(manager);
  }

}

