import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:field_staff_app/core/routes/app_routes.dart';
import 'package:field_staff_app/core/theme/app_colors.dart';
import 'package:field_staff_app/core/theme/app_text_styles.dart';
import 'package:field_staff_app/models/route_model.dart';
import 'package:field_staff_app/viewmodels/route_list_viewmodel.dart';
import 'package:field_staff_app/widgets/activity_card.dart';
import 'package:field_staff_app/widgets/app_app_bar.dart';
import 'package:field_staff_app/widgets/loading_error_widgets.dart';

class RouteListView extends StatefulWidget {
  const RouteListView({super.key});

  @override
  State<RouteListView> createState() => _RouteListViewState();
}

class _RouteListViewState extends State<RouteListView> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RouteListViewModel>().loadRoutes();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<RouteListViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            AppScreenHeader(
              title: 'My Route',
              onBack: () => Navigator.pop(context),
              trailing: const ProfileAvatarButton(),
            ),
            if (!vm.canAccessRoutes)
              Padding(
                padding: const EdgeInsets.all(16),
                child: ErrorStateWidget(
                  message: vm.errorMessage ??
                      'Complete Mark In and Mark Out to view your route.',
                  onRetry: () => Navigator.pop(context),
                ),
              )
            else ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(13, 8, 13, 0),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(7),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: vm.setSearchQuery,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      hintStyle: AppTextStyles.bodyRegular,
                      prefixIcon: const Icon(Icons.search, size: 20),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),
              Expanded(child: _buildList(vm)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildList(RouteListViewModel vm) {
    if (vm.isLoading && vm.routes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.errorMessage != null && vm.routes.isEmpty) {
      return ErrorStateWidget(message: vm.errorMessage!, onRetry: vm.loadRoutes);
    }
    if (vm.routes.isEmpty) {
      return const EmptyStateWidget(message: 'No routes found.');
    }

    return RefreshIndicator(
      onRefresh: vm.loadRoutes,
      child: ListView.builder(
        padding: const EdgeInsets.all(13),
        itemCount: vm.routes.length,
        itemBuilder: (context, index) {
          final route = vm.routes[index];
          return ActivityCard(
            date: route.date,
            subtitle: route.subtitle,
            onTap: () => _openMap(route),
          );
        },
      ),
    );
  }

  void _openMap(RouteModel route) {
    Navigator.pushNamed(
      context,
      AppRoutes.routeMap,
      arguments: route,
    );
  }
}
