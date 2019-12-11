import ExperimentSolution from '../src/experiment-solution';

test('it calls commands when a hotkey is pressed', () => {
  document.body.innerHTML = `
    <div class="experiment-solution">
      <div class="description-panel"></div>
      <div class="solution-panel"></div>
    </div>
  `;

  const solution = new ExperimentSolution($('.experiment-solution'));
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
  solution.openShortcuts();

  expect($('.keyboard-shortcuts').length).toEqual(1);
})
