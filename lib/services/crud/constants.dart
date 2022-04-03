const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedColumn = 'synced_with_cloud';

const dbName = 'noteys.db';
const notesTable = 'Notes';
const userTable = 'Users';

const createUserTable = '''
  CREATE TABLE IF NOT EXISTS "Users" (
	  "id"	INTEGER NOT NULL,
	  "email"	TEXT NOT NULL UNIQUE,
	  PRIMARY KEY("id" AUTOINCREMENT)
);
''';
const createNotesTable = '''
CREATE TABLE IF NOT EXISTS "Notes" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	"synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	FOREIGN KEY("user_id") REFERENCES "Users"("id"),
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
