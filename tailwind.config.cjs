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
        Lato: ['Lato', 'Noto Color Emoji', 'sans-serif'],
        Montserrat: ['Montserrat', 'Noto Color Emoji', 'sans-serif'],
        SourceCodePro: ['Source Code Pro', 'monospace'],
      }
    },
  },
  plugins: [],
}
