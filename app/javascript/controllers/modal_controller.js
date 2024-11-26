import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Modal controller connected.")
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }

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

  // Checks if the modal content was replaced with a redirect (i.e., successful form submission)
  isRedirectModal() {
    const modalContent = this.element.querySelector("#modal-content");
    return modalContent && modalContent.classList.contains("redirect");
  }

  closeModal() {
    console.log(this.element)
  }

  reloadPage() {
    console.log("Form submitted successfully, reloading the page.");
    window.location.reload();
  }
}
