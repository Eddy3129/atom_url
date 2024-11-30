// CopyController: Handles the copying of URL text to the clipboard and provides visual feedback

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
// @param urlValue [String] The URL value to be copied to the clipboard (passed as a value)
// @param iconTarget [HTMLElement] The target icon element that indicates the copy status (e.g., a clipboard icon)
  static values = { url: String }
  static targets = ["icon"]

// @method connect
// Initializes the controller and saves the original state of the icon for later restoration.
  connect() {
    console.log("Copy controller connected.")
    this.originalSVG = this.iconTarget.innerHTML
  }

// @method copy
// Handles the copy action triggered by the user. It copies the URL to the clipboard and provides feedback by changing the icon.
//
// @param event [Event] The event that triggers the copy action.
// @return [void]  
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
          // Reverts the icon back to its original state after a short delay, providing the user with visual feedback.
          icon.innerHTML = this.originalSVG
          console.log("Reverted to clipboard icon.")
        }, 2000)
      })
      .catch((error) => {
        console.error("Failed to copy to clipboard:", error)
      })
  }
}
