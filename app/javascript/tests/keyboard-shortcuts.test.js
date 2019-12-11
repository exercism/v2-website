import KeyboardShortcuts from '../src/keyboard_shortcuts';

test('it runs a function after render', () => {
  const shortcuts = new KeyboardShortcuts();
  const command = jest.fn();
  shortcuts.onRender = command;

  shortcuts.render();

  expect(command).toHaveBeenCalled();
});
