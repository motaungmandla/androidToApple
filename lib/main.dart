import 'dart:math' as math; // ✅ FIXED: Proper alias to avoid conflict with Random class
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
  final List<Website> websites = [
    // Professional
    Website(
      id: 1,
      name: 'Portfolio',
      url: 'https://motaungmandla.github.io',
      description: 'My professional work & case studies',
      icon: Icons.person,
      color: Colors.blue,
      category: 'Professional',
    ),
    Website(
      id: 2,
      name: 'GitHub',
      url: 'https://github.com/motaungmandla',
      description: 'Open source projects & AI models',
      icon: Icons.code,
      color: Colors.black,
      category: 'Professional',
    ),
    Website(
      id: 3,
      name: 'Client Portal',
      url: 'https://motaunginc.vercel.app',
      description: 'AI tools for business',
      icon: Icons.business,
      color: Colors.purple,
      category: 'Professional',
    ),

    // Services
    Website(
      id: 4,
      name: 'Tutoring',
      url: 'https://motaungmandla.vercel.app',
      description: 'Math, Physics, Python @ M90/course',
      icon: Icons.school,
      color: Colors.green,
      category: 'Services',
    ),
    Website(
      id: 5,
      name: 'Personal Gallery',
      url: 'https://motaung.gt.tc',
      description: 'Private photo vault',
      icon: Icons.photo_library,
      color: Colors.pink,
      category: 'Services',
    ),

    // Fun Zone 🎮
    Website(
      id: 6,
      name: 'Snake Game',
      url: 'game:snake',
      description: 'Classic retro snake challenge!',
      icon: Icons.games,
      color: Colors.amber,
      category: 'Fun Zone',
    ),
    Website(
      id: 7,
      name: 'Tic-Tac-Toe',
      url: 'game:tictactoe',
      description: 'Play vs AI or a friend',
      icon: Icons.grid_on,
      color: Colors.teal,
      category: 'Fun Zone',
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
            if (site.name == 'Snake Game') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SnakeGame()));
            } else if (site.name == 'Tic-Tac-Toe') {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const TicTacToeGame()));
            }
          } else {
            tracker.recordVisit();
            _launchUrl(site.url.trim());
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
                      if (!site.url.startsWith('game:')) {
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
              if (!site.url.startsWith('game:'))
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

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url.trim()); // ✅ FIXED: Trim here too for safety
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to open $url')),
      );
    }
  }
}

// ===== SNAKE GAME =====
class SnakeGame extends StatefulWidget {
  const SnakeGame({super.key});

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> with TickerProviderStateMixin {
  static const int gridSize = 15;
  static const double cellSize = 20.0;
  late List<Offset> snake;
  late Offset food;
  late Direction direction;
  late AnimationController controller;
  bool isPlaying = false;
  int score = 0;

  @override
  void initState() {
    super.initState();
    resetGame();
    controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        if (isPlaying) moveSnake();
      })
      ..repeat();
  }

  @override
  void dispose() {
    controller.dispose(); // ✅ FIXED: Prevent memory leak
    super.dispose();
  }

  void resetGame() {
    setState(() {
      snake = [const Offset(7, 7)];
      food = _randomFood();
      direction = Direction.right;
      isPlaying = true;
      score = 0;
    });
  }

  Offset _randomFood() {
    // ✅ FIXED: Use math.Random() instead of broken Random() prefix
    return Offset(
      (math.Random().nextDouble() * gridSize).toInt().toDouble(),
      (math.Random().nextDouble() * gridSize).toInt().toDouble(),
    );
  }

  void moveSnake() {
    if (!isPlaying) return;

    final head = snake.first;
    Offset newHead;

    switch (direction) {
      case Direction.up:
        newHead = Offset(head.dx, (head.dy - 1) % gridSize);
      case Direction.down:
        newHead = Offset(head.dx, (head.dy + 1) % gridSize);
      case Direction.left:
        newHead = Offset((head.dx - 1) % gridSize, head.dy);
      case Direction.right:
        newHead = Offset((head.dx + 1) % gridSize, head.dy);
    }

    // Wrap around screen edges
    newHead = Offset(
      (newHead.dx + gridSize) % gridSize,
      (newHead.dy + gridSize) % gridSize,
    );

    // Check self-collision
    if (snake.contains(newHead)) {
      _gameOver();
      return;
    }

    setState(() {
      snake.insert(0, newHead);
      if (newHead == food) {
        food = _randomFood();
        score += 10;
      } else {
        snake.removeLast();
      }
    });
  }

  void _gameOver() {
    isPlaying = false;
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Game Over!'),
        content: Text('Your score: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              resetGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Snake Game')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Score: $score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Exit'),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (details.delta.dy > 0 && direction != Direction.up) {
                  direction = Direction.down;
                } else if (details.delta.dy < 0 && direction != Direction.down) {
                  direction = Direction.up;
                }
              },
              onHorizontalDragUpdate: (details) {
                if (details.delta.dx > 0 && direction != Direction.left) {
                  direction = Direction.right;
                } else if (details.delta.dx < 0 && direction != Direction.right) {
                  direction = Direction.left;
                }
              },
              child: Container(
                color: Colors.grey[900],
                child: CustomPaint(
                  size: Size(gridSize * cellSize, gridSize * cellSize),
                  painter: SnakePainter(snake: snake, food: food, cellSize: cellSize),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8),
            child: Text('Swipe to control the snake!', style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }
}

class SnakePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset food;
  final double cellSize;

  SnakePainter({required this.snake, required this.food, required this.cellSize});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    // Draw food
    paint.color = Colors.red;
    canvas.drawCircle(
      Offset(food.dx * cellSize + cellSize / 2, food.dy * cellSize + cellSize / 2),
      cellSize / 2,
      paint,
    );

    // Draw snake
    paint.color = Colors.green;
    for (final segment in snake) {
      canvas.drawRect(
        Rect.fromLTWH(
          segment.dx * cellSize,
          segment.dy * cellSize,
          cellSize,
          cellSize,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

enum Direction { up, down, left, right }

// ===== TIC-TAC-TOE =====
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
      [0, 1, 2], [3, 4, 5], [6, 7, 8], // rows
      [0, 3, 6], [1, 4, 7], [2, 5, 8], // cols
      [0, 4, 8], [2, 4, 6]             // diagonals
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
