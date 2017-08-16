window.setupWalkthrough = (walkthrough) ->
  $header = $('#modal.solution-walkthrough .header')
  $content = $('#modal.solution-walkthrough .content')
  $buttons = $('#modal.solution-walkthrough .buttons')

  flags = []

  executeStep = (stepCode) =>
    step = walkthrough[stepCode]
    $header.html(step.header)
    $content.html(step.content)
    $buttons.html("")
    for [answer, nextStepPaths, flag] in step.answers
      $button = $("<button class='pure-button'>\#{answer}</button>")
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
                console.log(flags)
                console.log(nextStepPath)
                if flags.indexOf(nextStepPath[0]) != -1
                  executeStep(nextStepPath[1])
                  break

      $buttons.append($button)

  executeStep("start")

