module.exports = {
  darkMode: 'class',
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './config/**/*.rb',
    './lib/**/*.rb',
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          light: '#FDB813',
          DEFAULT: '#F57C00',
          dark: '#C43E00',
        },
        secondary: {
          light: '#FFD54F',
          DEFAULT: '#FFC107',
          dark: '#FFA000',
        },
      },
      fontFamily: {
        sans: ['"Space Grotesk"', '"Orbitron"', 'sans-serif'],
      },
      boxShadow: {
        futuristic: '0 4px 30px rgba(255, 183, 77, 0.1)',
      },
    },
  },
  plugins: [],
};
