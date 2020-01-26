class PageThemeSelect {
  constructor(form) {
    this.darkBtn = form.find('button[value=dark]');
    this.lightBtn = form.find('button[value=light]');
    this.theme = form.data('theme');

    this.darkBtn.click(function(e) {
      this.set('dark')
      this.lightBtn.attr("selected", false)
      this.darkBtn.attr("selected", true)
    }.bind(this));

    this.lightBtn.click(function(e) {
      this.set('light')
      this.darkBtn.attr("selected", false)
      this.lightBtn.attr("selected", true)
    }.bind(this));
  }

  set(theme) {
    this.theme = theme;

    this._swapBodyClass();
    this._swapThemeStylesheets();
  }

  change(handler) {
    this.darkBtn.on('click', function(e) { handler('dark') });
    this.lightBtn.on('click', function(e) { handler('light') });
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
}

export default PageThemeSelect;
