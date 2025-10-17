// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import { Clerk } from "@clerk/clerk-js"

// Initialize Clerk on page load and on Turbo navigation
async function initializeClerk() {
  const publishableKey = document.querySelector('meta[name="clerk-publishable-key"]')?.content

  if (!publishableKey) {
    console.warn("Clerk publishable key not found")
    return
  }

  if (window.Clerk) {
    // Clerk already initialized
    return
  }

  try {
    const clerk = new Clerk(publishableKey)
    await clerk.load()

    console.log("Clerk loaded successfully")

    // Make clerk available globally for use in Stimulus controllers
    window.Clerk = clerk

    // Dispatch event to signal Clerk is ready
    window.dispatchEvent(new CustomEvent("clerk:loaded"))
  } catch (error) {
    console.error("Error loading Clerk:", error)
  }
}

// Initialize on page load
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", initializeClerk)
} else {
  initializeClerk()
}

// Reinitialize on Turbo navigation
document.addEventListener("turbo:load", initializeClerk)
