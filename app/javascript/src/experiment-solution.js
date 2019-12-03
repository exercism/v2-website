import Split from 'split.js';
import CodeEditor from './code-editor';
import SolutionChannel from '../channels/solution_channel';
import SubmissionStatusView from './submission_status_view';
import TimeoutTimer from './timeout_timer';
import Overlay from './overlay';

class ExperimentSolution {
  constructor(element) {
    this.element = element;
    this.timeout = 30;

    this._setup();
  }

  _setup() {
    this._setupPanes();
    this._setupActions(this.element);
    this._setupEditor();
    this._setupChannel();
    this._setupTimer();
  }

  submitCode() {
    this._setSubmissionStatus('queueing');
    this._submit();
  }

  _setupPanes() {
    Split(['.description-panel', '.solution-panel'], {
      sizes: [50, 50],
      gutterSize: 10,
      split: 'vertical'
    })
  }

  _setupActions(container) {
    container.find('.js-submit-code').click(this.submitCode.bind(this));
  }

  _setupEditor() {
    this.editor = new CodeEditor(this.element.find('.js-code-editor'))
  }

  _setupChannel() {
    this.channel = new SolutionChannel(
      this.element.data('id'),
      (submission) => { this._setSubmissionStatus(submission.status); }
    );

    this.channel.subscribe();
  }

  _setupTimer() {
    this.timer = new TimeoutTimer(this.timeout, () => {
      this._setSubmissionStatus('timeout');
    });
  }

  _setSubmissionStatus(status) {
    this.timer.reset();

    switch(status) {
      case 'queueing': {
        this._renderOverlay('queueing');

        this.timer.start();

        break;
      }
      case 'queued': {
        this._renderOverlay('queued');

        this.timer.start();

        break;
      }
      case 'passed':
      case 'failed': {
        this._renderOverlay('tested');

        break;
      }
      case 'timeout': {
        this._renderOverlay('timeout');
        this._setupActions(new Overlay().getOverlay());

        break;
      }
      case 'error': {
        this._renderOverlay('error');

        break;
      }
    }
  }

  _submit() {
    this.channel.createSubmission({
      files: { "two_fer.rb": this.editor.getValue() }
    });
  }

  _renderOverlay(status) {
    const html = new SubmissionStatusView(status).render();

    new Overlay().show(html);
  }
}

$(".experiment-solution").each(function() { new ExperimentSolution($(this)); });
