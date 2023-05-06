import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youui/components/navigation.dart';
import 'package:youui/layout/home/home.dart';

import 'bloc/home_bloc.dart';

class HomeLayout extends StatelessWidget {
  final List<Widget> actions;
  final Widget child;

  const HomeLayout({Key? key, required this.child, this.actions = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return ResponsiveTabPageLayout(
          onTabIndexChange: (index) {
            context.read<HomeBloc>().add(IndexChangedEvent(index: index));
          },
          tabIndex: state.tabIndex,
          navItems: [
            NavigationBarItem(icon: const Icon(Icons.home), label: "Home"),
            NavigationBarItem(
                icon: const Icon(Icons.photo_album), label: "Album"),
            NavigationBarItem(icon: const Icon(Icons.person), label: "User")
          ],
          verticalNavHeight: 320,
          action: Column(
            children: actions,
          ),
          appbar: AppBar(
            title: const Text("YouPhoto"),
            elevation: 0,
            actions: actions,
          ),
          body: child,
        );
      },
    );
  }
}
