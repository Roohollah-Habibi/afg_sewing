import 'package:afg_sewing/models_and_List/customer.dart';
import 'package:afg_sewing/models_and_List/order.dart';
import 'package:afg_sewing/providers/customer_provider.dart';
import 'package:afg_sewing/custom_widgets/text_icon_row.dart';
import 'package:afg_sewing/themes/app_colors_themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// custom popup menu to show [swen, delivered , in progress]
class CustomPopupMenuButton extends StatelessWidget {
  final Order order;
  final CustomerProvider provider;
  final Customer customer;

  const CustomPopupMenuButton({super.key, required this.order, required this.customer, required this.provider});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder: (context) => <PopupMenuEntry<String>>[
        PopupMenuItem(
            value: 'Sewn NOT Delivered',
            onTap: () => provider.onPopupMenu(order: order, value: 'Sewn NOT Delivered', customer: customer),
            child: SimpleRowForTextIcon(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                text: AppLocalizations.of(context)!.sewnNotDelivered,
                icon: const Icon(Icons.circle, color: AppColorsAndThemes.accentColor),
                firstIconThenText: false)),
        const PopupMenuDivider(height: 10),
        PopupMenuItem(
          value: 'Sewn & Delivered',
          onTap: () => provider.onPopupMenu(order: order, value: 'Sewn & Delivered', customer: customer),
          child: SimpleRowForTextIcon(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            text: AppLocalizations.of(context)!.sewnAndDelivered,
            icon: Icon(
              Icons.circle,
              color: Colors.green[800],
            ),
            firstIconThenText: false,
          ),
        ),
        const PopupMenuDivider(height: 10),
        PopupMenuItem(
          value: 'In Progress',
          onTap: () => provider.onPopupMenu(order: order, value: 'In Progress', customer: customer),
          child: SimpleRowForTextIcon(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            text: AppLocalizations.of(context)!.inProgress,
            icon: Icon(Icons.circle, color: Colors.orange.shade700),
            firstIconThenText: false,
          ),
        ),
      ],
    );
  }
}