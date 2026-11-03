import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/app_colors.dart';
import '../utils/app_text.dart';
import '../utils/countries.dart';

class CountryCode extends StatelessWidget {
  const CountryCode({
    super.key,
    required this.country,
    required this.onChanged,
  });

  final Country country;
  final ValueChanged<Country> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        PopupMenuButton<Country>(
          tooltip: '',
          position: PopupMenuPosition.under,
          padding: EdgeInsets.zero,
          color: AppColors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          onSelected: onChanged,
          itemBuilder: (context) => [
            for (final item in countries)
              PopupMenuItem(value: item, child: menuItem(item)),
          ],
          child: SizedBox(height: 50, child: selected()),
        ),
        const SizedBox(width: 3),
        const SizedBox(width: 4, child: Text('I', style: AppText.divider)),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget selected() {
    return Row(
      children: [
        Image.asset(country.flag, width: 20, height: 20),
        const SizedBox(width: 3),
        SizedBox(
          width: 10,
          height: 5,
          child: OverflowBox(
            maxWidth: 11.5,
            maxHeight: 6.5,
            child: SvgPicture.asset('assets/icons/chevron_down.svg'),
          ),
        ),
        const SizedBox(width: 3),
        SizedBox(
          width: 23,
          child: Text(country.code, style: AppText.value, softWrap: false),
        ),
      ],
    );
  }

  Widget menuItem(Country item) {
    return Row(
      children: [
        Image.asset(item.flag, width: 20, height: 20),
        const SizedBox(width: 10),
        Text(item.name, style: AppText.menuItem),
        const SizedBox(width: 10),
        Text('+${item.code}', style: AppText.value),
      ],
    );
  }
}
