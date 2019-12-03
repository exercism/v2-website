import consumer from "./consumer"

class SolutionChannel {
  constructor(id, onReceive) {
    this.id = id;
    this.onReceive = onReceive;
  }

  subscribe() {
    this.subscription = consumer.subscriptions.create(
      { channel: "SolutionChannel", id: this.id }
    );

    this.subscription.received = this.onReceive;
  }

  createSubmission(submission) {
    this.subscription.perform("create_submission", submission);
  }
}

export default SolutionChannel;
