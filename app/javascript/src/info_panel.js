class InfoPanel {
  constructor(element) {
    this.element = element;
    this.instructionsTab = this.element.find('.tab-1');
    this.resultsTab = this.element.find('.tab-2');
  }

  codeSubmitted() {
    this.resultsTab.click();
  }
}

export default InfoPanel;
