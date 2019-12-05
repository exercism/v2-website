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
    this._setupTestRun();
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
        this.testRun.html(submission.testRun);
      }
    );

    this.channel.subscribe();
  }

  _setupSubmissionStatus() {
    this.submissionStatus = new SubmissionStatus();
    this.submissionStatus.onSubmit = this.submitCode.bind(this)
    this.submissionStatus.onTested = this._onTested.bind(this)
    this.submissionStatus.onCancel = this._onCancel.bind(this)
  }

  _setupTestRun() {
    this.testRun = this.element.find('.js-test-run');
  }

  _submit() {
    this.channel.createSubmission(this.editor.exportFile());
  }

<<<<<<< HEAD
  _onTested() {
    this._scrollToTestRun();
    this.editor.focus();
  }

  _onCancel() {
    this._cancelBuild();
    this.editor.focus();
  }

=======
>>>>>>> master
  _scrollToTestRun() {
    this.testRun.removeClass('focus');

    this.testRun[0].scrollIntoView({
      behavior: "smooth",
      block: "end"
    });

    this.testRun.addClass('focus');
  }

  _cancelBuild() {
    this.channel.cancelSubmission();
  }
}

$(".experiment-solution").each(function() { new ExperimentSolution($(this)); });
