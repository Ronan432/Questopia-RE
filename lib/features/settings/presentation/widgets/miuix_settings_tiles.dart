import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

class MiuixSettingsGroup extends StatelessWidget {
  const MiuixSettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return MiuixCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.only(left: 56),
                child: MiuixHorizontalDivider(),
              ),
            children[i],
          ],
        ],
      ),
    );
  }
}

Widget miuixSettingsIcon(IconData icon) => Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Icon(icon, size: 22),
    );

MiuixArrowPreference miuixArrowPreference({
  required String title,
  required IconData icon,
  String? summary,
  required VoidCallback onClick,
}) {
  return MiuixArrowPreference(
    title: title,
    summary: summary,
    startAction: miuixSettingsIcon(icon),
    onClick: onClick,
  );
}

MiuixSwitchPreference miuixSwitchPreference({
  required String title,
  required IconData icon,
  String? summary,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return MiuixSwitchPreference(
    title: title,
    summary: summary,
    startAction: miuixSettingsIcon(icon),
    value: value,
    onChanged: onChanged,
  );
}

MiuixSliderPreference miuixSliderPreference({
  required String title,
  required IconData icon,
  required double value,
  required double min,
  required double max,
  required int steps,
  required String valueText,
  required ValueChanged<double> onChanged,
}) {
  return MiuixSliderPreference(
    title: title,
    startAction: miuixSettingsIcon(icon),
    value: value,
    min: min,
    max: max,
    steps: steps,
    valueText: valueText,
    onValueChange: onChanged,
  );
}

MiuixBasicComponent miuixInfoPreference({
  required String title,
  required IconData icon,
  String? summary,
  Widget? endAction,
  VoidCallback? onClick,
}) {
  return MiuixBasicComponent(
    title: title,
    summary: summary,
    startAction: miuixSettingsIcon(icon),
    endActions: [if (endAction != null) endAction],
    onClick: onClick,
  );
}
