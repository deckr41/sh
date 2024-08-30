CREATE TABLE IF NOT EXISTS embeddings (
  id TEXT NOT NULL PRIMARY KEY,
  data TEXT NOT NULL,

  resource_type TEXT NOT NULL,
  resource_id TEXT NOT NULL,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Update "updated_at" when a record is updated
DROP TRIGGER IF EXISTS embeddings_UPDATE_updated_at;
CREATE TRIGGER embeddings_UPDATE_updated_at
AFTER UPDATE ON embeddings
BEGIN
  UPDATE embeddings
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = NEW.id;
END;
