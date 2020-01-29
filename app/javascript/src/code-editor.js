import AceEditor from './ace-editor';

class CodeEditor {
  constructor(element) {
    this.element = element
    this.filename = element.data('filename')
    this.config = element.data('config')
    this.database = localStorage;

    this._setup();
  }

  _setup() {
    this.editor = new AceEditor(this.element, this.config, this.filename);
    this.editor.onChanged = this.save.bind(this);
    this.editor.onSetup = () => {
      this.load();

      this.onSetup(this);
    }
  }

  save() {
    this.database.setItem(this.filename, this.editor.getValue());
  }

  load() {
    if (!this.database.getItem(this.filename)) { return; }

    this.editor.setValue(this.database.getItem(this.filename));
  }

  setTheme(theme) {
    this.editor.setTheme(theme);
  }

  setKeybinding(keybinding) {
    this.editor.setKeybinding(keybinding);
  }

  setWrapping(value) {
    this.editor.setUseWrapMode(value);
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
