import AceEditorConfig from './ace-editor-config';

class AceEditor {
  constructor(element, config, filename) {
    this.element = element
    this.config = new AceEditorConfig(config)
    this.filename = filename

    $(this._setup.bind(this));
  }

  setTheme(theme) {
    switch(theme) {
      case 'dark':
        this.editor.setTheme('ace/theme/tomorrow_night_bright');

        break;
      case 'light':
        this.editor.setTheme('ace/theme/textmate');

        break;
    }
  }

  setKeybinding(keybinding) {
    switch(keybinding) {
      case 'ace':
        this.editor.setKeyboardHandler(null);

        break;
      case 'vim':
        this.editor.setKeyboardHandler('ace/keyboard/vim');

        break;
      case 'emacs':
        this.editor.setKeyboardHandler('ace/keyboard/emacs');

        break;
    }
  }

  setUseWrapMode(value) {
    switch(value) {
      case false:
      case 'false':
        this.editor.getSession().setUseWrapMode(false);
        break;

      default:
        this.editor.getSession().setUseWrapMode(true);
    }
  }

  exportFile() {
    const file = {}
    file[this.filename] = this.editor.getValue();

    return file;
  }

  focus() {
    this.editor.focus();
  }

  isFocused() {
    return this.editor.isFocused();
  }

  addCommand(opts) {
    this.editor.commands.addCommand(opts);
  }

  _setup() {
    this.editor = ace.edit(this.element[0]);

    this.editor.setShowPrintMargin(false);
    this.editor.session.setOptions(this.config);

    this.onSetup(this);
  }
}

export default AceEditor;
