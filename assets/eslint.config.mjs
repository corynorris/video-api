import js from "@eslint/js";
import reactPlugin from "eslint-plugin-react";
import globals from "globals";

export default [
	js.configs.recommended,
	{
		plugins: {
			react: reactPlugin,
		},
		languageOptions: {
			ecmaVersion: 2022,
			sourceType: "module",
			parserOptions: {
				ecmaFeatures: {
					jsx: true,
				},
			},
			globals: {
				...globals.browser,
				...globals.node,
				process: "readonly",
				require: "readonly",
				module: "readonly",
			},
		},
		rules: {
			...reactPlugin.configs.recommended.rules,
			"no-unused-vars": ["warn", { argsIgnorePattern: "^_" }],
			"no-undef": "error",
			"react/prop-types": "warn",
			"react/react-in-jsx-scope": "off",
		},
		settings: {
			react: {
				version: "16.13",
			},
		},
	},
	{
		ignores: ["node_modules/", "dist/", "webpack.config.js", "webpack/"],
	},
];
