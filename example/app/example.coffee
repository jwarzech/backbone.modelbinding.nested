window.Example =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  init: ->
    new Example.Router()
    Backbone.history.start()
    
$(document).ready ->
  Example.init()
  
# Router
class Example.Router extends Backbone.Router
  routes:
    '' : 'index'
  
  index: ->
    indexView = new Example.IndexView(collection: new Example.Questions(Example.SampleData))
    $('#content').html(indexView.render().el)

# Models
class Example.Question extends Backbone.Model
  initialize: ->
    if @has('answers') && @get('answers').length > 0
      @set 'answers' : new Example.Answers(@get('answers'))
    else
      @set 'answers' : new Example.Answers()
  
class Example.Answer extends Backbone.Model
  initialize: ->
    if @has('comments') && @get('comments').length > 0
      @set 'comments' : new Example.Comments(@get('comments'))
    else
      @set 'comments' : new Example.Comments()
  
class Example.Comment extends Backbone.Model
  
# Collections
class Example.Questions extends Backbone.Collection
  model: Example.Question
  
class Example.Answers extends Backbone.Collection
  model: Example.Answer

class Example.Comments extends Backbone.Collection
  model: Example.Comment
  
# Views
class Example.IndexView extends Backbone.View
  initialize: ->
    $('#refresh').click => @refreshSource()
      
  refreshSource: =>
    $('.src').html(JSON.stringify(@collection, undefined, 2))
  
  render: =>
    @collection.each (question) =>
      view = new Example.QuestionView(model: question)
      $(@el).append(view.render().el)
      
    @refreshSource()
    return this
    
class Example.QuestionView extends Backbone.View
  className: "question"
    
  close: =>
    @unbind()
    Backbone.ModelBinding.unbind(this)
    @remove()
  
  render: =>
    $(@el).html(_.template($('#question').html())(@model))
    @model.get('answers').each (answer) =>
      view = new Example.AnswerView(model: answer)
      $(@el).find('.answers').append(view.render().el)
    Backbone.ModelBinding.bind(this)
    return this
    
class Example.AnswerView extends Backbone.View
  render: =>
    $(@el).html(_.template($('#answers').html())(@model))
    @model.get('comments').each (comment) =>
      view = new Example.CommentView(model: comment)
      $(@el).find('.comments').append(view.render().el)
    return this
    
class Example.CommentView extends Backbone.View
  render: =>
    $(@el).html(_.template($('#comments').html())(@model))
    return this
    