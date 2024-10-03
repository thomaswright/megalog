/** @type {import('tailwindcss').Config} */
const tailwindColors = require("tailwindcss/colors");

module.exports = {
  darkMode: "selector",
  content: ["./index.html", "./src/**/*.res.mjs"],
  theme: {
    extend: {
      flex: {
        2: "2 2 0%",
      },
      fontFamily: {
        mono: ["Roboto Mono", "ui-monospace", "SFMono-Regular", "monospace"],
      },
    },
  },
  plugins: [],
};
