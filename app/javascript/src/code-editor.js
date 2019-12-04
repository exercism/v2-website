class CodeEditor {
  constructor(element) {
    this.element = element
    this.language = element.data('language')
    this.filename = element.data('filename')

    $(this._setup.bind(this));
  }

  exportFile() {
    const file = {}
    file[this.filename] = this.editor.getValue();

    return file;
  }

  _setup() {
    this.editor = ace.edit(this.element[0]);

    this.editor.setTheme('ace/theme/monokai');
    this.editor.session.setMode(`ace/mode/${this.language}`);
  }
}

export default CodeEditor;
