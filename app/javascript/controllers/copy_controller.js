// app/javascript/controllers/copy_controller.js

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { url: String }
  static targets = ["icon"]

  connect() {
    console.log("Copy controller connected.")
    // Optionally, store the original SVG for easier reversion
    this.originalSVG = this.iconTarget.innerHTML
  }

  copy(event) {
    const url = this.urlValue
    const icon = this.iconTarget

    navigator.clipboard.writeText(url)
      .then(() => {
        // Show success feedback
        icon.innerHTML = `
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-green-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
        `
        console.log("Text copied successfully!")

        setTimeout(() => {
          // Revert back to original clipboard icon
          icon.innerHTML = this.originalSVG
          console.log("Reverted to clipboard icon.")
        }, 2000)
      })
      .catch((error) => {
        console.error("Failed to copy to clipboard:", error)
      })
  }
}
