import AceEditor from '../src/ace-editor';

test('it sets the dark theme', () => {
  const editor = new AceEditor(null, null, null);
  const setTheme = jest.fn();
  const fakeAce = { setTheme: setTheme };
  editor.editor = fakeAce;

  editor.setTheme('dark');

  expect(setTheme).toHaveBeenCalledWith('ace/theme/tomorrow_night_bright');
});

test('it sets the light theme', () => {
  const editor = new AceEditor(null, null, null);
  const setTheme = jest.fn();
  const fakeAce = { setTheme: setTheme };
  editor.editor = fakeAce;

  editor.setTheme('light');

  expect(setTheme).toHaveBeenCalledWith('ace/theme/textmate');
});
