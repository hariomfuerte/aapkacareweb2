import 'package:aapkacare/responsive.dart';
import 'package:aapkacare/screens/SubScription-Plan/subscriptionPlanMobile.dart';
import 'package:aapkacare/screens/SubScription-Plan/subscriptionPlanWeb.dart';
import 'package:flutter/material.dart';

class SubscriptionPlan extends StatelessWidget {
  const SubscriptionPlan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Responsive(
        mobile: SubscriptionPlanMobile(),
        tablet: SubscriptionPlanMobile(),
        desktop: SubscriptionPlanWeb(),
      ),
    );
  }
}

