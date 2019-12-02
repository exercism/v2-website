import Split from 'split.js';
import CodeEditor from './code-editor';
import SolutionChannel from '../channels/solution_channel';

class ExperimentSolution {
  constructor(element) {
    this.element = element;

    this._setup();
  }

  submitCode() {
    this._loading();
    this._submit();
  }

  _loading() {
    this.element.addClass('experiment-solution--loading');
  }

  _setup() {
    this._setupPanes();
    this._setupActions();
    this._setupEditor();
    this._setupChannel();
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
    this.channel = new SolutionChannel(this.element.data('id'));
    this.channel.subscribe();
  }

  _submit() {
    this.channel.createSubmission({
      files: { "two_fer.rb": this.editor.getValue() }
    });
  }
}

$(".experiment-solution").each(function() { new ExperimentSolution($(this)); });
