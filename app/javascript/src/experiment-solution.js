import Split from 'split.js';
import CodeEditor from './code-editor';
import SolutionChannel from '../channels/solution_channel';
import SubmissionStatusView from './submission_status_view';

class ExperimentSolution {
  constructor(element) {
    this.element = element;

    this._setup();
  }

  _setup() {
    this._setupPanes();
    this._setupActions();
    this._setupEditor();
    this._setupChannel();
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

  _setupActions() {
    this.element.find('.js-submit-code').click(() => { this.submitCode() });
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

  _setSubmissionStatus(status) {
    switch(status) {
      case 'queueing': {
        this._renderOverlay('queueing');
        break;
      }
      case 'queued': {
        this._renderOverlay('queued');
        break;
      }
      case 'passed':
      case 'failed': {
        this._renderOverlay('tested');
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
    this.element.addClass('experiment-solution--loading');

    const html = new SubmissionStatusView(status).render();
    this.element.find('.overlay').html(html);
  }
}

$(".experiment-solution").each(function() { new ExperimentSolution($(this)); });
