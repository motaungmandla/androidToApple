import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => VisitTracker()),
      ],
      child: const AllianceDemoHub(),
    ),
  );
}

class AllianceDemoHub extends StatelessWidget {
  const AllianceDemoHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Alliance Demo Hub',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: Colors.red[700],
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.red[700]!,
              primary: Colors.red[700]!,
              secondary: Colors.red[400]!,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: Colors.red[700],
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            // ✅ FIX 1: Use CardThemeData instead of CardTheme widget
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            primaryColor: Colors.red[700],
            colorScheme: ColorScheme.dark(
              primary: Colors.red[400]!,
              secondary: Colors.red[300]!,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF8B0000),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            cardTheme: CardThemeData(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}

// ===== WEBSITE MODEL =====
class Website {
  final int id;
  final String name;
  final String url;
  final String description;
  final IconData icon;
  final Color color;
  final String category;
  final String? badge;

  Website({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
    this.badge,
  });
}

// ===== VISIT TRACKER =====
class VisitTracker with ChangeNotifier {
  int totalVisits = 0;
  int totalShares = 0;

  void recordVisit() {
    totalVisits++;
    notifyListeners();
  }

  void recordShare() {
    totalShares++;
    notifyListeners();
  }
}

// ===== THEME PROVIDER =====
class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

// ===== HOME SCREEN =====
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Website> websites = [
    Website(
      id: 0,
      name: 'Alliance Insurance',
      url: 'https://www.alliance.co.ls/',
      description: 'Visit the official Alliance Insurance Lesotho website',
      icon: Icons.public,
      color: Colors.red[700]!,
      category: 'Official',
      badge: 'Official Site',
    ),
    Website(
      id: 1,
      name: 'AI Chat Assistant',
      url: 'https://huggingface.co/spaces/MandlaZwane/motaunginc',
      description: 'Working contextual chatbot - see it in action!',
      icon: Icons.chat_bubble,
      color: Colors.red[700]!,
      category: 'AI/ML',
      badge: 'Live Demo',
    ),
    Website(
      id: 2,
      name: 'Bot Demo Video',
      url: 'https://youtu.be/n6Yh9bJsIkY',
      description: 'Watch the chatbot handle real conversations',
      icon: Icons.video_library,
      color: Colors.red[600]!,
      category: 'AI/ML',
    ),
    Website(
      id: 3,
      name: 'NLP Publication',
      url: 'https://youtu.be/GoXAQVTiv8Q?si=6CtfyvFk3OLDCznz',
      description: 'Published paper & presentation on NLP work',
      icon: Icons.article,
      color: Colors.deepPurple,
      category: 'Research',
      badge: 'Published',
    ),
    Website(
      id: 4,
      name: 'ASR Project',
      url: 'https://youtu.be/GoXAQVTiv8Q?si=6CtfyvFk3OLDCznz',
      description: 'Sesotho speech recognition - seeking funding to deploy for our nation',
      icon: Icons.mic,
      color: Colors.orange,
      category: 'AI/ML',
      badge: 'Needs Support',
    ),
    Website(
      id: 5,
      name: 'MovieTree API',
      url: 'https://movietree.vercel.app',
      description: 'TheMovieDB API integration - proves API expertise',
      icon: Icons.api,
      color: Colors.blue,
      category: 'Development',
      badge: 'API Demo',
    ),
    Website(
      id: 6,
      name: 'GitHub Profile',
      url: 'https://github.com/motaungmandla',
      description: 'Open source projects & AI models',
      icon: Icons.code,
      color: Colors.black87,
      category: 'Development',
    ),
    Website(
      id: 7,
      name: 'Contact Me',
      url: 'mailto:maxphin21@gmail.com',
      description: 'Let\'s discuss how I can add value to Alliance',
      icon: Icons.email,
      color: Colors.red[700]!,
      category: 'Professional',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tracker = Provider.of<VisitTracker>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            // ✅ FIX 2: Replace Icons.sharp with Icons.shield (valid icon)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.shield,
                color: Colors.red[700],
                size: 24,
              ),
            ),
            const SizedBox(width: 8),
            const Text('Alliance Demo Hub', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark 
                ? Icons.wb_sunny 
                : Icons.nightlight),
            onPressed: () => themeProvider.toggleTheme(),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[700]!, Colors.red[400]!],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.favorite, color: Colors.white, size: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Building AI for Sesotho Speakers',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'This role would fund my ASR project to deploy inclusive AI models for our nation.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.95),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.red[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(Icons.link, 'Demos', websites.length.toString(), Colors.red[700]!),
                _buildStat(Icons.remove_red_eye, 'Visits', tracker.totalVisits.toString(), Colors.red[700]!),
                _buildStat(Icons.share, 'Shares', tracker.totalShares.toString(), Colors.red[700]!),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: websites.length,
              itemBuilder: (context, index) {
                return _buildCard(websites[index], tracker);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Website site, VisitTracker tracker) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () async {
          tracker.recordVisit();
          await _launchUrl(site.url);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: site.badge != null
                ? LinearGradient(
                    colors: [
                      site.color.withOpacity(0.05),
                      site.color.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: site.color.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(site.icon, color: site.color, size: 24),
                    ),
                    const Spacer(),
                    if (site.badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: site.color,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          site.badge!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  site.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  site.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 11,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        site.category,
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      splashRadius: 18,
                      icon: Icon(Icons.share, size: 16, color: Colors.grey[600]),
                      onPressed: () {
                        tracker.recordShare();
                        Share.share(
                          'Check out ${site.name}: ${site.url}\n\nPart of Motaung Mandla\'s Alliance Insurance application portfolio.',
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    try {
      final uri = Uri.parse(urlString.trim());
      if (uri.scheme.isEmpty) {
        throw Exception('Invalid URL scheme');
      }
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        throw Exception('Cannot launch URL');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open: ${e.toString()}'),
          backgroundColor: Colors.red[700],
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }
}
