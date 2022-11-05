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
          '0%': { opacity: 0, transform: 'translateY(-3px)' },
          '100%': { opacity: 1, transform: 'translateY(0)' },
        }
      },
      animation: {
        sweep: 'sweep 0.8s ease-in-out infinite',
        fadeIn: 'fadeIn 0.08s ease-in-out',
      },
    },
  },
  plugins: [],
};
