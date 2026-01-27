import 'dart:math' as math;
import 'package:flutter/material.dart';
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
      child: const MotaungHub(),
    ),
  );
}

class MotaungHub extends StatelessWidget {
  const MotaungHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Motaung Hub',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
            ),
          ),
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1A1A1A),
              foregroundColor: Colors.white,
              elevation: 0,
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

  Website({
    required this.id,
    required this.name,
    required this.url,
    required this.description,
    required this.icon,
    required this.color,
    required this.category,
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
  ThemeMode _themeMode = ThemeMode.system;

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
  // ✅ UPDATED SITES LIST - Clean URLs, no trailing spaces!
  final List<Website> websites = [
    // Your New Sites
    Website(
      id: 1,
      name: 'MovieTree',
      url: 'https://movietree.vercel.app',
      description: 'Discover great movies and shows',
      icon: Icons.movie,
      color: Colors.red,
      category: 'Entertainment',
    ),
    Website(
      id: 2,
      name: 'Motaung.inc',
      url: 'https://motaunginc.vercel.app',
      description: 'AI-powered business solutions',
      icon: Icons.business,
      color: Colors.purple,
      category: 'Business',
    ),
    Website(
      id: 3,
      name: 'Portfolio',
      url: 'https://motaungmandla.github.io',
      description: 'My professional work & projects',
      icon: Icons.person,
      color: Colors.blue,
      category: 'Professional',
    ),

    // Existing Sites (cleaned up)
    Website(
      id: 4,
      name: 'GitHub',
      url: 'https://github.com/motaungmandla',
      description: 'Open source projects & AI models',
      icon: Icons.code,
      color: Colors.black,
      category: 'Development',
    ),
    Website(
      id: 5,
      name: 'Tutoring',
      url: 'https://motaungmandla.vercel.app',
      description: 'Math, Physics, Python @ M90/course',
      icon: Icons.school,
      color: Colors.green,
      category: 'Education',
    ),
    Website(
      id: 6,
      name: 'Personal Gallery',
      url: 'https://motaung.gt.tc',
      description: 'Private photo vault',
      icon: Icons.photo_library,
      color: Colors.pink,
      category: 'Personal',
    ),

    // Quick Tools (replaces Snake Game)
    Website(
      id: 7,
      name: 'Quick Tools',
      url: 'tools:quick',
      description: 'Useful utilities at your fingertips',
      icon: Icons.build,
      color: Colors.orange,
      category: 'Tools',
    ),
    Website(
      id: 8,
      name: 'Tic-Tac-Toe',
      url: 'game:tictactoe',
      description: 'Play vs AI or a friend',
      icon: Icons.grid_on,
      color: Colors.teal,
      category: 'Games',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final tracker = Provider.of<VisitTracker>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motaung Hub', style: TextStyle(fontWeight: FontWeight.bold)),
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
          // Stats Banner
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.deepPurple, Colors.indigo]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStat(Icons.link, 'Sites', websites.length.toString()),
                _buildStat(Icons.remove_red_eye, 'Visits', tracker.totalVisits.toString()),
                _buildStat(Icons.share, 'Shares', tracker.totalShares.toString()),
              ],
            ),
          ),

          // Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
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

  Widget _buildStat(IconData icon, String label, String value) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }

  Widget _buildCard(Website site, VisitTracker tracker) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () async {
          if (site.url.startsWith('game:')) {
            if (site.name == 'Tic-Tac-Toe') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TicTacToeGame()));
            }
          } else if (site.url.startsWith('tools:')) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const QuickToolsScreen()));
          } else {
            tracker.recordVisit();
            await _launchUrl(site.url); // ✅ Await properly
          }
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: site.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(site.icon, color: site.color),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                    icon: const Icon(Icons.share, size: 18),
                    onPressed: () {
                      if (!site.url.startsWith('game:') && !site.url.startsWith('tools:')) {
                        tracker.recordShare();
                        Share.share('Check out ${site.name}: ${site.url}');
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(site.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                site.description,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              if (!site.url.startsWith('game:') && !site.url.startsWith('tools:'))
                Text(
                  site.url.replaceAll(RegExp(r'https?://'), ''),
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 10),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    // ✅ CRITICAL FIX: Proper URL validation and error handling
    try {
      final uri = Uri.parse(urlString.trim());
      
      // Validate URI scheme
      if (uri.scheme.isEmpty) {
        throw Exception('Invalid URL scheme');
      }
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Force external browser
        );
      } else {
        throw Exception('Cannot launch URL');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to open: $urlString'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
}

// ===== QUICK TOOLS SCREEN (REPLACES SNAKE GAME) =====
class QuickToolsScreen extends StatelessWidget {
  const QuickToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quick Tools')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildToolCard(
              context,
              icon: Icons.copy,
              title: 'Copy Text',
              description: 'Copy any text to clipboard',
              onTap: () => _showCopyDialog(context),
            ),
            _buildToolCard(
              context,
              icon: Icons.calculate,
              title: 'Calculator',
              description: 'Quick calculations',
              onTap: () => _launchExternalApp(context, 'calculator'),
            ),
            _buildToolCard(
              context,
              icon: Icons.timer,
              title: 'Timer',
              description: 'Set countdown timers',
              onTap: () => _launchExternalApp(context, 'timer'),
            ),
            _buildToolCard(
              context,
              icon: Icons.settings,
              title: 'Settings',
              description: 'Device settings',
              onTap: () => _launchExternalApp(context, 'settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolCard(BuildContext context, {required IconData icon, required String title, required String description, required VoidCallback onTap}) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(description, style: TextStyle(color: Colors.grey[600]), textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  void _showCopyDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Copy Text'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter text to copy'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: controller.text));
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Text copied!')),
                );
              }
              Navigator.pop(ctx);
            },
            child: const Text('Copy'),
          ),
        ],
      ),
    );
  }

  void _launchExternalApp(BuildContext context, String appType) {
    // Note: Direct app launching requires platform-specific code
    // For now, show a helpful message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $appType... (Use your device\'s native app)'),
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }
}

// ===== TIC-TAC-TOE (Kept as-is) =====
class TicTacToeGame extends StatefulWidget {
  const TicTacToeGame({super.key});

  @override
  State<TicTacToeGame> createState() => _TicTacToeGameState();
}

class _TicTacToeGameState extends State<TicTacToeGame> {
  List<String> board = List.filled(9, '');
  bool isPlayerX = true;
  String winner = '';

  void makeMove(int index) {
    if (board[index].isEmpty && winner.isEmpty) {
      setState(() {
        board[index] = isPlayerX ? 'X' : 'O';
        isPlayerX = !isPlayerX;
        winner = checkWinner();
      });
    }
  }

  String checkWinner() {
    const winPatterns = [
      [0, 1, 2], [3, 4, 5], [6, 7, 8],
      [0, 3, 6], [1, 4, 7], [2, 5, 8],
      [0, 4, 8], [2, 4, 6]
    ];

    for (final pattern in winPatterns) {
      if (board[pattern[0]] == board[pattern[1]] &&
          board[pattern[1]] == board[pattern[2]] &&
          board[pattern[0]] != '') {
        return board[pattern[0]];
      }
    }

    if (!board.contains('')) return 'Draw';
    return '';
  }

  void resetGame() {
    setState(() {
      board = List.filled(9, '');
      isPlayerX = true;
      winner = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tic-Tac-Toe')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              winner.isEmpty
                  ? 'Player ${isPlayerX ? 'X' : 'O'}\'s turn'
                  : winner == 'Draw' ? 'It\'s a draw!' : 'Player $winner wins!',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: 9,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => makeMove(index),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        board[index],
                        style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: resetGame,
              child: const Text('New Game'),
            ),
          ),
        ],
      ),
    );
  }
}
