// ModalController: Manages the modal behavior, handling form submissions and page reloads if necessary.

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
// @method connect
// Initializes the controller and sets up an event listener for the "turbo:submit-end" event to handle form submission responses.
  connect() {
    console.log("Modal controller connected.")
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }
// @method handleSubmitEnd
// Handles the response after a form submission within the modal. If the modal content is replaced with a redirect, it reloads the page.
//
// @param event [Event] The event fired after the form submission ends, containing submission details.
// @return [void]
  handleSubmitEnd(event) {
    const { success } = event.detail

    this.closeModal()
    
    // If the modal was replaced with a redirect, reload the page
    if (this.isRedirectModal()) {
      this.reloadPage()
    } else {
      console.log("Form submission failed, modal has errors. No reload.");
    }
  }

// @method isRedirectModal
// Checks if the modal content was replaced with a redirect, which indicates a successful form submission.
//
// @param modalContent [HTMLElement] The content inside the modal to check for a redirect.
// @return [Boolean] Returns true if the modal contains a redirect class; otherwise, false.
  isRedirectModal() {
    const modalContent = this.element.querySelector("#modal-content");
    return modalContent && modalContent.classList.contains("redirect");
  }
// @method closeModal
// Closes the modal after form submission, if necessary.  
  closeModal() {
    console.log(this.element)
  }
// @method reloadPage
// Reloads the page after a successful form submission, typically when the modal has been replaced with a redirect.
  reloadPage() {
    console.log("Form submitted successfully, reloading the page.");
    window.location.reload();
  }
}
