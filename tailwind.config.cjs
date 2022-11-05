module.exports = {
  darkMode: "class",
  mode: "jit",
  content: ["./*.html", "./src/**/*.purs"],
  theme: {
    extend: {
      fontFamily: {
        Lato: ["Lato", "sans-serif"],
        Montserrat: ["Montserrat", "sans-serif"],
        SourceCodePro: ["Source Code Pro", "monospace"],
      },
      keyframes: {
        sweep: {
          '0%, 100%': { translate: '-60%' },
          '50%': { translate: '60%' },
        },
        fadeIn: {
          '0%': { opacity: 0 },
          '100%': { opacity: 1 },
        }
      },
      animation: {
        sweep: 'sweep 0.8s ease-in-out infinite',
        fadeIn: 'fadeIn 0.08s ease-out 0s 1',
      },
    },
  },
  plugins: [],
};
