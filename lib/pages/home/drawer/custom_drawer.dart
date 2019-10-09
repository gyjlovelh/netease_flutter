import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final double elevation;
  final Widget child;
  final String semanticLabel;
  final double width;

  CustomDrawer({
    Key key,
    this.elevation = 16.0,
    this.child,
    this.semanticLabel,
    this.width
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasMaterialLocalizations(context));
    
    return Semantics(
      scopesRoute: true,
      namesRoute: true,
      explicitChildNodes: true,
      label: semanticLabel,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(
          width: width
        ),
        child: Material(
          elevation: elevation,
          child: child,
        ),
      ),
    );
  }
}