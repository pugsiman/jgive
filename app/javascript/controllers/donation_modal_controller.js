import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["displayPreference", "modal", "nameFields"]

  connect() {
    if (this.modalTarget.classList.contains("donation-modal--open")) {
      document.body.classList.add("modal-open")
    }

    this.syncNameFields()
  }

  open(event) {
    event.preventDefault()
    this.modalTarget.classList.add("donation-modal--open")
    document.body.classList.add("modal-open")
  }

  close(event) {
    event.preventDefault()
    this.modalTarget.classList.remove("donation-modal--open")
    document.body.classList.remove("modal-open")
  }

  syncNameFields() {
    if (!this.hasDisplayPreferenceTarget || !this.hasNameFieldsTarget) return

    const anonymous = this.displayPreferenceTarget.value === "anonymous"
    this.nameFieldsTarget.hidden = anonymous
    this.nameFieldsTarget.querySelectorAll("input").forEach((input) => {
      input.disabled = anonymous
    })
  }
}
