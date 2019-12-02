class CodeEditor {
  constructor(element) {
    this.element = element
    this.language = element.data('language')

    $(this._setup.bind(this));
  }

  _setup() {
    this.editor = ace.edit(this.element[0]);

    this.editor.setTheme('ace/theme/monokai');
    this.editor.session.setMode(`ace/mode/${this.language}`);
  }
}

export default CodeEditor;
