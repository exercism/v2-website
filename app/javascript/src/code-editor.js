import AceEditor from './ace-editor';

class CodeEditor {
  constructor(element) {
    this.element = element
    this.filename = element.data('filename')
    this.settings = element.data('settings')

    this._setup();
  }

  _setup() {
    this.editor = new AceEditor(this.element, this.settings, this.filename);

    this.editor.onSetup = () => {
      this.editor.setTheme('dark');

      this.onSetup(this);
    }
  }

  setTheme(theme) {
    this.editor.setTheme(theme);
  }

  setKeybinding(keybinding) {
    this.editor.setKeybinding(keybinding);
  }

  exportFile() {
    return this.editor.exportFile();
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
