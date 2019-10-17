function setupSolution(solutionID, iterationID) {
  setupTabs();
  setupNewEditableText('discussionPost-' + solutionID + '-' + iterationID);
}

window.setupSolution = setupSolution;
