import 'package:flutter/material.dart';
import 'package:mygame_p2e/features/auth/src/presentation/entry/widgets/auth_entry_widgets.dart';
import 'package:p2e_design_system/design_system.dart';

/// Shared golden composition for the Auth Entry widgets. Test-only.
class AuthEntryWidgetFixture extends StatefulWidget {
  const AuthEntryWidgetFixture({
    super.key,
    required this.label,
    required this.divider,
    required this.remember,
    required this.terms,
    required this.privacy,
    required this.playStation,
    required this.xbox,
    required this.google,
  });
  final String label,
      divider,
      remember,
      terms,
      privacy,
      playStation,
      xbox,
      google;
  @override
  State<AuthEntryWidgetFixture> createState() => _AuthEntryWidgetFixtureState();
}

class _AuthEntryWidgetFixtureState extends State<AuthEntryWidgetFixture> {
  bool checked = false;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const HeroBanner(elementId: 'gallery.auth.hero'),
      AppButton(
        elementId: 'gallery.auth.accent',
        label: widget.label,
        tone: AppButtonTone.accent,
        family: AppButtonFamily.fill,
        onPressed: () {},
      ),
      AppButton(
        elementId: 'gallery.auth.loading',
        label: widget.label,
        tone: AppButtonTone.accent,
        family: AppButtonFamily.fill,
        loading: true,
        loadingSemanticsLabel: widget.label,
        onPressed: () {},
      ),
      AppCheckbox(
        elementId: 'gallery.auth.toggle',
        label: widget.remember,
        value: checked,
        onChanged: (value) => setState(() => checked = value),
      ),
      LabeledDivider(elementId: 'gallery.auth.divider', label: widget.divider),
      Row(
        children: [
          for (final brand in SocialAuthBrand.values)
            Expanded(
              child: SocialAuthTile(
                elementId: 'gallery.auth.brand.${brand.name.toLowerCase()}',
                brand: brand,
                label: switch (brand) {
                  SocialAuthBrand.playStation => widget.playStation,
                  SocialAuthBrand.xbox => widget.xbox,
                  SocialAuthBrand.google => widget.google,
                },
                onPressed: () {},
              ),
            ),
        ],
      ),
      LinkText(
        elementId: 'gallery.auth.links',
        segments: [
          LinkTextSegment(widget.terms, onTap: () {}),
          LinkTextSegment(widget.privacy, onTap: () {}),
        ],
      ),
      AppToast(
        elementId: 'gallery.auth.toast',
        message: widget.label,
        onDismiss: () {},
      ),
    ],
  );
}
