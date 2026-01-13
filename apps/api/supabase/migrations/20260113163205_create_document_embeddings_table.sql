CREATE TABLE IF NOT EXISTS document_embeddings (
  id BIGSERIAL PRIMARY KEY,
  document_id UUID NOT NULL REFERENCES documents(id) ON DELETE CASCADE,
  content TEXT,
  embedding extensions.vector(384),
  created_at TIMESTAMPTZ DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

-- enable RLS
ALTER TABLE public.document_embeddings
ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "Users can manage their document_embeddings"
ON document_embeddings
FOR ALL
USING (
  EXISTS (
    SELECT 1
    FROM documents d
    JOIN knowledgebases k ON d.knowledgebase_id = k.id
    WHERE d.id = document_embeddings.document_id
      AND k.user_id = auth.uid()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1
    FROM documents d
    JOIN knowledgebases k ON d.knowledgebase_id = k.id
    WHERE d.id = document_embeddings.document_id
      AND k.user_id = auth.uid()
  )
);

-- indexes
CREATE INDEX document_embeddings_idx
ON document_embeddings
USING ivfflat (embedding vector_l2_ops)
WITH (lists = 100);