const webpack = require("webpack");

// Extracts CSS into .css file
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
// Removes exported JavaScript files from CSS-only entries
// in this example, entry.custom will create a corresponding empty custom.js file
const RemoveEmptyScriptsPlugin = require('webpack-remove-empty-scripts');

module.exports = {
    mode: "production",
    devtool: "source-map",
    entry: {
        // add your css or sass entries
        application: [
            './app/assets/javascripts/application.js',
            './app/assets/stylesheets/application.scss',
        ],
        custom: './app/assets/stylesheets/custom.scss',
    },
    output: {
        filename: "[name].js",
        sourceMapFilename: "[file].map",
        chunkFormat: "module",
        path: path.resolve(__dirname, '..', '..', 'app/assets/builds')
    },
    plugins: [
        new webpack.optimize.LimitChunkCountPlugin({
            maxChunks: 1
        }),
        new RemoveEmptyScriptsPlugin(),
        new MiniCssExtractPlugin(),
    ],
    module: {
        rules: [
            {
                test: /\.(js)$/,
                exclude: /node_modules/,
                use: ['babel-loader'],
            },
            // Add CSS/SASS/SCSS rule with loaders
            {
                test: /\.(?:sa|sc|c)ss$/i,
                use: [MiniCssExtractPlugin.loader, 'css-loader', 'sass-loader'],
            },
        ],
    },
    resolve: {
        // Add additional file types
        extensions: ['.js', '.jsx', '.scss', '.css'],
    },
};
