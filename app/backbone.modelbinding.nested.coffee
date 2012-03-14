###
//  Backbone.ModelBinding.Nested 0.1.0
//  
//  (c) 2012 Jordan Warzecha
//  Distributed under the MIT license.
//
//  Documentation and full license available at:
//  http://gitub.com/jwarzech/backbone.modelbinding.nested
###

# Extend the backbone model class to add a method that allows setting an attribute by name
Backbone.Model::setByName = (key, value, options) ->
  setter = {}
  setter[key] = value
  @set setter, options

# Extend the backbone collection class to add a method that returns true when asked if its a collection
Backbone.Collection::isCollection = ->
  return true

# Accepts a backbone model and a parsed UI selector and returns the 
# nested entity and attribute
Backbone.ModelBinding.parseNestedTokens = (entity, tokens) ->
  id = tokens.shift()
  entity = entity.get(id)
  attribute = tokens.shift()
  
  if entity.get(attribute) && entity.get(attribute).isCollection?
    result = Backbone.ModelBinding.parseNestedTokens(entity.get(attribute), tokens)  
    entity = result.entity
    attribute = result.attribute
    
  return { entity: entity, attribute: attribute }

# Custom two-way databinding convention for handling nested collections
# Might want to revisit the 'proper' framework way of implementing the 
# two-way binding however the jQuery way is pretty short code and works
# well
Backbone.ModelBinding.nestedHandler = 
  bind: (selector, view, model) =>
    view.$(selector).each (index, value) ->  
      tokens = value.id.split("-")
      # Parent attribute
      if tokens.length == 1
        entity = model
        attribute = _.first(tokens)
      # Child attribute
      # recursive format -> collection-id-attribute
      else
        entity = model.get(tokens.shift())
        result = Backbone.ModelBinding.parseNestedTokens(entity, tokens)
        entity = result.entity
        attribute = result.attribute
          
      # Setup binding UI -> model
      $(this).change =>
        if $(this).val() != entity.get(attribute)
          # console.log 'UI -> model'
          entity.setByName(attribute, $(this).val())
      
      # Setup binding model -> UI
      entity.bind "change:#{attribute}", =>
        if entity.get(attribute) != $(this).val()
          # console.log 'model -> UI'
          $(this).val(entity.get(attribute))
      
      # Initialize binding
      $(this).val(entity.get(attribute))
      
# Setup nested binding conventions
Backbone.ModelBinding.Conventions.text.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.password.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.radio.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.checkbox.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.select.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.textarea.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.number.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.range.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.tel.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.search.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.url.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.email.handler = Backbone.ModelBinding.nestedHandler
