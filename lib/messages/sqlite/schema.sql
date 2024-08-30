CREATE TABLE IF NOT EXISTS messages (
  id TEXT NOT NULL PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  user_id TEXT,
  agent_id TEXT,
  embedding_id TEXT DEFAULT NULL,

  weight INTEGER NOT NULL DEFAULT 0,
  content TEXT NOT NULL,
  role TEXT NOT NULL,

  provider TEXT,
  provider_data TEXT,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (agent_id) REFERENCES agents(id),
  FOREIGN KEY (embedding_id) REFERENCES embeddings(id),
  CHECK (
    (user_id IS NOT NULL AND agent_id IS NULL) OR (user_id IS NULL AND agent_id IS NOT NULL)
  )
);

-- FK indexes
CREATE INDEX IF NOT EXISTS messages_conversation_id ON messages(conversation_id);
CREATE INDEX IF NOT EXISTS messages_user_id ON messages(user_id);
CREATE INDEX IF NOT EXISTS messages_agent_id ON messages(agent_id);
CREATE INDEX IF NOT EXISTS messages_embedding_id ON messages(embedding_id);

-- Set "weight" when a new message is created. 
-- Set as the current highest weight + 1 based on all the messages attached 
-- to the same conversation
DROP TRIGGER IF EXISTS messages_INSERT_weight;
CREATE TRIGGER messages_INSERT_weight
AFTER INSERT ON messages
BEGIN
  UPDATE messages
  SET weight = (
    SELECT COALESCE(MAX(weight), 0) + 1
    FROM messages
    WHERE conversation_id = NEW.conversation_id
  )
  WHERE id = NEW.id;
END;

-- Update "updated_at" when a record is updated
DROP TRIGGER IF EXISTS messages_UPDATE_updated_at;
CREATE TRIGGER messages_UPDATE_updated_at
AFTER UPDATE ON messages
BEGIN
  UPDATE messages
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = NEW.id;
END;

-- Increment parent Conversation "messages_count" on INSERT
DROP TRIGGER IF EXISTS messages_INSERT_conversations_message_count;
CREATE TRIGGER messages_INSERT_conversations_message_count
AFTER INSERT ON messages
BEGIN
    UPDATE conversations
    SET messages_count = messages_count + 1
    WHERE id = NEW.conversation_id;
END;

-- Decrement parent Conversation "messages_count" on DELETE
DROP TRIGGER IF EXISTS messages_DELETE_conversations_message_count;
CREATE TRIGGER messages_DELETE_conversations_message_count
AFTER DELETE ON messages
BEGIN
    UPDATE conversations
    SET messages_count = messages_count - 1
    WHERE id = OLD.conversation_id;
END;
