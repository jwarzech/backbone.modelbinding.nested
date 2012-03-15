(function() {
  var __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.Example = {
    Models: {},
    Collections: {},
    Views: {},
    Routers: {},
    init: function() {
      new Example.Router();
      return Backbone.history.start();
    }
  };

  $(document).ready(function() {
    return Example.init();
  });

  Example.Router = (function(_super) {

    __extends(Router, _super);

    function Router() {
      Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      '': 'index'
    };

    Router.prototype.index = function() {
      var indexView;
      indexView = new Example.IndexView({
        collection: new Example.Questions(Example.SampleData)
      });
      return $('#content').html(indexView.render().el);
    };

    return Router;

  })(Backbone.Router);

  Example.Question = (function(_super) {

    __extends(Question, _super);

    function Question() {
      Question.__super__.constructor.apply(this, arguments);
    }

    Question.prototype.initialize = function() {
      return this.buildCollection('answers', Example.Answers);
    };

    return Question;

  })(Backbone.Model);

  Example.Answer = (function(_super) {

    __extends(Answer, _super);

    function Answer() {
      Answer.__super__.constructor.apply(this, arguments);
    }

    Answer.prototype.initialize = function() {
      return this.buildCollection('comments', Example.Comments);
    };

    return Answer;

  })(Backbone.Model);

  Example.Comment = (function(_super) {

    __extends(Comment, _super);

    function Comment() {
      Comment.__super__.constructor.apply(this, arguments);
    }

    return Comment;

  })(Backbone.Model);

  Example.Questions = (function(_super) {

    __extends(Questions, _super);

    function Questions() {
      Questions.__super__.constructor.apply(this, arguments);
    }

    Questions.prototype.model = Example.Question;

    return Questions;

  })(Backbone.Collection);

  Example.Answers = (function(_super) {

    __extends(Answers, _super);

    function Answers() {
      Answers.__super__.constructor.apply(this, arguments);
    }

    Answers.prototype.model = Example.Answer;

    return Answers;

  })(Backbone.Collection);

  Example.Comments = (function(_super) {

    __extends(Comments, _super);

    function Comments() {
      Comments.__super__.constructor.apply(this, arguments);
    }

    Comments.prototype.model = Example.Comment;

    return Comments;

  })(Backbone.Collection);

  Example.IndexView = (function(_super) {

    __extends(IndexView, _super);

    function IndexView() {
      this.render = __bind(this.render, this);
      this.refreshSource = __bind(this.refreshSource, this);
      IndexView.__super__.constructor.apply(this, arguments);
    }

    IndexView.prototype.initialize = function() {
      var _this = this;
      return $('#refresh').click(function() {
        return _this.refreshSource();
      });
    };

    IndexView.prototype.refreshSource = function() {
      return $('.src').html(JSON.stringify(this.collection, void 0, 2));
    };

    IndexView.prototype.render = function() {
      var _this = this;
      this.collection.each(function(question) {
        var view;
        view = new Example.QuestionView({
          model: question
        });
        return $(_this.el).append(view.render().el);
      });
      this.refreshSource();
      return this;
    };

    return IndexView;

  })(Backbone.View);

  Example.QuestionView = (function(_super) {

    __extends(QuestionView, _super);

    function QuestionView() {
      this.render = __bind(this.render, this);
      this.close = __bind(this.close, this);
      QuestionView.__super__.constructor.apply(this, arguments);
    }

    QuestionView.prototype.className = "question";

    QuestionView.prototype.events = {
      'click .add-answer': 'addAnswer'
    };

    QuestionView.prototype.addAnswer = function() {
      this.model.get('answers').add(new Example.Answer());
      return this.render();
    };

    QuestionView.prototype.close = function() {
      this.unbind();
      Backbone.ModelBinding.unbind(this);
      return this.remove();
    };

    QuestionView.prototype.render = function() {
      var _this = this;
      $(this.el).html(_.template($('#question').html())(this.model));
      this.model.get('answers').each(function(answer) {
        var view;
        view = new Example.AnswerView({
          model: answer
        });
        view.bind('render', function() {
          return _this.render();
        });
        return $(_this.el).find('.answers').append(view.render().el);
      });
      Backbone.ModelBinding.bind(this);
      return this;
    };

    return QuestionView;

  })(Backbone.View);

  Example.AnswerView = (function(_super) {

    __extends(AnswerView, _super);

    function AnswerView() {
      this.render = __bind(this.render, this);
      AnswerView.__super__.constructor.apply(this, arguments);
    }

    AnswerView.prototype.events = {
      'click .add-comment': 'addComment'
    };

    AnswerView.prototype.addComment = function() {
      this.model.get('comments').add(new Example.Comment());
      return this.trigger('render');
    };

    AnswerView.prototype.render = function() {
      var _this = this;
      $(this.el).html(_.template($('#answers').html())(this.model));
      this.model.get('comments').each(function(comment) {
        var view;
        view = new Example.CommentView({
          model: comment
        });
        return $(_this.el).find('.comments').append(view.render().el);
      });
      return this;
    };

    return AnswerView;

  })(Backbone.View);

  Example.CommentView = (function(_super) {

    __extends(CommentView, _super);

    function CommentView() {
      this.render = __bind(this.render, this);
      CommentView.__super__.constructor.apply(this, arguments);
    }

    CommentView.prototype.render = function() {
      $(this.el).html(_.template($('#comments').html())(this.model));
      return this;
    };

    return CommentView;

  })(Backbone.View);

}).call(this);
