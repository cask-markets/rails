import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="clerk"
export default class extends Controller {
  static values = {
    component: String,
    props: Object
  }

  connect() {
    // Wait for Clerk to load if not already loaded
    if (window.Clerk && window.Clerk.loaded) {
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

  async mountComponent() {
    const componentName = this.componentValue
    if (!componentName) {
      console.error("Clerk component name not specified")
      return
    }

    try {
      // Ensure Clerk is loaded
      if (!window.Clerk) {
        console.error("Clerk not loaded")
        return
      }

      // Mount the Clerk component
      const props = this.hasPropsValue ? this.propsValue : {
        afterSignInUrl: "/",
        afterSignUpUrl: "/",
        signInUrl: "/sign-in",
        signUpUrl: "/sign-up"
      }

      // Common Clerk components
      switch (componentName) {
        case "SignIn":
          await window.Clerk.mountSignIn(this.element, props)
          break
        case "SignUp":
          await window.Clerk.mountSignUp(this.element, props)
          break
        case "UserButton":
          await window.Clerk.mountUserButton(this.element, props)
          break
        case "UserProfile":
          await window.Clerk.mountUserProfile(this.element, props)
          break
        default:
          console.error(`Unknown Clerk component: ${componentName}`)
      }

      console.log(`Mounted ${componentName} component`)
    } catch (error) {
      console.error("Error mounting Clerk component:", error)
    }
  }

  unmountComponent() {
    try {
      if (window.Clerk) {
        window.Clerk.unmountComponentAtNode(this.element)
      }
    } catch (error) {
      console.error("Error unmounting Clerk component:", error)
    }
  }
}