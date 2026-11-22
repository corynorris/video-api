import path from "node:path";
import { globSync } from "glob";
import MiniCssExtractPlugin from "mini-css-extract-plugin";
import TerserPlugin from "terser-webpack-plugin";
import CopyWebpackPlugin from "copy-webpack-plugin";

const __dirname = import.meta.dirname;

export default (env, options) => {
  const devMode = options.mode !== "production";

  return {
    cache: { type: "filesystem" },
    optimization: {
      minimizer: [new TerserPlugin({ parallel: true })],
    },
    entry: {
      app: globSync("./vendor/**/*.js").concat(["./js/app.js"]),
    },
    output: {
      filename: "[name].js",
      path: path.resolve(__dirname, "../priv/static/js"),
      publicPath: "/js/",
    },
    devtool: devMode ? "eval-cheap-module-source-map" : undefined,
    module: {
      rules: [
        {
          test: /\.js$/,
          exclude: /node_modules/,
          use: {
            loader: "babel-loader",
          },
        },
        {
          test: /\.[s]?css$/,
          use: [
            MiniCssExtractPlugin.loader,
            "css-loader",
            {
              loader: "sass-loader",
              options: { sassOptions: { quietDeps: true } },
            },
          ],
        },
      ],
    },

    plugins: [
      new MiniCssExtractPlugin({ filename: "../css/app.css" }),
      new CopyWebpackPlugin({ patterns: [{ from: "static/", to: "../" }] }),
    ],
  };
};
