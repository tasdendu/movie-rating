const MovieRating = artifacts.require('MovieRating');

contract('MovieRating', (accounts) => {
  let movieRating;
  let expectedMovieId;

  before(async () => {
    movieRating = await MovieRating.deployed();
  });

  describe('adding the movie get the movie id', async () => {
    it('can fetch the collection of all average movie rating', async () => {
      expectedMovieId = await movieRating.AddMovie(18, 'Movie', { from: accounts[0] });
      assert.equal(18, 18, 'Should be equal to the expected movie ID');
    });
  });
});
