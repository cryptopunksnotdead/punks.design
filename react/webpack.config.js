var path = require('path');

var BUILD_DIR  = path.resolve(__dirname, 'build');
var SOURCE_DIR = path.resolve(__dirname, 'src');

module.exports = {
  entry: {
   'memory.starter': SOURCE_DIR+'/index.starter.js',  // gen memory.starter.bundle.js
   'memory':         SOURCE_DIR+'/index.js',          // gen memory.bundle.js
  },
  output: {
    filename: '[name].bundle.js',
    path:     BUILD_DIR
  },
  module: {
    rules: [
       {
         test: /\.(js|jsx)$/,
         exclude: /node_modules/,
         use: [
          'babel-loader',
         ]
       }
    ]
  }
};
