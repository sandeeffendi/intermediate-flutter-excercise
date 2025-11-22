import 'package:dicoding_subscriptions/content/free_packet_card.dart';
import 'package:dicoding_subscriptions/content/or_widget.dart';
import 'package:dicoding_subscriptions/content/paid_packet_card.dart';
import 'package:dicoding_subscriptions/widget/max_width_widget.dart';
import 'package:flutter/material.dart';

class PackageList extends StatelessWidget {
  const PackageList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPotrait = orientation == Orientation.portrait;

    return MaxWidthWidget(
      maxWidth: 600,
      child: isPotrait
          ? const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PaidPackageCard(),
                OrWidget(),
                FreePackageCard(),
              ],
            )
          : const IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: PaidPackageCard()),
                  OrWidget(),
                  Expanded(child: FreePackageCard()),
                ],
              ),
            ),
    );
  }
}
