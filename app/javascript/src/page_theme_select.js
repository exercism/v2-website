class PageThemeSelect {
  constructor(form) {
    this.buttons = form.find('button');
    this.theme = form.data('theme');

    this.buttons.click((e) => { this.set(e.target.value); });
  }

  set(theme) {
    this.theme = theme;

    this._swapBodyClass();
    this._swapThemeStylesheets();
    this._highlightButton();
  }

  trigger(e) {
    const button = this.buttons.toArray().find((button) => {
      return button.value == this.theme
    });

    if(e == 'change') { $(button).trigger('click'); }
  }

  change(handler) {
    this.buttons.click(function (e) { handler(e.target.value) });
  }

  _swapBodyClass() {
    if (this.theme == 'dark') {
      $('body').addClass('prism-dark');
    } else {
      $('body').removeClass('prism-dark');
    }
  }

  _swapThemeStylesheets() {
    const stylesheets = $('link[rel=stylesheet][data-theme]')

    stylesheets.each(function(index, stylesheet) {
      var stylesheet = $(stylesheet)

      if (stylesheet.attr('data-theme') == this.theme) {
        stylesheet.removeAttr('disabled');
      } else {
        stylesheet.attr('disabled', 'disabled');
      }
    }.bind(this));
  }

  _highlightButton() {
    this.buttons.toArray().forEach((button) => {
      $(button).attr('selected', button.value == this.theme);
    });
  }
}

export default PageThemeSelect;
