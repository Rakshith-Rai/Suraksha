import 'package:suraksha/model/contactsm.dart';
import 'package:suraksha/model/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseHelper {
  // Contact Table and Columns
  String contactTable = 'contact_table';
  String colId = 'id';
  String colContactName = 'name';
  String colContactNumber = 'number';

  // User Table and Columns
  String userTable = 'user_table';
  String colUserId = 'id';
  String colUsername = 'username';
  String colEmail = 'email';
  String colPassword = 'password';
  String colFullName = 'fullName';
  String colDateOfBirth = 'dateOfBirth';
  String colGender = 'gender';
  String colHomeAddress = 'homeAddress';
  String colWorkAddress = 'workAddress';
  String colNearestSafePlace = 'nearestSafePlace';
  String colPhoneNumber = 'phoneNumber';
  String colEmergencyContact = 'emergencyContact';
  String colMedicalConditions = 'medicalConditions';

  // Singleton pattern
  DatabaseHelper._createInstance();

  static DatabaseHelper? _databaseHelper;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper!;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database!;
  }

  // Initialize the database
  Future<Database> initializeDatabase() async {
    String directoryPath = await getDatabasesPath();
    String dbLocation = join(directoryPath, 'suraksha.db');

    var contactDatabase = await openDatabase(
      dbLocation,
      version: 2,
      onCreate: _createDbTable,
      onUpgrade: _onUpgrade,
    );
    return contactDatabase;
  }

  // Create Tables (Contact and User Tables)
  void _createDbTable(Database db, int newVersion) async {
    // Create Contact Table
    await db.execute('''
      CREATE TABLE $contactTable(
        $colId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colContactName TEXT, 
        $colContactNumber TEXT
      )
    ''');

    // Create User Table
    await db.execute('''
      CREATE TABLE $userTable(
        $colUserId INTEGER PRIMARY KEY AUTOINCREMENT, 
        $colUsername TEXT NOT NULL, 
        $colEmail TEXT NOT NULL UNIQUE, 
        $colPassword TEXT NOT NULL,
        $colFullName TEXT, 
        $colDateOfBirth TEXT,
        $colGender TEXT,
        $colHomeAddress TEXT,
        $colWorkAddress TEXT,
        $colNearestSafePlace TEXT,
        $colPhoneNumber TEXT,
        $colEmergencyContact TEXT,
        $colMedicalConditions TEXT
      )
    ''');
  }

  // Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE $userTable ADD COLUMN $colFullName TEXT;');
      await db.execute('ALTER TABLE $userTable ADD COLUMN $colDateOfBirth TEXT;');
      await db.execute('ALTER TABLE $userTable ADD COLUMN $colGender TEXT;');
      await db.execute('ALTER TABLE $userTable ADD COLUMN $colHomeAddress TEXT;');
      await db.execute('ALTER TABLE $userTable ADD COLUMN $colWorkAddress TEXT;');
      await db.execute('ALTER TABLE $userTable ADD COLUMN $colNearestSafePlace TEXT;');
      await db.execute('ALTER TABLE $userTable ADD COLUMN $colPhoneNumber TEXT;');
      await db.execute('ALTER TABLE $userTable ADD COLUMN $colEmergencyContact TEXT;');
      await db.execute('ALTER TABLE $userTable ADD COLUMN $colMedicalConditions TEXT;');
    }
  }

  // Function to hash passwords
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // ********* Contact Operations *********
  Future<List<Map<String, dynamic>>> getContactMapList() async {
    Database db = await this.database;
    return await db.rawQuery('SELECT * FROM $contactTable ORDER BY $colId ASC');
  }

  Future<int> insertContact(TContact contact) async {
    Database db = await this.database;
    return await db.insert(contactTable, contact.toMap());
  }

  Future<int> updateContact(TContact contact) async {
    Database db = await this.database;
    return await db.update(contactTable, contact.toMap(),
        where: '$colId = ?', whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    Database db = await this.database;
    return await db.rawDelete('DELETE FROM $contactTable WHERE $colId = $id');
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
    await db.rawQuery('SELECT COUNT(*) FROM $contactTable');
    return Sqflite.firstIntValue(x)!;
  }

  Future<List<TContact>> getContactList() async {
    var contactMapList = await getContactMapList();
    int count = contactMapList.length;
    List<TContact> contactList = <TContact>[];
    for (int i = 0; i < count; i++) {
      contactList.add(TContact.fromMapObject(contactMapList[i]));
    }
    return contactList;
  }

  // ********* User Operations (Login/Registration) *********

  // Register new user
  Future<int> insertUser(User user) async {
    Database db = await this.database;
    user.password = hashPassword(user.password); // Hash the password before saving
    return await db.insert(userTable, user.toMap());
  }

  // Update user details
  Future<int> updateUser(User user) async {
    Database db = await this.database;
    return await db.update(
      userTable,
      user.toMap(),
      where: '$colUserId = ?',
      whereArgs: [user.id],
    );
  }

  // Login user
  Future<User?> loginUser(String email, String password) async {
    String hashedPassword = hashPassword(password); // Hash the input password
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(
      userTable,
      where: '$colEmail = ? AND $colPassword = ?',
      whereArgs: [email, hashedPassword],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }

  // Check if email exists (for validation during registration)
  Future<bool> isEmailExist(String email) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(
      userTable,
      where: '$colEmail = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Fetch a user by email
  Future<User?> getUserByEmail(String email) async {
    Database db = await this.database;
    List<Map<String, dynamic>> result = await db.query(
      userTable,
      where: '$colEmail = ?',
      whereArgs: [email],
    );
    if (result.isNotEmpty) {
      return User.fromMap(result.first);
    }
    return null;
  }
}
