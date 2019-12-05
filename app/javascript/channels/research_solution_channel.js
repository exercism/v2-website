import consumer from "./consumer"

class ResearchSolutionChannel {
  constructor(id, onReceive) {
    this.id = id;
    this.onReceive = onReceive;
  }

  subscribe() {
    this.subscription = consumer.subscriptions.create(
      { channel: "ResearchSolutionChannel", id: this.id }
    );

    this.subscription.received = this.onReceive;
  }

  createSubmission(submission) {
    this.subscription.perform("create_submission", { submission: submission });
  }

  cancelSubmission() {
    alert('cancel sent to server');
  }
}

export default ResearchSolutionChannel;
