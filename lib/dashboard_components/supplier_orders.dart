import 'package:chawla_trial_udemy/dashboard_components/preparing_orders.dart';
import 'package:chawla_trial_udemy/dashboard_components/shipping_orders.dart';
import 'package:chawla_trial_udemy/my_widgets/appbar_widgets.dart';
import 'package:flutter/material.dart';

import 'delivered_orders.dart';

class SupplierOrders extends StatefulWidget {
  const SupplierOrders({Key? key}) : super(key: key);

  @override
  State<SupplierOrders> createState() => _SupplierOrdersState();
}

class _SupplierOrdersState extends State<SupplierOrders> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          leading: const AppBarBackButton(),
          title: const AppBarTitle(title: 'Orders'),
          bottom: TabBar(
            indicatorColor: Colors.orange.shade800,
            indicatorWeight: 3,
            tabs: const [
              RepeatedTab(
                label: 'preparing',
              ),
              RepeatedTab(label: 'shipping'),
              RepeatedTab(
                label: 'delivered',
              )
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            Preparing(),
            Shipping(),
            Delivered(),
          ],
        ),
      ),
    );
  }
}

class RepeatedTab extends StatelessWidget {
  final String label;
  const RepeatedTab({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Center(
        child: Text(
          label,
          style: const TextStyle(color: Colors.grey),
        ),
      ),
    );
  }
}
