module.exports = {
  "transpileDependencies": [
    "vuetify"
  ],
  configureWebpack: {
		devServer: {
		  watchOptions: {
        ignored: /node_modules/,
        poll: 1000,
		  },
		}
	}
}