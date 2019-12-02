import consumer from "./consumer"

class SolutionChannel {
  constructor(id) {
    this.id = id;
  }

  subscribe() {
    this.subscription = consumer.subscriptions.create(
      { channel: "SolutionChannel", id: this.id },
      {
        received(data) {
          if (data.event == 'submission_changed') {
            $('.overlay').html(data.html);
          }
        }
      }
    );
  }

  createSubmission(submission) {
    this.subscription.perform("create_submission", submission);
  }
}

export default SolutionChannel;
