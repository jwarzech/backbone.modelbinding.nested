/*
//  Backbone.ModelBinding.Nested 0.2.0
//  
//  (c) 2012 Jordan Warzecha
//  Distributed under the MIT license.
//
//  Documentation and full license available at:
//  http://github.com/jwarzech/backbone.modelbinding.nested
*/
var _this = this;

Backbone.Model.prototype.setByName = function(key, value, options) {
  var setter;
  setter = {};
  setter[key] = value;
  return this.set(setter, options);
};

Backbone.Model.prototype.bindingId = function() {
  if (this.id != null) {
    return this.id;
  } else {
    return this.cid;
  }
};

Backbone.Collection.prototype.isCollection = function() {
  return true;
};

Backbone.Collection.prototype.safeGet = function(id) {
  if (this.get(id) != null) {
    return this.get(id);
  } else {
    return this.getByCid(id);
  }
};

Backbone.Model.prototype.buildCollection = function(attribute, collection) {
  if (this.has(attribute) && this.get(attribute).length > 0) {
    this.setByName(attribute, new collection(this.get(attribute)));
  } else {
    this.setByName(attribute, new collection());
  }
  return this.get(attribute).parent = this;
};

Backbone.Model.prototype.safeGet = function(attribute) {
  return this.get(attribute);
};

Backbone.ModelBinding.parseNestedTokens = function(entity, tokens) {
  var attribute, id, result;
  id = tokens.shift();
  entity = entity.safeGet(id);
  attribute = tokens.shift();
  if (entity.safeGet(attribute) && (entity.safeGet(attribute).isCollection != null)) {
    result = Backbone.ModelBinding.parseNestedTokens(entity.safeGet(attribute), tokens);
    entity = result.entity;
    attribute = result.attribute;
  }
  return {
    entity: entity,
    attribute: attribute
  };
};

Backbone.ModelBinding.nestedHandler = {
  bind: function(selector, view, model) {
    return view.$(selector).each(function(index, value) {
      var attribute, entity, result, tokens,
        _this = this;
      tokens = value.id.split("-");
      if (tokens.length === 1) {
        entity = model;
        attribute = _.first(tokens);
      } else {
        entity = model.safeGet(tokens.shift());
        result = Backbone.ModelBinding.parseNestedTokens(entity, tokens);
        entity = result.entity;
        attribute = result.attribute;
      }
      $(this).change(function() {
        if ($(_this).val() !== entity.safeGet(attribute)) {
          return entity.setByName(attribute, $(_this).val());
        }
      });
      entity.bind("change:" + attribute, function() {
        if (entity.safeGet(attribute) !== $(_this).val()) {
          return $(_this).val(entity.safeGet(attribute));
        }
      });
      return $(this).val(entity.safeGet(attribute));
    });
  }
};

Backbone.ModelBinding.Conventions.text.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.password.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.radio.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.checkbox.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.select.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.textarea.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.number.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.range.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.tel.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.search.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.url.handler = Backbone.ModelBinding.nestedHandler;

Backbone.ModelBinding.Conventions.email.handler = Backbone.ModelBinding.nestedHandler;
