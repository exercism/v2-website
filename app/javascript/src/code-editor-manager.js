import CodeEditor from './code-editor';
import EditorPreference from './editor-preference';

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

  selectWrapping(value) {
    this.editor.setWrapping(value);
    this.editor.focus();
  }

  reset() {
    this.editor.reset();
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

    this.editor.onSetup = (editor) => {
      this.keybindingSelect.load();
      this.onSetup(editor);
    }
  }

  _setupToolbar() {
    this._setupKeybindingToggle();
    this._setupWrappingToggle();
    this._setupResetToggle();
  }

  _setupKeybindingToggle() {
    this.keybindingSelect = new EditorPreference(
      this.element.find('.js-code-editor-keybinding'),
      'keybinding'
    );

    this.keybindingSelect.change(this.selectKeybinding.bind(this));
  }

  _setupWrappingToggle() {
    var form = this.element.find('.js-code-editor-wrapping')
    var btns = form.find('button')
    btns.click(function(e) {
      for(var btn of btns) { btn.removeAttribute('selected')}
      e.currentTarget.setAttribute('selected', true)

      this.selectWrapping(e.currentTarget.value)
    }.bind(this));
  }

  _setupResetToggle() {
    this.element.find('.js-code-editor-reset').click(this.editor.reset.bind(this.editor));
  }
}

export default CodeEditorManager;
