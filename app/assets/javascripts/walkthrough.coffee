window.setupWalkthrough = (walkthrough, authToken, exerciseCommand) ->
  $header = $('#modal.solution-walkthrough .header')
  $content = $('#modal.solution-walkthrough .content')
  $buttons = $('#modal.solution-walkthrough .buttons')

  flags = []

  executeStep = (stepCode) =>
    return closeModal() if stepCode == "close"

    step = walkthrough[stepCode]
    $header.html(step.header)
    $content.html(parseContent(step.content))
    $buttons.html("")
    for [answer, nextStepPaths, flag] in step.answers
      $button = $("<button class='pure-button'>#{answer}</button>")
      do (nextStepPaths, flag) ->
        $button.click =>
          flags.push(flag) if flag
          if typeof(nextStepPaths) == "string"
            executeStep(nextStepPaths)
          else
            for nextStepPath in nextStepPaths
              if typeof(nextStepPath) == "string"
                executeStep(nextStepPath)
                break
              else
                if flags.indexOf(nextStepPath[0]) != -1
                  executeStep(nextStepPath[1])
                  break

      $buttons.append($button)

  parseContent = (content) =>
    content.replace("{authToken}", authToken)
    content.replace("{exerciseCommand}", exerciseCommand)

  executeStep("start")

