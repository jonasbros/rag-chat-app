CREATE TABLE IF NOT EXISTS knowledgebases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

-- enable RLS 
ALTER TABLE public.knowledgebases
ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "User can see their own knowledgebases only."
ON knowledgebases
FOR SELECT USING ( (SELECT auth.uid()) = user_id );

CREATE POLICY "Authenticated users can insert new knowledgebases." 
ON knowledgebases
FOR INSERT TO authenticated
WITH CHECK ((SELECT auth.uid()) = user_id);

CREATE POLICY "Users can update their own knowledgebases."
ON knowledgebases FOR UPDATE
TO authenticated
USING ( (SELECT auth.uid()) = user_id )       -- checks if the existing row complies with the policy expression
WITH CHECK ( (SELECT auth.uid()) = user_id ); -- checks if the new row complies with the policy expression

-- TRIGGERS

-- update updated_at whenever row is updated
-- use update_updated_at() in functions.sql
CREATE TRIGGER knowledgebases_updated_at
  BEFORE UPDATE ON knowledgebases
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- indexes
CREATE INDEX knowledgebases_user_id on knowledgebases(user_id);