import { Controller } from "@hotwired/stimulus"
import * as ActionCable from "@rails/actioncable"

export default class extends Controller {
  static values = {
    storeId: Number
  }

  connect() {
    console.log(`[Queue] Connecting to store ${this.storeIdValue}`)
    this.subscription = null
    this.subscribeToQueue()
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
      console.log(`[Queue] Unsubscribed from store`)
    }
  }

  subscribeToQueue() {
    const consumer = ActionCable.createConsumer()
    
    this.subscription = consumer.subscriptions.create(
      { channel: "QueueChannel", store_id: this.storeIdValue },
      {
        connected: () => {
          console.log(`[Queue] Connected to store ${this.storeIdValue}`)
        },
        received: (data) => {
          console.log(`[Queue] Received data:`, data)
          if (data.type === 'queue_updated') {
            this.updateQueueWidget(data.html)
          }
        },
        disconnected: () => {
          console.log(`[Queue] Disconnected from store ${this.storeIdValue}`)
        }
      }
    )
  }

  updateQueueWidget(html) {
    const queueWidget = document.getElementById('queue-widget')
    if (queueWidget) {
      queueWidget.innerHTML = html
      console.log(`[Queue] Updated widget`)
    }
  }
}
