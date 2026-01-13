CREATE TABLE IF NOT EXISTS profiles (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE,
  name TEXT NOT NULL,
  avatar TEXT,
  preferences JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  deleted_at TIMESTAMPTZ
);

-- enable RLS 
ALTER TABLE public.profiles
ENABLE ROW LEVEL SECURITY;

-- RLS policies
CREATE POLICY "User can see their own profile only."
ON profiles
FOR SELECT USING ( (SELECT auth.uid()) = id );

CREATE POLICY "Users can update their own profile."
ON profiles FOR UPDATE
TO authenticated
USING ( (SELECT auth.uid()) = id )       -- checks if the existing row complies with the policy expression
WITH CHECK ( (SELECT auth.uid()) = id ); -- checks if the new row complies with the policy expression

-- update updated_at whenever row is updated
-- use update_updated_at() in functions.sql
CREATE TRIGGER profiles_updated_at
  BEFORE UPDATE ON profiles
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at();

-- Function to handle new user signup from auth.users
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email, avatar, created_at, updated_at)
  VALUES (
    NEW.id,
    NEW.email,
    NEW.raw_user_meta_data->>'avatar_url',
    NEW.created_at,
    NEW.created_at
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- indexes
CREATE INDEX users_email_idx ON profiles (email);
