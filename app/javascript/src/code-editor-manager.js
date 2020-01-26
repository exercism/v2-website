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

  setTheme(theme) {
    this.editor.setTheme(theme);
    this.editor.focus();
  }

  selectKeybinding(bindings) {
    this.editor.setKeybinding(bindings);
    this.editor.focus();
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

  _setupEditor() {
    this.editor = new CodeEditor(this.element.find('.js-code-editor'))

    this.editor.onSetup = this.onSetup;
  }

  _setupToolbar() {
    var form = this.element.find('.js-code-editor-keybinding')
    var btns = form.find('button')
    btns.click(function(e) {
      for(var btn of btns) { btn.removeAttribute('selected')}
      e.currentTarget.setAttribute('selected', true)

      this.selectKeybinding(e.currentTarget.value)
    }.bind(this));
  }
}

export default CodeEditorManager;
