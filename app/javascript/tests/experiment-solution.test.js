import ExperimentSolution from '../src/experiment-solution';

test('it calls commands when a hotkey is pressed', () => {
  document.body.innerHTML = `
    <div class="experiment-solution">
      <div class="info-panel"></div>
      <div class="coding-panel"></div>
    </div>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
  solution.editor = { isFocused: () => false };
  const command = jest.fn();
  solution.setCommand('?', command);

  document.dispatchEvent(new KeyboardEvent('keydown', { key: '?'}));

  expect(command).toHaveBeenCalled();
})

test ('it sets the body class to prism-dark when dark theme is selected', () => {
  document.body.innerHTML = `
    <body>
      <div class="experiment-solution">
        <div class="info-panel"></div>
        <div class="coding-panel"></div>
        <select class="js-theme-select">
          <option value="dark"></option>
          <option value="light"></option>
        </select>
      </div>
    </body>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
  $('select').val('dark').trigger('change');

  expect($('body').attr('class')).toEqual('prism-dark');
});

test ('removes the body class prism-dark when light theme is selected', () => {
  document.body.innerHTML = `
    <body class="prism-dark">
      <div class="experiment-solution">
        <div class="info-panel"></div>
        <div class="coding-panel"></div>
        <select class="js-theme-select">
          <option value="dark"></option>
          <option value="light"></option>
        </select>
      </div>
    </body>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
  $('select').val('light').trigger('change');

  expect($('body').attr('class')).toEqual('');
});

test('it opens keyboard shortcuts modal', () => {
  document.body.innerHTML = `
    <div class="experiment-solution">
      <div class="info-panel"></div>
      <div class="coding-panel"></div>
    </div>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
  solution.editor = { isFocused: () => false };
  solution.openShortcuts();

  expect($('.keyboard-shortcuts').length).toEqual(1);
})

test('it does not open keyboard shortcuts modal twice', () => {
  document.body.innerHTML = `
    <div class="experiment-solution">
      <div class="info-panel"></div>
      <div class="coding-panel"></div>
    </div>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
  solution.editor = { isFocused: () => false };
  solution.openShortcuts();
  solution.openShortcuts();

  expect($('.keyboard-shortcuts').length).toEqual(1);
})

test('it does not open keyboard shortcuts modal when editor is focused', () => {
  document.body.innerHTML = `
    <div class="experiment-solution">
      <div class="info-panel"></div>
      <div class="coding-panel">
        <div class="js-code-editor"></div>
      </div>
    </div>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
  solution.editor = { isFocused: () => true };
  solution.openShortcuts();

  expect($('.keyboard-shortcuts').length).toEqual(0);
})

test('it focuses to body after rendering the keyboard shortcuts modal', () => {
  document.body.innerHTML = `
    <div class="experiment-solution">
      <div class="info-panel"></div>
      <div class="coding-panel"></div>
    </div>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
  solution.editor = { isFocused: () => false };
  solution.openShortcuts();

  expect($('.keyboard-shortcuts').length).toEqual(1);
})
