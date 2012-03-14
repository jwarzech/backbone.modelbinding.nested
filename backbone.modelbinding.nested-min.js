/*
//  Backbone.ModelBinding.Nested 0.1.0
//  
//  (c) 2012 Jordan Warzecha
//  Distributed under the MIT license.
//
//  Documentation and full license available at:
//  http://gitub.com/jwarzech/backbone.modelbinding.nested
*/
var _this=this;Backbone.Model.prototype.setByName=function(b,c,a){var d;d={};d[b]=c;return this.set(d,a)};Backbone.Collection.prototype.isCollection=function(){return true};Backbone.ModelBinding.parseNestedTokens=function(b,d){var c,e,a;e=d.shift();b=b.get(e);c=d.shift();if(b.get(c)&&(b.get(c).isCollection!=null)){a=Backbone.ModelBinding.parseNestedTokens(b.get(c),d);b=a.entity;c=a.attribute}return{entity:b,attribute:c}};Backbone.ModelBinding.nestedHandler={bind:function(a,b,c){return b.$(a).each(function(f,h){var g,e,d,i,j=this;i=h.id.split("-");if(i.length===1){e=c;g=_.first(i)}else{e=c.get(i.shift());d=Backbone.ModelBinding.parseNestedTokens(e,i);e=d.entity;g=d.attribute}$(this).change(function(){if($(j).val()!==e.get(g)){return e.setByName(g,$(j).val())}});e.bind("change:"+g,function(){if(e.get(g)!==$(j).val()){return $(j).val(e.get(g))}});return $(this).val(e.get(g))})}};Backbone.ModelBinding.Conventions.text.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.password.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.radio.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.checkbox.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.select.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.textarea.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.number.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.range.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.tel.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.search.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.url.handler=Backbone.ModelBinding.nestedHandler;Backbone.ModelBinding.Conventions.email.handler=Backbone.ModelBinding.nestedHandler;