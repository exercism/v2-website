import Split from 'split.js';
import CodeEditorManager from './code-editor-manager';
import ResearchSolutionChannel from '../channels/research_solution_channel';
import KeyboardShortcuts from './keyboard_shortcuts';
import InfoPanel from './info_panel';
import SubmitButton from './submit_button';
import Submission from './submission';

class ExperimentSolution {
  constructor(element) {
    this.element = element;
    this.initialClass = this.element.attr('class');

    this._setup();
  }

  _setup() {
    this._setupSubmitButton();
    this._setupShortcuts();
    this._setupInfoPanel();
    this._setupSubmission();
    this._setupEditor();
    this._setupChannel();
    this._setupSplit();
  }

  _setupSubmitButton() {
    this.submitButton = new SubmitButton(this.element.find('.js-submit-code'));
    this.submitButton.click(this.codeSubmitted.bind(this));
  }

  _setupShortcuts() {
    this.shortcutsButton = this.element.find('.js-keyboard-shortcuts')
    this.shortcutsButton.click(this.openShortcuts.bind(this));
    this.setCommand('?', () => { this.openShortcuts(); });
  }

  _setupInfoPanel() {
    this.infoPanel = new InfoPanel(this.element.find('.info-panel'));
  }

  _setupSubmission() {
    this.submission = this._newSubmission();
  }

  _setupEditor() {
    this.editor = new CodeEditorManager(
      this.element.find('.js-code-editor-manager'),
      (editor) => {
        editor.addCommand({
          name: "submit",
          bindKey: {win: "Shift-Enter", mac: "Shift-Enter"},
          exec: this.codeSubmitted.bind(this)
        });
    });
  }

  _setupChannel() {
    this.channel = new ResearchSolutionChannel(this.element.data('id'))
    this.channel.received(function(submission) {
      this.submission.update(submission);
    }.bind(this));
  }

  _setupSplit() {
    Split(['.info-panel', '.coding-panel'], {
      sizes: [50, 50],
      gutterSize: 10,
      split: 'vertical'
    })
  }

  codeSubmitted() {
    if (this.submission.status == 'queueing' || this.submission.status == 'queued') {
      return;
    }
    this.submission = this._newSubmission();
    this.submission.setStatus('queueing');

    this.infoPanel.codeSubmitted();
    this.submitButton.submitted();
    this.channel.createSubmission(this.editor.exportFile());
  }

  resultsReceived() {
    this.submitButton.waitingForSubmission();
    this.editor.focus();
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

  updateClass(status) {
    this.element.attr('class', `experiment-solution experiment-solution--${status}`);
  }

  _newSubmission() {
    const submission = new Submission(this.element.find('.js-submission-panel'));
    submission.onChange = (status) => {
      switch(status) {
        case 'queueing':
          this.updateClass('pending');
          break;
        case 'queued':
          this.updateClass('pending');
          break;
        case 'cancelling':
          this.updateClass('info');
          break;
        case 'cancelled':
          this.element.attr('class', this.initialClass);
          this._cancelBuild();
          break;
        case 'pass':
          this.updateClass('pass');
          this.resultsReceived();
          break;
        case 'fail':
          this.updateClass('fail');
          this.resultsReceived();
          break;
        case 'timeout':
          this.updateClass('info');
          break;
        case 'resubmitted':
          this.codeSubmitted();
          break;
      }
    }

    return submission;
  }

  _cancelBuild() {
    this.resultsReceived();
    this.channel.cancelSubmission();
  }
}

export default ExperimentSolution;

$(".experiment-solution").each(function() { new ExperimentSolution($(this)); });
