import AceEditor from './ace-editor';

class CodeEditor {
  constructor(element) {
    this.element = element
    this.language = element.data('language')
    this.filename = element.data('filename')

    this._setup();
  }

  _setup() {
    this.editor = new AceEditor(this.element, this.language, this.filename);

    this.editor.onSetup = () => {
      this.editor.setTheme('dark');

      this.onSetup(this);
    }
  }

  setTheme(theme) {
    this.editor.setTheme(theme);
  }

  exportFile() {
    this.editor.exportFile();
  }

  focus() {
    this.editor.focus();
  }

  isFocused() {
    return this.editor.isFocused();
  }

  addCommand(opts) {
    this.editor.addCommand(opts);
  }
}

export default CodeEditor;
