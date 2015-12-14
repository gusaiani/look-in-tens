"use strict";

var path = require("path");

var ExtractTextPlugin = require("extract-text-webpack-plugin"),
    webpack = require("webpack");

// helpers for writing path names
// e.g. join("web/static") => "/full/disk/path/to/hello/web/static"
function join(dest) { return path.resolve(__dirname, dest); }
function web(dest) { return join("web/static/" + dest); }

var config = module.exports = {
  devtool: "source-map",
  entry: [
    web("css/app.scss"),
    web("js/app.js")
  ],
  output: {
    path: join("priv/static"),
    filename: "js/script.js"
  },
  module: {
    loaders: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: "babel"
      }, {
        test: /\.scss$/,
        loader: ExtractTextPlugin.extract("style", "css!sass")
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin("css/style.css")
  ]
};

if (process.env.NODE_ENV === "production") {
  config.plugins.push(
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin({ minimize: true })
  );
}
