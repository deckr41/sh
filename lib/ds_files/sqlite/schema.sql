---

CREATE TABLE IF NOT EXISTS ds_fs (
  id TEXT NOT NULL PRIMARY KEY,
  embeddings_id TEXT DEFAULT NULL,
  
  path TEXT NOT NULL,
  content TEXT NOT NULL,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (embeddings_id) REFERENCES Embeddings(id)
);

-- FK indexes
CREATE INDEX IF NOT EXISTS ds_fs_embeddings_id ON ds_fs(embeddings_id);

-- Update "updated_at" when a record is updated
DROP TRIGGER IF EXISTS ds_fs_UPDATE_updated_at;
CREATE TRIGGER ds_fs_UPDATE_updated_at
AFTER UPDATE ON ds_fs
BEGIN
  UPDATE ds_
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = NEW.id;
END;

---

CREATE TABLE IF NOT EXISTS ds_fs_settings (
  id TEXT NOT NULL PRIMARY KEY,
  path TEXT NOT NULL,
  should_watch BOOLEAN NOT NULL DEFAULT 0,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);
