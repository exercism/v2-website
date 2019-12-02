import Split from 'split.js'

class ExperimentSolution {
  constructor(element) {
    this.element = element;

    this._setup();
  }

  submitCode() {
    this._loading();
  }

  _loading() {
    this.element.addClass("experiment-solution--loading");
  }

  _setup() {
    this._setupPanes();
    this._setupActions();
  }

  _setupPanes() {
    Split(['.description-panel', '.solution-panel'], {
      sizes: [50, 50],
      gutterSize: 10,
      split: 'vertical'
    })
  }

  _setupActions() {
    this.element.find(".js-submit-code").click(() => { this.submitCode() });
  }
}

$(".experiment-solution").each(function() { new ExperimentSolution($(this)); });
