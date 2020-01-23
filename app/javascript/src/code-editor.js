import AceEditor from './ace-editor';

class CodeEditor {
  constructor(element) {
    this.element = element
    this.filename = element.data('filename')
    this.config = element.data('config')
    this.database = localStorage
    this.key = 'code-editor';

    this._setup();
  }

  _setup() {
    this.editor = new AceEditor(this.element, this.config, this.filename);

    this.editor.onSetup = () => {
      this.initialValue = this.editor.getValue();
      this.editor.setTheme('dark');

      if (this.getValue() !== null) { this.editor.setValue(this.getValue()); }

      this.onSetup(this);
    }

    this.editor.onChanged = this.save.bind(this);
  }

  getValue() {
    return this.database.getItem(this.key);
  }

  save() {
    this.database.setItem(this.key, this.editor.getValue());
  }

  reset() {
    this.database.removeItem(this.key);
    this.editor.setValue(this.initialValue);
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
