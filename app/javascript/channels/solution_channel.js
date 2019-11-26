import consumer from "./consumer"

class SolutionChannel {
  constructor(id) {
    this.id = id;
  }

  subscribe() {
    consumer.subscriptions.create(
      { channel: "SolutionChannel", id: this.id },
      {
        received(html) {
          $('#tests-output .ops-status').show().html(html)
        }
      }
    );
  }
}

window.SolutionChannel = SolutionChannel;
