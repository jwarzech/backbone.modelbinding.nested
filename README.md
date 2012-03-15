#Backbone.ModelBinding.Nested

Adds support for two-way data binding properties of deeply nested models using [Derick Bailey's](https://github.com/derickbailey) awesome [backbone.modelbinding](https://github.com/derickbailey/backbone.modelbinding) library.
  
##Getting Started

###Dependencies
*Note: make sure you reference in this order*

* jQuery v1.7.1
* Underscore.js v1.3.1
* Backbone.js v0.9.1
* Backbone.ModelBinding v0.5.0

###Installing

Download `backbone.modelbinding.nested-min.js` from the git repository and copy it into your application's javascript folder.  Make sure to reference *after* `backbone.modelbinding.js`.

##Nested Binding

Backbone.ModelBinding.Nested overrides the existing model binding conventions for the following types:

* text
* password
* radio
* checkbox
* select
* textarea
* number
* range
* tel
* search
* url
* email

###Setting up your model

The nested binding will only work on child collections that  inherit from `Backbone.Collection` and will not work with array properties.

For models having child collections you will need to construct a Backbone collection from the object array.

````
class Example.Question extends Backbone.Model
  initialize: ->
    @buildCollection('answers', Example.Answers)
````

###Setting up your view

In the view that renders your root model call `Backbone.ModelBinding.bind(this)` after you render your template.

````
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
`````

###Setting up your template

For binding your root model's properties simply set the id of each form element to the name of the property.

````
<input type="text" id='title' />
````

For binding properties of child collections the pattern to use is: *collection name*-*collection id*-*property name*

For example if our root model has a collection of __answers__ and we want to data bind the __user__ property for __answer__ having __id__=2:

````
<input type="text" id="answers-2-user" />
````

This pattern can be repeated for deeply nested collections.  For example if and __answer__ has a collection of __comments__ and we wanted to data bind the __user__ property for the __comment__ having __id__=4:

````
<input type="text" id="answers-2-comments-4-user" />
````

##Example Application

Under the /example directory you will find a simple sample application demonstrating three level deep nested binding.  The actual backbone.js code is writen in coffescript and can be found in /example/app/example.coffee.  All of the underscore.js templates are in the /example/public/index.html file.

![screenshot](https://github.com/jwarzech/backbone.modelbinding.nested/raw/master/example/public/images/screenshot.png)

The sample app uses sample data (from [stackexchange](http://data.stackexchange.com/)) consisting of questions having answers that have comments.

To demonstrate that the binding is working, modify the form contents and click 'Refresh' to see that the data source was changed.

##Release Notes

###v0.2.0

* Fixed issue of binding newly created models by adding the __Backbone.Collection.safeGet__ method and __Backbone.Model.bindingId__ method to utilize the object's  cid if an id is unavailable.

* Added __Backbone.Model.buildCollection(attribute, collection)__ helper method that helps build child collections that have a reference to their parent.

* Updated the example app and documentation to demonstrate the updates.

###v0.1.0

* Initial Release

##MIT License

Copyright (C) 2012 Jordan Warzecha

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.