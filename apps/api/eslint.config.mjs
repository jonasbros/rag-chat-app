import createConfig from "@jonasbros-simple-rag-system/eslint-config/create-config";

export default createConfig({
  ignores: ["supabase/migrations/*", "public/*"],
});