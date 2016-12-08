class Dashing.Tvseriestoday extends Dashing.Widget

  ready: ->
    @currentIndex = 0
    @headlineElem = $(@node).find('.episode-container')
    @nextComment()
    @startCarousel()

  onData: (data) ->
    @currentIndex = 0

  startCarousel: ->
    interval = $(@node).attr('data-interval')
    interval = "30" if not interval
    setInterval(@nextComment, parseInt( interval ) * 1000)

  nextComment: =>
    episodes = @get('episodes')
    if episodes
      @headlineElem.fadeOut =>
        @currentIndex = (@currentIndex + 1) % episodes.length
        @set 'current_episode', episodes[@currentIndex]
        @headlineElem.fadeIn()