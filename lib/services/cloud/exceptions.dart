class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateNote implements CloudStorageException {}

class CouldNotGetAllNotes implements CloudStorageException {}

class CouldNotUpdateNote implements CloudStorageException {}

class CouldNotDeleteNote implements CloudStorageException {}
