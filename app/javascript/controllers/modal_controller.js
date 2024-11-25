import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.addEventListener("turbo:submit-end", this.handleSubmitEnd.bind(this))
  }

  handleSubmitEnd(event) {
    const { success } = event.detail
    if (success) {
      this.closeModal()
    }
  }

  closeModal() {
    // Implement your modal closing logic here
    this.element.remove()
  }
}
