CREATE TABLE IF NOT EXISTS conversations (
  id TEXT NOT NULL PRIMARY KEY,

  topic TEXT DEFAULT NULL,
  tags TEXT NOT NULL DEFAULT '[]',
  meta TEXT NOT NULL DEFAULT '{}',

  messages_count INTEGER NOT NULL DEFAULT 0,
  users_count INTEGER NOT NULL DEFAULT 0,
  agents_count INTEGER NOT NULL DEFAULT 0,

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Update "updated_at" when a record is updated
DROP TRIGGER IF EXISTS conversations_UPDATE_updated_at;
CREATE TRIGGER conversations_UPDATE_updated_at
AFTER UPDATE ON conversations
BEGIN
  UPDATE conversations
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = NEW.id;
END;

--
--
--

CREATE TABLE IF NOT EXISTS conversations_participants (
  id TEXT NOT NULL PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  user_id TEXT,
  agent_id TEXT,
  role TEXT NOT NULL, 

  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

  FOREIGN KEY (conversation_id) REFERENCES conversations(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (agent_id) REFERENCES agents(id),
  UNIQUE(conversation_id, user_id, agent_id),
  CHECK (
    (user_id IS NOT NULL AND agent_id IS NULL) OR 
    (user_id IS NULL AND agent_id IS NOT NULL)
  )
);

-- Update "updated_at" when a record is updated
DROP TRIGGER IF EXISTS conversations_participants_UPDATE_updated_at;
CREATE TRIGGER conversations_participants_UPDATE_updated_at
AFTER UPDATE ON conversations_participants
BEGIN
  UPDATE conversations_participants
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = NEW.id;
END;

-- Increment parent Conversation "users_count" on INSERT if user_id is set
DROP TRIGGER IF EXISTS conversations_participants_INSERT_conversations_users_count;
CREATE TRIGGER conversations_participants_INSERT_conversations_users_count
AFTER INSERT ON conversations_participants
BEGIN
    UPDATE conversations
    SET users_count = users_count + 1
    WHERE id = NEW.conversation_id AND NEW.user_id IS NOT NULL;
END;

-- Decrement parent Conversation "users_count" on DELETE if user_id is set
DROP TRIGGER IF EXISTS conversations_participants_DELETE_conversations_users_count;
CREATE TRIGGER conversations_participants_DELETE_conversations_users_count
AFTER DELETE ON conversations_participants
BEGIN
    UPDATE conversations
    SET users_count = users_count - 1
    WHERE id = OLD.conversation_id AND OLD.user_id IS NOT NULL;
END;

-- Increment parent Conversation "agents_count" on INSERT if agent_id is set
DROP TRIGGER IF EXISTS conversations_participants_INSERT_conversations_agents_count;
CREATE TRIGGER conversations_participants_INSERT_conversations_agents_count
AFTER INSERT ON conversations_participants
BEGIN
    UPDATE conversations
    SET agents_count = agents_count + 1
    WHERE id = NEW.conversation_id AND NEW.agent_id IS NOT NULL;
END;

-- Decrement parent Conversation "agents_count" on DELETE if agent_id is set
DROP TRIGGER IF EXISTS conversations_participants_DELETE_conversations_agents_count;
CREATE TRIGGER conversations_participants_DELETE_conversations_agents_count
AFTER DELETE ON conversations_participants
BEGIN
    UPDATE conversations
    SET agents_count = agents_count - 1
    WHERE id = OLD.conversation_id AND OLD.agent_id IS NOT NULL;
END;
