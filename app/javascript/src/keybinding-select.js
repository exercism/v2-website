class KeybindingSelect {
  constructor(form) {
    this.form = form;
    this.database = localStorage;
    this.buttons = this.form.find('button');

    this.buttons.on('click', function(e) {
      this.set(e.target.value);
    }.bind(this));
  }

  set(value) {
    this._save(value);
    this._highlightButton(value);
  }

  trigger(e) {
    const button = this.buttons.toArray().find((button) => {
      return button.value == this.getKeybinding();
    });

    if(e == 'change') { $(button).trigger('click'); }
  }

  change(handler) {
    this.buttons.on('click', function(e) { handler(e.target.value) });
  }

  getKeybinding() {
    return this.database.getItem('keybinding');
  }

  _save(value) {
    this.database.setItem('keybinding', value);
  }

  _highlightButton() {
    this.buttons.toArray().forEach((button) => {
      $(button).attr('selected', button.value == this.getKeybinding());
    });
  }
}

export default KeybindingSelect;
