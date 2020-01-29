import KeybindingSelect from '../src/keybinding-select';

test('clicking a button sets the keybinding', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="vim"></option>
        <button value="emacs"></option>
      </form>
    </body>
  `;

  const select = new KeybindingSelect($('form'));
  $('button[value=vim]').click();

  expect(select.getKeybinding()).toEqual('vim');
});

test('#change adds a handler when the keybinding changes', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="vim"></option>
        <button value="emacs"></option>
      </form>
    </body>
  `;

  const select = new KeybindingSelect($('form'));
  const handler = jest.fn();
  select.change(handler);

  select.set('vim');
  select.trigger('change');

  expect(handler).toHaveBeenCalledWith('vim');
});

test('#set saves keybinding to local database', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="vim"></option>
        <button value="emacs"></option>
      </form>
    </body>
  `;

  const select = new KeybindingSelect($('form'));
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

  const select = new KeybindingSelect($('form'));

  select.set('vim');

  expect($('button[value=vim]').attr('selected')).toEqual('selected');
  expect($('button[value=emacs]').attr('selected')).toEqual(undefined);
});

test('#getKeybinding() loads keybinding from local database', () => {
  document.body.innerHTML = `
    <body>
      <form onsubmit="return false;">
        <button value="vim"></option>
        <button value="emacs"></option>
      </form>
    </body>
  `;

  const select = new KeybindingSelect($('form'));
  const command = jest.fn().mockReturnValueOnce('vim');
  const database = { getItem: command, setItem: jest.fn() }
  select.database = database;

  expect(select.getKeybinding()).toEqual('vim');
});
