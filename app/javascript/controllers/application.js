import { Application } from "@hotwired/stimulus"
import AutoSubmit from '@stimulus-components/auto-submit'

const application = Application.start()
application.register('auto-submit', AutoSubmit)

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
