// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// ignore_for_file: unnecessary_null_comparison, iterable_contains_unrelated_type
import 'package:flutter/material.dart';
import '../privacyPolicy.dart';
import 'appUpdate.dart';
import '../src/view/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../src/controller/loginController.dart';
import '../src/view/noInternet.dart';
import '../constants.dart';
import '../src/view/login.dart';
import '../main.dart';
import 'CustomTransitionPage.dart';
import 'connection.dart';
import 'theme.dart';

const String homePage = "/home";
const String loginPage = "/";

routesData() {
  final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        name: '/',
        redirect: (context, state) {
          return token != null
              ? baseSideMenu.isNotEmpty
                  ? baseSideMenu[0].route
                  : "/dashboard"
              : '/login';
        },
      ),
      GoRoute(
        path: '/dashboard',
        name: '/dashboard',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
          final isUpdateAvailable =
              Provider.of<AppUpgradeProvider>(context).isUpdateAvailable;
          bottomIndex = baseSideMenu.isNotEmpty
              ? baseSideMenu
                  .where((e) => e.route == "/dashboard")
                  .toList()
                  .first
                  .bottomIndex
              : 0;
          storage.write(key: "bottom_index", value: "$bottomIndex");
          var child = (isOnline != null && !isOnline)
              ? const NoInternet()
              : (isUpdateAvailable)
                  ? const AppUpdate()
                  : bottomIndex < 3
                      ? const MyApp()
                      : const Dashboard();
          return customTransitionPage(state.pageKey, child);
        },
      ),
      GoRoute(
        path: '/login',
        name: '/login',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
          var isUpdateAvailable =
              Provider.of<AppUpgradeProvider>(context).isUpdateAvailable;
          bottomIndex = 0;
          storage.write(key: "bottom_index", value: "$bottomIndex");
          var child = (isOnline != null && !isOnline)
              ? const NoInternet()
              : (isUpdateAvailable)
                  ? const AppUpdate()
                  : const LoginLive();
          return customTransitionPage(state.pageKey, child);
        },
      ),
      GoRoute(
        path: '/privacy-policy',
        name: '/privacy-policy',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
          final isUpdateAvailable =
              Provider.of<AppUpgradeProvider>(context).isUpdateAvailable;
          var child = (isOnline != null && !isOnline)
              ? const NoInternet()
              : (isUpdateAvailable)
                  ? const AppUpdate()
                  : const Privacy();
          return customTransitionPage(state.pageKey, child);
        },
      ),
      GoRoute(
        path: '/profile',
        name: '/profile',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
          final isUpdateAvailable =
              Provider.of<AppUpgradeProvider>(context).isUpdateAvailable;
          bottomIndex = baseSideMenu.isNotEmpty
              ? baseSideMenu
                  .where((e) => e.route == "/profile")
                  .toList()
                  .first
                  .bottomIndex
              : 3;
          storage.write(key: "bottom_index", value: "$bottomIndex");

          var child = (isOnline != null && !isOnline)
              ? const NoInternet()
              : (isUpdateAvailable)
                  ? const AppUpdate()
                  : token != null
                      ? bottomIndex < 3
                          ? const MyApp()
                          : const MyApp()
                      : const LoginLive();
          return customTransitionPage(state.pageKey, child);
        },
      ),
      GoRoute(
        path: '/certificates',
        name: '/certificates',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
          final isUpdateAvailable =
              Provider.of<AppUpgradeProvider>(context).isUpdateAvailable;
          bottomIndex = baseSideMenu.isNotEmpty
              ? baseSideMenu
                  .where((e) => e.route == "/certificates")
                  .toList()
                  .first
                  .bottomIndex
              : 2;
          storage.write(key: "bottom_index", value: "$bottomIndex");
          var child = (isOnline != null && !isOnline)
              ? const NoInternet()
              : (isUpdateAvailable)
                  ? const AppUpdate()
                  : token != null
                      ? bottomIndex < 3
                          ? const MyApp()
                          : const MyApp()
                      : const LoginLive();
          return customTransitionPage(state.pageKey, child);
        },
      ),
      GoRoute(
        path: '/nsdc',
        name: '/nsdc',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
          final isUpdateAvailable =
              Provider.of<AppUpgradeProvider>(context).isUpdateAvailable;
          var child = (isOnline != null && !isOnline)
              ? const NoInternet()
              : (isUpdateAvailable)
                  ? const AppUpdate()
                  : token != null
                      ? const MyApp()
                      : const LoginLive();
          return customTransitionPage(state.pageKey, child);
        },
      ),
      GoRoute(
        path: '/feedback',
        name: '/feedback',
        pageBuilder: (BuildContext context, GoRouterState state) {
          final isOnline = Provider.of<ConnectivityProvider>(context).isOnline;
          final isUpdateAvailable =
              Provider.of<AppUpgradeProvider>(context).isUpdateAvailable;

          var child = (isOnline != null && !isOnline)
              ? const NoInternet()
              : (isUpdateAvailable)
                  ? const AppUpdate()
                  : token != null
                      ? const MyApp()
                      : const LoginLive();
          return customTransitionPage(state.pageKey, child);
        },
      ),
      GoRoute(
        path: '/noInternet',
        name: '/noInternet',
        pageBuilder: (BuildContext context, GoRouterState state) {
          var child = const NoInternet();
          return customTransitionPage(state.pageKey, child);
        },
      ),
      GoRoute(
        path: '/appUpdate',
        name: '/appUpdate',
        pageBuilder: (BuildContext context, GoRouterState state) {
          var child = const AppUpdate();
          return customTransitionPage(state.pageKey, child);
        },
      ),
      GoRoute(
        path: '/logout',
        name: '/logout',
        redirect: (context, state) {
          LoginController().logout();
          return '/login';
        },
      ),
    ],
  );
  return router;
}
