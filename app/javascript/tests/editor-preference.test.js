import EditorPreference from '../src/editor-preference';

test('clicking a button sets the value', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="vim"></option>
        <button value="emacs"></option>
      </form>
    </body>
  `;

  const select = new EditorPreference($('form'), 'keybinding');
  $('button[value=vim]').click();

  expect(select.getValue()).toEqual('vim');
});

test('#change adds a handler when the value changes', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="vim"></option>
        <button value="emacs"></option>
      </form>
    </body>
  `;

  const select = new EditorPreference($('form'), 'keybinding');
  const handler = jest.fn();
  select.change(handler);

  select.set('vim');
  select.trigger('change');

  expect(handler).toHaveBeenCalledWith('vim');
});

test('#set saves value to local database', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="vim"></option>
        <button value="emacs"></option>
      </form>
    </body>
  `;

  const select = new EditorPreference($('form'), 'keybinding');
  const command = jest.fn();
  const database = { setItem: command, getItem: jest.fn() }
  select.database = database;

  select.set('vim');

  expect(command).toHaveBeenCalledWith('keybinding', 'vim');
});

test('#set highlights buttons', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="vim"></option>
        <button value="emacs"></option>
      </form>
    </body>
  `;

  const select = new EditorPreference($('form'), 'keybinding');

  select.set('vim');

  expect($('button[value=vim]').attr('selected')).toEqual('selected');
  expect($('button[value=emacs]').attr('selected')).toEqual(undefined);
});

test('#getValue() loads value from local database', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="vim"></option>
        <button value="emacs"></option>
      </form>
    </body>
  `;

  const select = new EditorPreference($('form'), 'keybinding');
  const command = jest.fn().mockReturnValueOnce('vim');
  const database = { getItem: command, setItem: jest.fn() }
  select.database = database;

  expect(select.getValue()).toEqual('vim');
});
