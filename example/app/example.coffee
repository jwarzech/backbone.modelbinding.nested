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
    @buildCollection('answers', Example.Answers)
  
class Example.Answer extends Backbone.Model
  initialize: ->
    @buildCollection('comments', Example.Comments)
  
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
    
  events:
    'click .add-answer' : 'addAnswer'
    
  addAnswer: ->
    @model.get('answers').add(new Example.Answer())
    @render()
 
  close: =>
    @unbind()
    Backbone.ModelBinding.unbind(this)
    @remove()
  
  render: =>
    $(@el).html(_.template($('#question').html())(@model))
    @model.get('answers').each (answer) =>
      view = new Example.AnswerView(model: answer)
      view.bind('render', => @render())
      $(@el).find('.answers').append(view.render().el)
      
    Backbone.ModelBinding.bind(this)
    return this
    
class Example.AnswerView extends Backbone.View
  events:
    'click .add-comment' : 'addComment'
  
  addComment: ->
    @model.get('comments').add(new Example.Comment())
    @trigger('render')
    
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
    