"use strict";

const CopyWebpackPlugin = require('copy-webpack-plugin');


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
    web("css/style.styl"),
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
        loader: "babel",
        exclude: /node_modules/,
        query: {
            cacheDirectory: true,
            presets: ['es2015', 'stage-0', 'react']
        }
      }, {
        test: /\.styl$/,
        loader: ExtractTextPlugin.extract("style", "css-loader!stylus-loader?paths=node_modules/bootstrap-stylus/stylus/")
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin("css/style.css"),
    new webpack.ProvidePlugin({
      'React': 'react',
      'ReactDOM': 'react-dom'
    })
  ]
};

if (process.env.NODE_ENV === "production") {
  config.plugins.push(
    new webpack.optimize.DedupePlugin(),
    new webpack.optimize.UglifyJsPlugin({ minimize: true })
  );
}
