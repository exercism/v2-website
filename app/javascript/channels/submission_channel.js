import consumer from "./consumer"

class SubmissionChannel {
  constructor(uuid) {
    this.uuid = uuid;
  }

  subscribe() {
    consumer.subscriptions.create(
      { channel: "SubmissionChannel", uuid: this.uuid },
      {
        received(html) {
          $('#tests-output .ops-status').show().html(html)
        }
      }
    );
  }
}

window.SubmissionChannel = SubmissionChannel;
