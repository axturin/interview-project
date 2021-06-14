import { plugin } from "vite-plugin-elm"

export default {
  // Add elm plugin
  plugins: [plugin()],
  // Avoid annoying screen clear
  clearScreen: false,
  // Avoid showing Elm compilation errors twice
  logLevel: "silent",
}
