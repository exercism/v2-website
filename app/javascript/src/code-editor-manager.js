import CodeEditor from './code-editor';

class CodeEditorManager {
  constructor(element, onSetup) {
    this.element = element
    this.onSetup = onSetup;

    this._setup();
  }

  _setup() {
    this._setupEditor();
    this._setupToolbar();
  }

  selectTheme(e) {
    this.editor.setTheme(e.currentTarget.value);
    this.editor.focus();
  }

  selectKeybinding(e) {
    this.editor.setKeybinding(e.currentTarget.value);
    this.editor.focus();
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

  _setupEditor() {
    this.editor = new CodeEditor(this.element.find('.js-code-editor'))

    this.editor.onSetup = this.onSetup;
  }

  _setupToolbar() {
    this.
      element.
      find('.js-code-editor-theme').
      change(this.selectTheme.bind(this));
    this.
      element.
      find('.js-code-editor-keybinding').
      change(this.selectKeybinding.bind(this));
  }
}

export default CodeEditorManager;
