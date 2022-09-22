module.exports = {
  darkMode: 'class',
  mode: 'jit',
  content: [
    './*.html',
    './src/**/*.purs',
  ],
  theme: {
    extend: {
      fontFamily: {
        Montserrat: ['Montserrat', 'sans-serif'],
        SourceCodePro: ['Source Code Pro', 'monospace'],
      }
    },
  },
  plugins: [],
}
