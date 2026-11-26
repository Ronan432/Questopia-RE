import 'package:flutter/material.dart';
import 'package:flutter_miuix/miuix.dart';

/// Resolves a Miuix vector icon by name from OS4 or extended icon sets.
MiuixVectorIcon miuixVector(String name, {MiuixVectorIcon? fallback}) =>
    MiuixIcons.os4.byName(name) ??
    MiuixIcons.extended.byName(name) ??
    fallback ??
    MiuixIcons.os4.settings;

/// Builds a [MiuixIcon] resolved by [name] with optional [size] and [tint].
Widget miuixIcon(
  String name, {
  double size = 22,
  Color? tint,
  String? contentDescription,
  MiuixVectorIcon? fallback,
}) {
  return MiuixIcon(
    vector: miuixVector(name, fallback: fallback),
    size: size,
    tint: tint,
    contentDescription: contentDescription,
  );
}
