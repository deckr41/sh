CREATE TABLE IF NOT EXISTS providers (
  id TEXT NOT NULL PRIMARY KEY,
  slug TEXT NOT NULL UNIQUE,
  name TEXT NOT NULL,
  backend TEXT NOT NULL,
  model TEXT NOT NULL,

  max_input_token_count INTEGER NOT NULL,
  max_input_message_length INTEGER NOT NULL,
  max_output_token_count INTEGER NOT NULL,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Update "updated_at" when a record is updated
DROP TRIGGER IF EXISTS providers_UPDATE_updated_at;
CREATE TRIGGER providers_UPDATE_updated_at
AFTER UPDATE ON providers
BEGIN
  UPDATE providers
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = NEW.id;
END;
