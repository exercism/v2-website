import consumer from "./consumer"

class SubmissionChannel {
  constructor(id) {
    this.id = id;
  }

  subscribe() {
    consumer.subscriptions.create(
      { channel: "SubmissionChannel", id: this.id },
      {
        connected() {
          $('#tests-output .ops-status').show().children('span').html("Tests pending")
        },

        disconnected() {
        },

        received(data) {
          $('#tests-output .ops-status').show().children('span').html("Tests finished")
          $('#tests-output .results-status').show().children('span').html(data.status)

          if(data.message) {
            $('#tests-output .results-message').show().children('span').html(data.message)
          }

          if(data.failure) {
            $('#tests-output .test-failure').show()
            $('#tests-output .test-failure .name').html(data.failure.name)
            $('#tests-output .test-failure .message').html(data.failure.message.replace("\n", "<br/>"))
          }
        }
      }
    );
  }
}

window.SubmissionChannel = SubmissionChannel;
