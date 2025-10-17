import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clerk"
export default class extends Controller {
  static values = {
    component: String,
    props: Object
  }

  connect() {
    // Wait for Clerk to load if not already loaded
    if (window.Clerk) {
      this.mountComponent()
    } else {
      window.addEventListener("clerk:loaded", () => {
        this.mountComponent()
      }, { once: true })
    }
  }

  disconnect() {
    this.unmountComponent()
  }

  mountComponent() {
    const componentName = this.componentValue
    if (!componentName) {
      console.error("Clerk component name not specified")
      return
    }

    try {
      // Mount the Clerk component
      const props = this.hasPropsValue ? this.propsValue : {}

      // Common Clerk components
      switch (componentName) {
        case "SignIn":
          window.Clerk.mountSignIn(this.element, props)
          break
        case "SignUp":
          window.Clerk.mountSignUp(this.element, props)
          break
        case "UserButton":
          window.Clerk.mountUserButton(this.element, props)
          break
        case "UserProfile":
          window.Clerk.mountUserProfile(this.element, props)
          break
        default:
          console.error(`Unknown Clerk component: ${componentName}`)
      }
    } catch (error) {
      console.error("Error mounting Clerk component:", error)
    }
  }

  unmountComponent() {
    try {
      window.Clerk?.unmountComponentAtNode(this.element)
    } catch (error) {
      console.error("Error unmounting Clerk component:", error)
    }
  }
}