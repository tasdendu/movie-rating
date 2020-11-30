module.exports = {
  port: process.env.PORT || 5000,
  files: ['./**/*.{html,htm,css,js}'],
  server: {
    baseDir: [
      './src',
      './build/contracts'
    ]
  }
};
