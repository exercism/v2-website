import AceEditor from './ace-editor';
import File from './file';

class CodeEditor {
  constructor(element) {
    this.element = element
    this.filename = element.data('filename')
    this.file = new File(this.filename, this.element.text());
    this.config = element.data('config')
    this.beforeSaveHandlers = []
    this.afterSaveHandlers = []

    this._setup();
  }

  _setup() {
    this.editor = new AceEditor(this.element, this.config, this.filename);
    this.change(this.save.bind(this));

    this.editor.onSetup = () => {
      this.load();

      this.onSetup(this);
    }
  }

  change(handler) {
    this.editor.change(handler);
  }

  beforeSave(handler) {
    this.beforeSaveHandlers.push(handler);
  };

  afterSave(handler) {
    this.afterSaveHandlers.push(handler);
  };

  save() {
    this.onBeforeSave();
    this.file.saveLocalChange(this.editor.getValue());
    this.onAfterSave();
  }

  onBeforeSave() {
    this.beforeSaveHandlers.forEach((handler) => handler());
  }

  onAfterSave() {
    this.afterSaveHandlers.forEach((handler) => handler());
  }

  load() {
    this.editor.setValue(this.file.getContent());
  }

  reset() {
    this.file.reset();

    this.editor.setValue(this.file.getContent());
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
