// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import { Clerk } from "@clerk/clerk-js"

// Initialize Clerk
const publishableKey = document.querySelector('meta[name="clerk-publishable-key"]')?.content

if (publishableKey) {
  const clerk = new Clerk(publishableKey)

  clerk.load().then(() => {
    console.log("Clerk loaded successfully")

    // Make clerk available globally for use in Stimulus controllers
    window.Clerk = clerk

    // Dispatch event to signal Clerk is ready
    window.dispatchEvent(new CustomEvent("clerk:loaded"))
  }).catch(error => {
    console.error("Error loading Clerk:", error)
  })
} else {
  console.warn("Clerk publishable key not found")
}
