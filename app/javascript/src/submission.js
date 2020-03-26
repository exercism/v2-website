import SubmissionStatusView from './submission_status_view';
import TimeoutTimer from './timeout_timer';
import Collapse from './collapse';
import CodeBlock from './code-block';

class Submission {
  constructor(element) {
    this.element = element;
    this.syntaxHighlighterLanguage = element.data('syntax-highlighter-language');
    this.timer = new TimeoutTimer(30, () => { this.setStatus('timeout'); });
    this.initialHtml = element.html();
    this.html = element.html();

    this.render();
  }

  update(params) {
    this.html = params.html;

    this.setStatus(params.opsStatus);
  }

  setStatus(status) {
    this.timer.reset();

    switch(status) {
      case 'queueing': { this.queueing(); break; }
      case 'queued': { this.queued(); break; }
      case 'cancelling': { this.cancelling(); break; }
      case 'cancelled': { this.cancelled(); break; }
      case 'tested': { this.tested(); break; }
      case 'timeout': { this.timeout(); break; }
      case 'resubmitted': { this.resubmitted(); break; }
      case 'error': { this.error(); break; }
    }

    this.render();
  }

  render() {
    this.element.html(this.html);

    this.element.find('.test-run-result').each(function () {
      new Collapse($(this));
    });

    const self = this;
    this.element.find('[data-behavior=code-block]').each(function () {
      new CodeBlock($(this), self.syntaxHighlighterLanguage);
    });

    if (this.onRender) { this.onRender(); }
  }

  queueing() {
    this.timer.start();

    this.html = new SubmissionStatusView('queueing').render();
    this.onRender = function() {
      this.element.find('.js-cancel-submission').click(() => {this.setStatus('cancelling') });
      $('body').keydown((e) => {
        if(e.key === 'Escape') { this.setStatus('cancelling'); }
      });
    }

    this.status = 'queueing';
    this.onChange('queueing');
  }

  queued() {
    this.timer.start();

    this.onRender = function() {
      this.element.find('.js-cancel-submission').click(() => {this.setStatus('cancelling') });
      $('body').keydown((e) => {
        if(e.key === 'Escape') { this.setStatus('cancelling'); }
      });
    }

    this.status = 'queued';
    this.onChange('queued');
  }

  cancelled() {
    this.html = this.initialHtml;

    this.status = 'cancelled';
    this.onChange('cancelled');
  }

  timeout() {
    this.html = new SubmissionStatusView('timeout').render();

    this.onRender = function() {
      this.element.find('.js-submit-code').click(() => { this.setStatus('resubmitted') });
    }

    this.status = 'timeout';
    this.onChange('timeout');
  }

  tested() {
    this.onRender = function() {
      this.element.removeClass('test-result-focus');

      this.element[0].scrollIntoView({
        behavior: "smooth",
        block: "end"
      });

      this.element.addClass('test-result-focus');
    }

    this.status = 'tested';
    this.onChange('tested');
  }

  cancelling() {
    if (this.status !== 'queueing' && this.status !== 'queued') { return; }

    const previousStatus = this.status
    const previousHtml = this.html

    this.html = new SubmissionStatusView('cancelling').render();
    this.onRender = function() {
      this.element.find('.js-submission-cancel-confirm').focus();
      this.element.find('.js-submission-cancel-confirm').click(() => {
        this.setStatus('cancelled');
      });
      this.element.find('.js-submission-cancel-refuse').click(() => {
        this.html = previousHtml;
        this.setStatus(previousStatus);
      });
    }

    this.status = 'cancelling';
    this.onChange('cancelling');
  }

  resubmitted() {
    this.status = 'resubmitted';
    this.onChange('resubmitted');
  }

  error() {
    this.onRender = function() {
      this.element.find('.js-submission-error-continue').click(() => {
        this.setStatus('cancelled');
      });
    }

    this.status = 'error';
    this.onChange('error');
  }
}

export default Submission;
