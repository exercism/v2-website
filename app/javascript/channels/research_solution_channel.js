import consumer from "./consumer"

class ResearchSolutionChannel {
  constructor(id) {
    this.id = id;
    this.subscription = consumer.subscriptions.create(
      { channel: "ResearchSolutionChannel", id: this.id }
    );
  }

  received(handler) {
    this.subscription.received = handler;
  }

  createSubmission(submission) {
    this.subscription.perform("create_submission", { submission: submission });
  }

  cancelSubmission() {
  }
}

export default ResearchSolutionChannel;
