import eslint from "eslint/js";
import prettier from "eslint-config-prettier";
import globals from "globals";
import tseslint from "typescript-eslint";

export default tseslint.config(
    {
        ignores: ['dist', 'node_modules'],
    },
    eslint.configs.recommended,
    ...tseslint.configs.recommended,
    prettier,
    {
        files: ['src/**/*.ts'],
        languageOptions: {
            globals:{
                ...globals.node,
            },
        },
        rules: {
            '#typescript-eslint/no-unused-vars':[
                'error',
                {
                    argsIgnorePattern: '^_',
                },
            ],
        },
    },
);