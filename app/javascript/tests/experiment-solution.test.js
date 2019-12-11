import ExperimentSolution from '../src/experiment-solution';

test('it calls commands when a hotkey is pressed', () => {
  document.body.innerHTML = `
    <div class="experiment-solution">
      <div class="description-panel"></div>
      <div class="solution-panel"></div>
    </div>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
  solution.editor = { isFocused: () => false };
  const command = jest.fn();
  solution.setCommand('?', command);

  document.dispatchEvent(new KeyboardEvent('keydown', { key: '?'}));

  expect(command).toHaveBeenCalled();
})

test('it opens keyboard shortcuts modal', () => {
  document.body.innerHTML = `
    <div class="experiment-solution">
      <div class="description-panel"></div>
      <div class="solution-panel"></div>
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
      <div class="description-panel"></div>
      <div class="solution-panel"></div>
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
      <div class="description-panel"></div>
      <div class="solution-panel">
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
      <div class="description-panel"></div>
      <div class="solution-panel"></div>
    </div>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
  solution.editor = { isFocused: () => false };
  solution.openShortcuts();

  expect($('.keyboard-shortcuts').length).toEqual(1);
})
