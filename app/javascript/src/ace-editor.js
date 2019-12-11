class AceEditor {
  constructor(element, language, filename) {
    this.element = element
    this.language = language
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
    this.editor.session.setMode(`ace/mode/${this.language}`);

    this.onSetup(this);
  }
}

export default AceEditor;