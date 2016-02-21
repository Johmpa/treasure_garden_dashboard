class Dashing.Sltrafficsituation extends Dashing.Widget

  ready: ->
    console.log("Yarr ready")
    # This is fired when the widget is done being rendered

  onData: (data) ->
    console.log("I haz a data")
    @setValueClassByEventType("#metro", data.Metro.StatusIcon)

  setValueClassByEventType: (trafficType, statusIcon) ->
    console.log("setValueClassByEventType" + trafficType + ", " + statusIcon)
    classNames = $(trafficType).attr("class").split " "

    for className in classNames
      match = /value-(.*)/.exec className
      $(trafficType).removeClass match[0] if match


    resultingclass = "value-standard"
    resultingclass = "value-disturbance" if statusIcon != "EventGood"

    console.log("Result-class for " + trafficType + ": " + resultingclass)
    $(trafficType).addClass resultingclass

# Handle incoming data
# You can access the html node of this widget with `@node`
# Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.