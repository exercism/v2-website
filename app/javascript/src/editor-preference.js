class EditorPreference {
  constructor(form, key) {
    this.form = form;
    this.key = key;
    this.database = localStorage;
    this.buttons = this.form.find('button');

    this.buttons.on('click', (e) => { this.set(e.target.value); });
  }

  load() {
    this.trigger('change');
  }

  set(value) {
    this._save(value);
    this._highlightButton(value);
  }

  trigger(e) {
    const button = this.buttons.toArray().find((button) => {
      return button.value == this.getValue();
    });

    if(e == 'change') { $(button).trigger('click'); }
  }

  change(handler) {
    this.buttons.on('click', function(e) { handler(e.target.value) });
  }

  getValue() {
    return this.database.getItem(this.key);
  }

  _save(value) {
    this.database.setItem(this.key, value);
  }

  _highlightButton() {
    this.buttons.toArray().forEach((button) => {
      $(button).attr('selected', button.value == this.getValue());
    });
  }
}

export default EditorPreference;
