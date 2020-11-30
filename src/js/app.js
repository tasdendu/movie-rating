App = {
  web3Provider: null,
  contracts: {},

  init: async function () {
    return await App.initWeb3();
  },

  initWeb3: async function () {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error('User denied account access');
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function () {
    $.getJSON('MovieRating.json', function (data) {
      // Get the necessary contract artifact file and instantiate it with @truffle/contract
      App.contracts.MovieRating = TruffleContract(data);

      // Set the provider for our contract
      App.contracts.MovieRating.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted movies
      return App.addMovies();
    });

    return App.bindEvents();
  },

  bindEvents: function () {
    $(document).on('click', '.btn-rate', App.assignValue);
    $(document).on('click', '#rate-it', App.rateMovie);
  },

  addMovies: function () {
    // Load movies.
    $.getJSON('../movies.json', function (data) {
      var moviesRow = $('#moviesRow');
      var movieTemplate = $('#movieTemplate');

      for (i = 0; i < data.length; i++) {
        movieTemplate.find('.panel-title').text(data[i].name);
        movieTemplate.find('img').attr('src', data[i].picture);
        movieTemplate.find('.movie-id').text(data[i].id);
        movieTemplate.find('.movie-name').text(data[i].name);
        movieTemplate.find('.btn-rate').attr('data-id', data[i].id);

        moviesRow.append(movieTemplate.html());
      }
    });

    return App.showRating();
  },

  showRating: function () {
    let MovieRatingInstance;

    App.contracts.MovieRating.deployed().then(function (instance) {
      MovieRatingInstance = instance;

      return MovieRatingInstance.getAverageMovieRatings.call();
    }).then(function (movieRatings) {
      for (let i = 0; i < movieRatings.length; i++) {
        var moviePanel = $('.panel-movie').eq(i);
        // Bind the total rating here.
        moviePanel.find('#static-rating').val(movieRatings[i].c[0]);
        var star_rating = moviePanel.find('.star-rating .fa');

        star_rating.each(function () {
          if (parseInt(star_rating.siblings('input.rating-value').val()) >= parseInt($(this).data('rating'))) {
            return $(this).removeClass('fa-star-o').addClass('fa-star');
          } else {
            return $(this).removeClass('fa-star').addClass('fa-star-o');
          }
        });
      }
    }).catch(function (err) {
      console.log(err.message);
    });
  },

  rateMovie: function () {
    var movieId = parseInt($('.movie-id').val());
    var rating = parseInt($('#star-rate').val());

    var MovieRatingInstance;

    web3.eth.getAccounts(function (error, accounts) {
      if (error) {
        console.log(error);
      }
      var account = accounts[0];

      App.contracts.MovieRating.deployed().then(function (instance) {
        MovieRatingInstance = instance;

        // Execute adopt as a transaction by sending account
        return MovieRatingInstance.rateMovie(movieId, rating, { from: account });
      }).then(function (result) {
        $('#myModal').modal('hide');
        $('.star-rating1 .fa').removeClass('fa-star').addClass('fa-star-o');
        return App.showRating();
      }).catch(function (err) {
        $('#myModal').modal('hide');
        $('.star-rating1 .fa').removeClass('fa-star').addClass('fa-star-o');
        console.log(err.message);
      });
    });
  },

  assignValue: function (event) {
    var movieId = parseInt($(event.target).data('id'));
    $('.movie-id').val(movieId);
  }
};

$(function () {
  $(window).load(function () {
    App.init();
  });
});
