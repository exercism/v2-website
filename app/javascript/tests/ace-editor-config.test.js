import AceEditorConfig from '../src/ace-editor-config';

test('it sets the mode', () => {
  const config = new AceEditorConfig({
    language: 'ruby'
  });

  expect(config.mode).toEqual('ace/mode/ruby');
});

test('it sets the tab size', () => {
  const config = new AceEditorConfig({
    indent_size: 7
  });

  expect(config.tabSize).toEqual(7);
});

test('it sets soft tabs', () => {
  const config = new AceEditorConfig({ indent_style: 'space' });

  expect(config.useSoftTabs).toEqual(true);
});

test('it does not set soft tabs', () => {
  const config = new AceEditorConfig({ indent_style: 'tab' });

  expect(config.useSoftTabs).toEqual(false);
});
