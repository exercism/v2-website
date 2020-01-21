import Split from 'split.js';
import CodeEditorManager from './code-editor-manager';
import ResearchSolutionChannel from '../channels/research_solution_channel';
import SubmissionStatus from './submission_status';
import SubmissionStatusView from './submission_status_view';
import KeyboardShortcuts from './keyboard_shortcuts';

class ExperimentSolution {
  constructor(element) {
    this.element = element;

    this._setup();
  }

  _setup() {
    this._setupPanes();
    this._setupEditor();
    this._setupActions();
    this._setupSubmissionStatus();
    this._setupChannel();
    this._setupTestRun();
  }

  submitCode() {
    if (!this.submissionStatus.isAllowedToSubmit()) { return; }

    this.submissionStatus.setStatus('queueing');
    this.submissionStatus.render(new SubmissionStatusView('queueing').render());
    this._submit();
  }

  setCommand(key, command) {
    $(document).on('keydown', this.container, (e) => {
      if (e.key == key) { command(); }
    });
  }

  openShortcuts() {
    if ($('.overlay').length > 0) { return; }
    if (this.editor.isFocused()) { return; }

    const modal = new KeyboardShortcuts();
    modal.onRender = () => { this.element.focus() };
    modal.render();
  }

  _setupPanes() {
    Split(['.info-panel', '.coding-panel'], {
      sizes: [50, 50],
      gutterSize: 10,
      split: 'vertical'
    })
  }

  _setupActions() {
    this.setCommand('?', () => { this.openShortcuts(); });

    this.element.find('.js-submit-code').click(this.submitCode.bind(this));
    this.
      element.
      find('.js-keyboard-shortcuts').
      click(this.openShortcuts.bind(this));
  }

  _setupEditor() {
    this.editor = new CodeEditorManager(
      this.element.find('.js-code-editor-manager'),
      (editor) => {
        editor.addCommand({
          name: "submit",
          bindKey: {win: "Shift-Enter", mac: "Shift-Enter"},
          exec: this.submitCode.bind(this)
        });
    });
  }

  _setupSubmissionStatus() {
    this.submissionStatus = new SubmissionStatus(
      this.element.find('.js-submission-status')
    );
    this.submissionStatus.onSubmit = this.submitCode.bind(this)
    this.submissionStatus.onTested = this._onTested.bind(this)
    this.submissionStatus.onCancel = this._onCancel.bind(this)
  }

  _setupChannel() {
    this.channel = new ResearchSolutionChannel(
      this.element.data('id'),
      (submission) => {
        this.submissionStatus.setStatus(submission.opsStatus);
        this.submissionStatus.render(submission.opsStatusHtml);
        if (submission.testRunHtml) {
          this.testRun.html(submission.testRunHtml);
        }
      }
    );

    this.channel.subscribe();
  }

  _setupTestRun() {
    this.testRun = this.element.find('.js-test-run');
  }

  _submit() {
    this.channel.createSubmission(this.editor.exportFile());
  }

  _onTested() {
    this._scrollToTestRun();
    this.editor.focus();
  }

  _onCancel() {
    this._cancelBuild();
    this.editor.focus();
  }

  _scrollToTestRun() {
    this.testRun.removeClass('test-result-focus');

    this.testRun[0].scrollIntoView({
      behavior: "smooth",
      block: "end"
    });

    this.testRun.addClass('test-result-focus');
  }

  _cancelBuild() {
    this.channel.cancelSubmission();
  }
}

export default ExperimentSolution;

$(".experiment-solution").each(function() { new ExperimentSolution($(this)); });
