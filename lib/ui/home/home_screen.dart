import 'package:firebase_task/ui/common/app_loader.dart';
import 'package:firebase_task/ui/common/app_text_field.dart';
import 'package:firebase_task/ui/common/common_app_bar.dart';
import 'package:firebase_task/ui/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_base_architecture_plugin/imports/core_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/dart_package_imports.dart';
import 'package:flutter_base_architecture_plugin/imports/extension_imports.dart';
import 'package:gap/gap.dart';

import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_contract.dart';
import '../../core/colors.dart';
import '../../core/constants.dart';
import '../../core/dimens.dart';
import '../../core/routes.dart';
import '../common/app_toast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeBloc, HomeScreen> {
  @override
  void initState() {
    super.initState();
    bloc.add(InitHomeEvent());
  }

  @override
  void onViewEvent(ViewAction event) {
    switch (event.runtimeType) {
      case const (DisplayMessage):
        buildHandleMessage(event as DisplayMessage);
        break;
      case const (NavigateScreen):
        buildHandleActionEvent(event as NavigateScreen);
        break;
    }
  }

  void buildHandleMessage(DisplayMessage displayMessage) {
    final message = displayMessage.message;
    final type = displayMessage.type;
    switch (type) {
      case DisplayMessageType.toast:
        context.showToast(AppToast(message: message!));
        break;
      default:
        break;
    }
  }

  void buildHandleActionEvent(NavigateScreen screen) async {
    switch (screen.target) {
      case AppRoutes.loginScreen:
        navigatorKey.currentContext?.pushAndRemoveUntil(
          settings: RouteSettings(name: screen.target),
          builder: (_) => const LoginScreen(),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonAppBar(
          title: 'Home',
          actions: [
            IconButton(
                onPressed: () =>
                    navigatorKey.currentContext?.pushAndRemoveUntil(
                      settings:
                          const RouteSettings(name: AppRoutes.loginScreen),
                      builder: (_) => const LoginScreen(),
                    ),
                icon: const Icon(Icons.logout_rounded))
          ],
        ),
        body: SafeArea(
            child: BlocProvider<HomeBloc>(
                create: (_) => bloc,
                child: BlocBuilder<HomeBloc, HomeData>(
                    builder: (_, __) => _MainContent(bloc: bloc)))));
  }
}

class _MainContent extends StatelessWidget {
  const _MainContent({required this.bloc});

  final HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (bloc.state.state) {
      case ScreenState.content:
        return _HomeContent(bloc: bloc);
      default:
        return const AppLoader();
    }
  }
}

class _HomeContent extends StatelessWidget {
  final HomeBloc bloc;

  const _HomeContent({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(Dimens.spaceSmall),
      child: Column(
        children: [
          _AddPostView(bloc: bloc),
          const Gap(Dimens.spaceLarge),
          Expanded(
              child: SingleChildScrollView(child: _PostListView(bloc: bloc)))
        ],
      ),
    );
  }
}

class _AddPostView extends StatelessWidget {
  final HomeBloc bloc;

  const _AddPostView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            labelText: 'Add Post',
            textEditingController: bloc.state.textController,
            onSubmitted: (p0) => bloc.add(AddPostEvent()),
          ),
        ),
        IconButton(
            onPressed: () => bloc.add(AddPostEvent()),
            icon: bloc.state.isPostUploading
                ? const SizedBox(
                    width: Dimens.iconXSmall,
                    height: Dimens.iconXSmall,
                    child: AppLoader())
                : const Icon(Icons.upload, color: AppColors.primaryBlue1))
      ],
    );
  }
}

class _PostListView extends StatelessWidget {
  final HomeBloc bloc;

  const _PostListView({required this.bloc});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: bloc.fetchDataEvent(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AppLoader();
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No posts yet"));
        }

        List<Map<String, dynamic>> posts = snapshot.data!;

        return ListView.builder(
          itemCount: posts.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final post = posts[index];
            return ListTile(
              title: Text(post["email"]),
              subtitle: Text(post["message"]),
              trailing: post["timestamp"] != null
                  ? Text(post["timestamp"].toDate().toString())
                  : const Text("No timestamp"),
            );
          },
        );
      },
    );
  }
}
