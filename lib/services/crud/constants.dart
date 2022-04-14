const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const textColumn = 'text';
const isSyncedColumn = 'synced_with_cloud';

const dbName = 'noteys.db';
const notesTable = 'Notes';
const userTable = 'Users';

const createUserTable = '''
  CREATE TABLE IF NOT EXISTS "$userTable" (
	  "$idColumn"	INTEGER NOT NULL,
	  "$emailColumn"	TEXT NOT NULL UNIQUE,
	  PRIMARY KEY("$idColumn" AUTOINCREMENT)
);
''';
const createNotesTable = '''
CREATE TABLE IF NOT EXISTS "$notesTable" (
	"$idColumn"	INTEGER NOT NULL,
	"$userIdColumn" INTEGER NOT NULL,
	"$textColumn"	TEXT,
	"$isSyncedColumn"	INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY("$idColumn" AUTOINCREMENT),
	FOREIGN KEY("$userIdColumn") REFERENCES "$userTable"("$userIdColumn")
	
);
''';
