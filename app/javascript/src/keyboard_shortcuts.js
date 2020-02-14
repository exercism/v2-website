class KeyboardShortcuts {
  constructor() {
    this.handler = (e) => { if(e.key === 'Escape') { this.remove(); } }

    $(document).on('keydown', 'body', this.handler);
  }

  render() {
    this.container = $(`
      <div class="overlay">
        <div class="keyboard-shortcuts">
          <div class="keyboard-shortcuts-content">
            <h1>Keyboard shortcuts</h1>
            <table>
              <tr>
                <td>Run code</td>
                <td><code>Shift</code> + <code>Enter</code></td>
              </tr>
            </table>
          </div>
        </div>
        <div class="overlay-close">
          <i class="fa-times fal" />
          <a href="#" title="Close" class="js-overlay-close">Close</a>
        </div>
      </div>
    `).appendTo('body');

    this.onRender();

    this._setupActions();
  }

  remove() {
    this.container.remove();
    this.container = undefined;

    $(document).off('keydown', 'body', this.handler);
  }

  _setupActions() {
    this.
      container.
      find('.js-overlay-close').
      click(() => { this.remove(); });
  }
}

export default KeyboardShortcuts;
