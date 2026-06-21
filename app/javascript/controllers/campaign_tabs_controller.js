import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "tab"]

  connect() {
    this.show(this.panelIdFromHash() || this.activePanelId())
  }

  select(event) {
    event.preventDefault()

    const panelId = event.currentTarget.hash.slice(1)
    this.show(panelId)
    history.replaceState(null, "", `#${panelId}`)
  }

  show(panelId) {
    const selectedPanel = this.panelTargets.find((panel) => panel.id === panelId) || this.panelTargets[0]

    this.panelTargets.forEach((panel) => {
      const active = panel === selectedPanel
      panel.hidden = !active
      panel.classList.toggle("is-active", active)
    })

    this.tabTargets.forEach((tab) => {
      const active = tab.hash === `#${selectedPanel.id}`
      tab.classList.toggle("is-active", active)
      tab.setAttribute("aria-selected", active)
    })
  }

  panelIdFromHash() {
    const id = window.location.hash.slice(1)
    return this.panelTargets.some((panel) => panel.id === id) ? id : null
  }

  activePanelId() {
    return this.panelTargets.find((panel) => panel.classList.contains("is-active"))?.id
  }
}
