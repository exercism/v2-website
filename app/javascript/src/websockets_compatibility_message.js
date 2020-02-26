class WebsocketsCompatibilityMessage {
  render() {
    this.container = $(`
      <div class="overlay">
        <div class="websocket-compatibility-message">
          <h1>Incompatible browser</h1>
          <p>
            In order to participate in this experiment, you must use a browser
            that supports WebSockets.
          </p>
        </div>
      </div>
    `).appendTo('body');
  }
}

export default WebsocketsCompatibilityMessage;
