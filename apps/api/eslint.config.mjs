import createConfig from "@jonasbros-simple-rag-system/eslint-config/create-config";

export default createConfig(
  {
    ignores: ["supabase/*", "public/*"],
  },
  {
    files: ["**/*.*"],
    rules: {
      "unicorn/filename-case": ["error", { case: "kebabCase" }],
    },
  },
  {
    files: ["src/controllers/**/*.*"],
    rules: {
      "unicorn/filename-case": ["error", { case: "pascalCase" }],
    },
  },
  {
    files: ["src/models/**/*.*"],
    rules: {
      "unicorn/filename-case": ["error", { case: "pascalCase" }],
    },
  },
);
