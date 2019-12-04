import SubmissionStatusView from './submission_status_view';
import TimeoutTimer from './timeout_timer';
import Overlay from './overlay';

class SubmissionStatus {
  constructor(onRender, onTested) {
    this.timeout = 30;
    this.timer = new TimeoutTimer(this.timeout, () => {
      this.setStatus('timeout');
    });
    this.onRender = onRender;
    this.onTested = onTested;
  }

  setStatus(status) {
    this.timer.reset();

    switch(status) {
      case 'queueing':
      case 'queued': {
        this._renderOverlay(status);
        this.timer.start();

        break;
      }
      case 'timeout':
      case 'error': {
        this._renderOverlay(status);

        break;
      }
      case 'passed':
      case 'failed': {
        this._renderOverlay('tested');
        setTimeout(
          () => { new Overlay().close(); this.onTested(); },
          1000
        )

        break;
      }
    }

    this.onRender(new Overlay().getOverlay());
  }

  _renderOverlay(status) {
    const html = new SubmissionStatusView(status).render();

    new Overlay().show(html);
  }
}

export default SubmissionStatus;
