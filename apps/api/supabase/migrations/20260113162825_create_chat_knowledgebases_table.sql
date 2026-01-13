CREATE TABLE IF NOT EXISTS chat_knowledgebases (
  chat_id UUID NOT NULL REFERENCES chats(id) ON DELETE CASCADE,
  knowledgebase_id UUID NOT NULL REFERENCES knowledgebases(id) ON DELETE CASCADE
);

-- enable RLS 
ALTER TABLE public.chat_knowledgebases
ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "User can manage their chat_knowledgebases"
ON chat_knowledgebases
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM chats
    WHERE chats.id = chat_knowledgebases.chat_id
      AND chats.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM chats
    WHERE chats.id = chat_knowledgebases.chat_id
      AND chats.user_id = auth.uid()
  )
);

-- indexes
CREATE INDEX chat_knowledgebases_chat_id on chat_knowledgebases(chat_id);
CREATE INDEX chat_knowledgebases_knowledgebase_id on chat_knowledgebases(knowledgebase_id);