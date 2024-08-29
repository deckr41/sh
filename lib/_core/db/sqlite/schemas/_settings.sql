CREATE TABLE IF NOT EXISTS _settings (
  id TEXT PRIMARY KEY,
  key TEXT NOT NULL UNIQUE,
  value TEXT, 
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Update "updated_at" when a record is updated
DROP TRIGGER IF EXISTS _settings_UPDATE_updated_at; 
CREATE TRIGGER _settings_UPDATE_updated_at
AFTER UPDATE ON _settings
BEGIN
    UPDATE _settings
    SET updated_at = CURRENT_TIMESTAMP
    WHERE id = NEW.id;
END;
