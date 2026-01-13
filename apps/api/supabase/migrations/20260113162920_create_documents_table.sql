CREATE TABLE IF NOT EXISTS documents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  knowledgebase_id UUID NOT NULL REFERENCES knowledgebases(id) ON DELETE CASCADE,
  url TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

-- enable RLS 
ALTER TABLE public.documents
ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "Users can manage their documents"
ON documents
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM knowledgebases
    WHERE knowledgebases.id = documents.knowledgebase_id
      AND knowledgebases.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM knowledgebases
    WHERE knowledgebases.id = documents.knowledgebase_id
      AND knowledgebases.user_id = auth.uid()
  )
);

-- TRIGGERS

-- update updated_at whenever row is updated
-- use update_updated_at() in functions.sql
CREATE TRIGGER documents_updated_at
  BEFORE UPDATE ON documents
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- indexes
CREATE INDEX documents_knowledgebase_id_idx ON documents(knowledgebase_id);
