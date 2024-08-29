CREATE TABLE IF NOT EXISTS _migrations (
  id TEXT NOT NULL PRIMARY KEY,

  -- Name of the migration file, sorting will give us the order of execution
  name TEXT NOT NULL UNIQUE,

  -- Available values: pending, applied
  status TEXT NOT NULL DEFAULT 'pending',

  -- Timestamps for when the migration was started and finished
  started_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  finished_at DATETIME DEFAULT NULL
);

-- Set "finished_at" when a record is marked as "applied"
DROP TRIGGER IF EXISTS _migrations_UPDATE_finished_at;
CREATE TRIGGER _migrations_UPDATE_finished_at
AFTER UPDATE OF status ON _migrations
WHEN NEW.status = 'applied'
BEGIN
    UPDATE _migrations
    SET finished_at = CURRENT_TIMESTAMP
    WHERE id = NEW.id;
END;
