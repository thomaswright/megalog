/** @type {import('tailwindcss').Config} */
module.exports = {
  content: ["./index.html", "./src/**/*.res.mjs"],
  theme: {
    extend: {
      flex: {
        2: "2 2 0%",
      },
      fontFamily: {
        mono: [
          "Roboto Mono",
          "JetBrains Mono",
          "ui-monospace",
          "SFMono-Regular",
          "monospace",
        ],
      },
    },
  },
  plugins: [],
};
