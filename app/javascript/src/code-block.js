class CodeBlock {
  constructor(element, language) {
    this.element = element;
    this.language = language;

    this._highlight();
  }

  _highlight() {
    this.element.addClass(`language-${this.language}`);

    if (window.Prism) { window.Prism.highlightElement(this.element[0]); }
  }
}

export default CodeBlock;
