import 'package:bitstagram/provider/explore_provider.dart';
import 'package:bitstagram/provider/feed_provider.dart';
import 'package:bitstagram/provider/followers_provider.dart';
import 'package:bitstagram/provider/post_provider.dart';
import 'package:bitstagram/provider/user_provider.dart';
import 'package:bitstagram/provider/video_provider.dart';
import 'package:bitstagram/views/bottom_bar/bottom_bar_page.dart';
import 'package:bitstagram/widgets/auth_state_wrapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bitstagram/supabase/my_supabase.dart';
import 'package:bitstagram/theme/retro_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/navigation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
    authOptions:
        const FlutterAuthClientOptions(authFlowType: AuthFlowType.pkce),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FeedProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ExploreProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => FollowersProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => VideoControllerProvider(),
        )
      ],
      child: MaterialApp(
        theme: createRetroBlackTheme(),
        initialRoute: AuthStateWrapper.route,
        onGenerateRoute: Navigation.generateRoute,
      ),
    );
  }
}
