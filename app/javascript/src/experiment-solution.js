import Split from 'split.js';
import CodeEditor from './code-editor';
import ResearchSolutionChannel from '../channels/research_solution_channel';
import SubmissionStatus from './submission_status';

class ExperimentSolution {
  constructor(element) {
    this.element = element;

    this._setup();
  }

  _setup() {
    this._setupPanes();
    this._setupActions(this.element);
    this._setupEditor();
    this._setupSubmissionStatus();
    this._setupChannel();
    this._setupTestResults();
  }

  submitCode() {
    this.submissionStatus.setStatus('queueing');
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
    this.channel = new ResearchSolutionChannel(
      this.element.data('id'),
      (submission) => {
        this.submissionStatus.setStatus(submission.status);
        this.testResults.html(submission.testResults);
      }
    );

    this.channel.subscribe();
  }

  _setupSubmissionStatus() {
    this.submissionStatus = new SubmissionStatus(this._setupActions.bind(this));
  }

  _setupTestResults() {
    this.testResults = this.element.find('.js-test-results');
  }

  _submit() {
    this.channel.createSubmission({
      files: { "two_fer.rb": this.editor.getValue() }
    });
  }
}

$(".experiment-solution").each(function() { new ExperimentSolution($(this)); });
