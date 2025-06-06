import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'study_planner.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createTables,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    await db.execute('''
      CREATE TABLE subjects (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        color INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        last_studied TEXT,
        total_study_time INTEGER DEFAULT 0,
        study_streak INTEGER DEFAULT 0,
        progress REAL DEFAULT 0.0
      )
    ''');

    await db.execute('''
      CREATE TABLE flashcards (
        id TEXT PRIMARY KEY,
        subject_id TEXT NOT NULL,
        question TEXT NOT NULL,
        answer TEXT NOT NULL,
        hint TEXT,
        tags TEXT,
        created_at TEXT NOT NULL,
        last_reviewed TEXT,
        next_review TEXT,
        review_count INTEGER DEFAULT 0,
        correct_count INTEGER DEFAULT 0,
        incorrect_count INTEGER DEFAULT 0,
        difficulty TEXT DEFAULT 'medium',
        ease_factor REAL DEFAULT 2.5,
        interval INTEGER DEFAULT 1,
        FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE study_sessions (
        id TEXT PRIMARY KEY,
        subject_id TEXT NOT NULL,
        type TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        duration INTEGER DEFAULT 0,
        cards_reviewed INTEGER DEFAULT 0,
        correct_answers INTEGER DEFAULT 0,
        incorrect_answers INTEGER DEFAULT 0,
        focus_score REAL DEFAULT 1.0,
        topics_studied TEXT,
        notes TEXT,
        FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE study_plans (
        id TEXT PRIMARY KEY,
        subject_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        start_date TEXT NOT NULL,
        due_date TEXT NOT NULL,
        status TEXT DEFAULT 'active',
        priority TEXT DEFAULT 'medium',
        estimated_duration INTEGER DEFAULT 60,
        actual_duration INTEGER DEFAULT 0,
        tasks TEXT,
        completed_tasks TEXT,
        created_at TEXT NOT NULL,
        completed_at TEXT,
        FOREIGN KEY (subject_id) REFERENCES subjects (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('CREATE INDEX idx_flashcards_subject_id ON flashcards(subject_id)');
    await db.execute('CREATE INDEX idx_flashcards_next_review ON flashcards(next_review)');
    await db.execute('CREATE INDEX idx_study_sessions_subject_id ON study_sessions(subject_id)');
    await db.execute('CREATE INDEX idx_study_sessions_start_time ON study_sessions(start_time)');
    await db.execute('CREATE INDEX idx_study_plans_subject_id ON study_plans(subject_id)');
    await db.execute('CREATE INDEX idx_study_plans_due_date ON study_plans(due_date)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here when schema changes
    if (oldVersion < newVersion) {
      // Add migration logic for future versions
    }
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  Future<void> deleteDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
} 