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
      this.wrappingSelect.load();
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
    this.wrappingSelect = new EditorPreference(
      this.element.find('.js-code-editor-wrapping'),
      'wrapping'
    );

    this.wrappingSelect.change(this.selectWrapping.bind(this));
  }

  _setupResetToggle() {
    this.element.find('.js-code-editor-reset').click(this.editor.reset.bind(this.editor));
  }
}

export default CodeEditorManager;
