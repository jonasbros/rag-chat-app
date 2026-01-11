import createConfig from "@jonasbros-simple-rag-system/eslint-config/create-config";

export default createConfig({
  ignores: ["src/db/migrations/*", "public/*"],
});