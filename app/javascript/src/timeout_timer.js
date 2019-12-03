class TimeoutTimer {
  constructor(seconds, onTimeout) {
    this.seconds = seconds;
    this.onTimeout = onTimeout
  }

  start() {
    this.timer = setTimeout(this.onTimeout, this.seconds * 1000);
  }

  reset() {
    clearTimeout(this.timer);
  }
}

export default TimeoutTimer;
