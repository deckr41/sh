CREATE TABLE IF NOT EXISTS memories (
  id TEXT NOT NULL PRIMARY KEY,
  user_id TEXT NOT NULL,
  embedding_id TEXT DEFAULT NULL,

  priority INTEGER NOT NULL DEFAULT 0,
  content TEXT NOT NULL,
  meta TEXT NOT NULL DEFAULT '{}',

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (embedding_id) REFERENCES embeddings(id)
);

-- FK indexes
CREATE INDEX IF NOT EXISTS memories_user_id ON memories(user_id);
CREATE INDEX IF NOT EXISTS memories_embedding_id ON memories(embedding_id);

-- Update "updated_at" when a record is updated
DROP TRIGGER IF EXISTS memories_UPDATE_updated_at;
CREATE TRIGGER memories_UPDATE_updated_at
AFTER UPDATE ON memories
BEGIN
  UPDATE memories
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = NEW.id;
END;
