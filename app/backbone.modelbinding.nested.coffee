###
//  Backbone.ModelBinding.Nested 0.3.0
//  
//  (c) 2012 Jordan Warzecha
//  Distributed under the MIT license.
//
//  Documentation and full license available at:
//  http://github.com/jwarzech/backbone.modelbinding.nested
###

# Extend the backbone model class to add a method that allows setting an attribute by name
Backbone.Model::setByName = (key, value, options) ->
  setter = {}
  setter[key] = value
  @set setter, options

# Extend the backbone model class to add a method that returns the cid if there is no id present
Backbone.Model::bindingId = ->
  if @id? then @id else @cid

# Extend the backbone collection class to add a method that returns true when asked if its a collection
Backbone.Collection::isCollection = ->
  return true
  
# Extend the backbone collection class to add a 'get' alternative method that also checks 'getByCid'
Backbone.Collection::safeGet = (id) ->
  if @get(id)? then @get(id) else @getByCid(id)
  
# Extend the backbone collection class with a helper method that builds a child collection
Backbone.Model::buildCollection = (attribute, collection) ->
  if @has(attribute) && @get(attribute).length > 0
    @setByName(attribute, new collection(@get(attribute)))
  else
    @setByName(attribute, new collection())
  @get(attribute).parent = this

# Extend the backbone model class with an alias to its 'get' method, just makes code easier/shorter than if we had to constantly check for 'isCollection'
Backbone.Model::safeGet = (attribute) ->
  return @get(attribute)

# Accepts a backbone model and a parsed UI selector and returns the 
# nested entity and attribute
Backbone.ModelBinding.parseNestedTokens = (entity, tokens) ->
  id = tokens.shift()
  entity = entity.safeGet(id)
  attribute = tokens.shift()
  
  if entity.safeGet(attribute) && entity.safeGet(attribute).isCollection?
    result = Backbone.ModelBinding.parseNestedTokens(entity.safeGet(attribute), tokens)  
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
        entity = model.safeGet(tokens.shift())
        result = Backbone.ModelBinding.parseNestedTokens(entity, tokens)
        entity = result.entity
        attribute = result.attribute
          
      isCheckbox = $(this).prop("tagName") == 'INPUT' && $(this).prop("type") == 'checkbox'
          
      # Setup binding UI -> model
      $(this).change =>
        if isCheckbox && $(this).prop('checked') != entity.safeGet(attribute)
          value = $(this).prop('checked')
        else if $(this).val() != entity.safeGet(attribute)
          value = $(this).val()
          
        entity.setByName(attribute, value) if value?
      
      # Setup binding model -> UI
      entity.bind "change:#{attribute}", =>
        if isCheckbox && entity.safeGet(attribute) != $(this).prop('checked')
          $(this).prop('checked', entity.safeGet(attribute))
        else if entity.safeGet(attribute) != $(this).val()
          $(this).val(entity.safeGet(attribute))
      
      # Initialize binding
      if isCheckbox
        $(this).prop('checked', entity.safeGet(attribute))
      else 
        $(this).val(entity.safeGet(attribute))
      
# Setup nested binding conventions
Backbone.ModelBinding.Conventions.text.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.textarea.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.password.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.checkbox.handler = Backbone.ModelBinding.nestedHandler
Backbone.ModelBinding.Conventions.select.handler = Backbone.ModelBinding.nestedHandler
